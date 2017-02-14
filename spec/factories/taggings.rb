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

FactoryGirl.define do
  factory :tagging do
    association :tag
    association :data_table
  end
end
