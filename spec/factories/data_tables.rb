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

FactoryGirl.define do
  factory :data_table do
    association :category
    sequence(:title) { |n| "sculptures in Budapest #{n}" }
    description 'lorem lorem hipster sculptures'

    data_sheet { File.new("#{Rails.root}/spec/data/sample.csv") }

    trait :confirmed do
      confirmed true
    end

    trait :official do
      official true
    end

    trait :user_content do
      official false
    end

    factory :official_data_table, traits: [:confirmed, :official]
    factory :confirmed_thirdparty_data_table, traits: [:confirmed, :user_content]
  end
end
