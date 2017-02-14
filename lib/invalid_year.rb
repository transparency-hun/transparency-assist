# frozen_string_literal: true
class InvalidYear < StandardError
  def initialize(crawler = nil, year = nil, valid_years = [])
    msg = "Year '#{year}' is invalid for #{crawler}, " \
          "valid years are: #{valid_years.to_a.join(', ')}"
    super(msg)
  end
end
