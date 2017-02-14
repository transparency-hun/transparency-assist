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

require 'rails_helper'

RSpec.describe DataTable, type: :model do
  let(:subject) { build(:data_table) }

  describe 'connections' do
    it { is_expected.to belong_to(:admin) }
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:taggings).dependent(:destroy) }
    it { is_expected.to have_many(:tags).through(:taggings) }
    it { is_expected.to have_many(:data_sources) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:category).with_message('must exist') }
    it { is_expected.not_to validate_presence_of(:admin) }
    it { is_expected.to validate_presence_of(:title) }
  end

  describe '#data_has_changed' do
    let(:changeset1) { ['name' => 'a'] }
    let(:changeset1a) { [name: 'a'] }
    let(:changeset2) { ['name' => 'b'] }

    context 'there is no data_source yet' do
      it 'is true' do
        expect(subject.data_has_changed(changeset1)).to be true
      end
    end

    context 'there is already a data_source' do
      let(:data_table) { create(:data_table) }
      let!(:data_source) { create(:data_source, changeset: changeset1, data_table: data_table) }

      it 'is true if the new changeset is different' do
        expect(data_table.data_has_changed(changeset2)).to be true
      end

      it 'is false if the new changeset is the same' do
        expect(data_table.data_has_changed(changeset1)).to be false
      end

      it 'is false if the new changeset with stringified keys is the same' do
        expect(data_table.data_has_changed(changeset1a)).to be false
      end
    end
  end
end
