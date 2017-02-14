# frozen_string_literal: true
require 'spreadsheet'

class XlsGenerator
  def initialize(data)
    @data = data
  end

  def to_xls
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet name: 'Data'
    @data.each_with_index do |row, i|
      sheet.row(i).concat row
    end
    file_contents = StringIO.new
    book.write file_contents
    file_contents
  end
end
