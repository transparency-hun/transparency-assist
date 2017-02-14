# frozen_string_literal: true
class InvalidCategory < StandardError
  def initialize(crawler = nil, category = nil, valid_categories = [])
    msg = "Category '#{category}' is invalid for #{crawler}, " \
          "valid categories are: #{valid_categories.to_a.join(', ')}"
    super(msg)
  end
end
