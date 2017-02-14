# frozen_string_literal: true
class MainPageController < ApplicationController
  def index
    @categories = Category.all

    @selected_category = if params[:category_id].present?
                           Category.find_by(id: params[:category_id])
                         end

    if @selected_category
      @filtered_data_tables = DataTable.confirmed.ordered_by_year.where(category: @selected_category)
    else
      @filtered_data_tables = DataTable.confirmed.ordered_by_newest
    end
  end

  def show
    @data_table = DataTable.find(params[:data_table_id])
  rescue ActiveRecord::RecordNotFound
    render file: 'public/404.html', status: :not_found, layout: false
  end
end
