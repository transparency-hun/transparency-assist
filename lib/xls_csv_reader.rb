# frozen_string_literal: true
require 'roo'

class XlsCsvReader
  def initialize(file:, rows: nil)
    @file = file
    @rows = rows
  end

  def to_array
    book = Roo::Spreadsheet.open @file
    sheet = book.sheet 0
    data = []
    sheet.each_with_index do |row, i|
      break if @rows && i >= @rows
      data << row.map { |cell| ActionController::Base.helpers.sanitize cell.try(:to_s) }
    end
    data
  end
end
