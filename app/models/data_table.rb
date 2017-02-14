# frozen_string_literal: true
# == Schema Information
#
# Table name: data_tables
#
#  id                      :integer          not null, primary key
#  admin_id                :integer
#  category_id             :integer          not null
#  title                   :string           not null
#  description             :text             default("")
#  official                :boolean          default(FALSE)
#  confirmed               :boolean          default(FALSE)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  data_sheet_file_name    :string
#  data_sheet_content_type :string
#  data_sheet_file_size    :integer
#  data_sheet_updated_at   :datetime
#  preview                 :string           default([]), is an Array
#  source                  :string
#  last_fetched_at         :datetime
#  changeset_headers       :hstore           default([]), is an Array
#  recent                  :boolean          default(FALSE), not null
#  highlighted             :boolean          default(FALSE), not null
#  uploader_email          :string
#  year                    :integer
#

require 'xls_csv_reader'

class DataTable < ApplicationRecord
  belongs_to :admin
  belongs_to :category, required: true
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :data_sources, dependent: :destroy

  has_attached_file :data_sheet

  validates_attachment :data_sheet,
                       content_type: { content_type: ['text/plain',
                                                      'text/csv',
                                                      'application/vnd.ms-office',
                                                      'application/vnd.ms-excel',
                                                      'application/vnd.openxmlformats-' \
                                                      'officedocument.spreadsheetml.sheet',
                                                      'application/vnd.oasis.opendocument.spreadsheet'] },
                       file_name: { matches: [/txt/, /csv/, /xls/, /ods/] },
                       size: { in: 0..100.megabytes }

  do_not_validate_attachment_file_type :data_sheet
  validates_attachment :data_sheet, presence: true, unless: :official?
  validates :title, presence: true
  validates :terms_of_service, acceptance: true

  before_update :create_preview, unless: 'official?'

  scope :confirmed, -> { where(confirmed: true) }
  scope :ordered_by_newest, -> { order('updated_at desc') }
  scope :ordered_by_year, -> { order(year: :desc, title: :asc) }

  def last_confirmed_data_source
    data_sources.confirmed.ordered_by_newest.first
  end

  def data_has_changed(changeset)
    previous_changeset = data_sources.order(created_at: :desc).first.try(:changeset)
    changeset.map(&:stringify_keys) != previous_changeset
  end

  def update_changeset_headers!(keys)
    update!(changeset_headers: keys_to_changeset_headers(keys))
  end

  private

  def keys_to_changeset_headers(keys)
    keys.each_with_object([]) do |key, changeset_headers|
      changeset_headers << {
        'display' => I18n.t("changeset_headers.#{source.parameterize(separator: '_')}.#{key}", raise: true),
        'crawler_key' => key.to_s
      }
    end
  end

  def create_preview
    return unless confirmed_changed? && confirmed?
    file = data_sheet.path
    self.preview = XlsCsvReader
                   .new(file: file, rows: DataSource::PREVIEW_MAX_SIZE)
                   .to_array
  rescue StandardError => e
    Rails.logger.debug "Preview cannot be created for DataTable ##{id}"
    Rails.logger.debug "#{e.class.name} happened:\n #{e.message}\n"
  end
end
