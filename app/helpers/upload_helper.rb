# frozen_string_literal: true
module UploadHelper
  def category_options
    [[]].concat(Category.all.map { |category| [category.name, category.id] })
  end
end
