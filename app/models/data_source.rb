# frozen_string_literal: true
# == Schema Information
#
# Table name: data_sources
#
#  id                :integer          not null, primary key
#  name              :string
#  data_table_id     :integer          not null
#  changeset_headers :hstore           default([]), is an Array
#  changeset         :jsonb
#  last_fetched_at   :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  preview           :string           default([]), is an Array
#  diff              :jsonb
#  confirmed         :boolean          default(FALSE), not null
#

require 'diff_checker'

class DataSource < ApplicationRecord
  PREVIEW_MAX_SIZE = 1000

  belongs_to :data_table, required: true
  delegate :title, to: :data_table

  before_create :set_preview,
                unless: proc { |ds| ds.changeset.empty? || ds.changeset_headers.empty? }

  before_create :set_diff,
                unless: proc { |ds| ds.previous_data_source.nil? }

  after_create :set_data_table_preview,
               unless: proc { |ds| ds.preview.empty? }

  scope :confirmed, -> { where(confirmed: true) }
  scope :ordered_by_newest, -> { order('updated_at desc') }

  def to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << changeset_headers.map { |header| header['display'] }

      changeset.each do |row|
        csv << changeset_headers.map { |header| row[header['crawler_key']] }
      end
    end
  end

  def to_array
    data = []
    data << changeset_headers.map { |header| header['display'] }
    changeset.each do |data_hash|
      row = []
      changeset_headers.each do |header_info|
        row << data_hash[header_info['crawler_key']]
      end
      data << row
    end
    data
  end

  def diff_to_array
    header_row = [I18n.t('changeset_headers.diff.position', raise: true),
                  I18n.t('changeset_headers.diff.type', raise: true)]
    header_row.concat(changeset_headers.map { |header| header['display'] })
    data = [header_row]
    diff.each do |change|
      row = change_to_row(change)
      data << row.unshift(change['position'])
    end
    data
  end

  def previous_data_source
    data_table.data_sources
              .order(created_at: :desc)
              .find_by('created_at < ?', created_at)
  end

  def preview_with_diff
    diffed_preview = []
    preview.each { |row| diffed_preview << row.dup.unshift('') }
    add_changes_to_preview(diffed_preview)
  end

  private

  def set_preview
    preview = []
    preview << changeset_headers.map { |header| header['display'] }
    changeset[0...PREVIEW_MAX_SIZE].each do |row|
      preview << changeset_headers.map { |header| sanitize_and_linkify(header, row) }
    end
    self.preview = preview
  end

  def sanitize_and_linkify(header, row)
    if header['crawler_key'] == 'link'
      %(<a href="#{sanitize row[header['crawler_key']]}" target="_blank">#{header['display']}</a>)
    else
      sanitize row[header['crawler_key']]
    end
  end

  def sanitize(str)
    ActionController::Base.helpers.sanitize str.try(:to_s)
  end

  def set_diff
    self.diff = DiffChecker.new(previous_data_source.changeset, changeset).diff
  end

  def set_data_table_preview
    data_table.update!(preview: preview)
  end

  def add_changes_to_preview(diffed_preview)
    deleted_rows_inserted = 0
    diff.each do |change|
      break if change['position'] > PREVIEW_MAX_SIZE
      if change['type'] == '+'
        # Preview index is same as change position since a header row is present in preview
        diffed_preview[change_position_in_diffed_preview(change, deleted_rows_inserted)][0] = '+'
      elsif change['type'] == '-'
        diffed_preview.insert(change_position_in_diffed_preview(change, deleted_rows_inserted), change_to_row(change))
        deleted_rows_inserted += 1
      end
    end
    diffed_preview
  end

  def change_position_in_diffed_preview(change, deleted_rows_inserted)
    change['position'] + deleted_rows_inserted
  end

  def change_to_row(change)
    row = changeset_headers.map { |header| change['value'][header['crawler_key']] }
    row.unshift(change['type'])
  end
end
