# frozen_string_literal: true
# == Schema Information
#
# Table name: taggings
#
#  id            :integer          not null, primary key
#  tag_id        :integer          not null
#  data_table_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Tagging, type: :model do
  let(:subject) { build(:tagging) }

  describe 'connections' do
    it { is_expected.to belong_to(:tag) }
    it { is_expected.to belong_to(:data_table) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:tag_id).scoped_to(:data_table_id) }
    it { is_expected.to validate_uniqueness_of(:data_table_id).scoped_to(:tag_id) }
  end
end
