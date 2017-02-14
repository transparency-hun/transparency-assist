# frozen_string_literal: true
class Crawler < ActiveRecord::Base
  def self.columns
    @columns ||= []
  end
end
