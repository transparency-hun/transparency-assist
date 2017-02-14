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

require 'rails_helper'

RSpec.describe DataSource, type: :model do
  let(:subject) { build(:data_source) }

  describe 'connections' do
    it { is_expected.to belong_to(:data_table) }
    it { should delegate_method(:title).to(:data_table) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:data_table).with_message('must exist') }
  end

  describe '#previous_data_source' do
    let!(:data_table1) { create(:data_table) }
    let!(:data_table2) { create(:data_table) }

    context 'previous data sources are present from the same data table' do
      let!(:data_source1) { create(:data_source, data_table: data_table1) }
      let!(:data_source2) { create(:data_source, data_table: data_table1) }
      let!(:data_source2a) { create(:data_source, data_table: data_table2) }
      let!(:data_source3) { create(:data_source, data_table: data_table1) }
      let!(:data_source4) { create(:data_source, data_table: data_table1) }

      it 'is the previous data source from the same data table' do
        expect(data_source3.previous_data_source).to eq data_source2
      end
    end

    context 'previous data sources are not present from the same data table' do
      let!(:data_source1) { create(:data_source, data_table: data_table2) }
      let!(:data_source2) { create(:data_source, data_table: data_table1) }
      let!(:data_source3) { create(:data_source, data_table: data_table1) }

      it 'is nil' do
        expect(subject.previous_data_source).to be nil
      end
    end
  end
end
