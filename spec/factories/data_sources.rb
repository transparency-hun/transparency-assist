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

FactoryGirl.define do
  factory :data_source do
    sequence(:name) { |n| "source_#{n}" }
    association :data_table
  end
end
