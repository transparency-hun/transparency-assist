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

class Tagging < ApplicationRecord
  belongs_to :tag, required: true
  belongs_to :data_table, required: true

  validates :tag_id, uniqueness: { scope: :data_table_id }
  validates :data_table_id, uniqueness: { scope: :tag_id }
end
