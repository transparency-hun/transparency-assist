# frozen_string_literal: true
class DataSourcesController < ApplicationController
  before_action :set_data_source

  def download
    redirect_to root_url && return unless @data_source.confirmed?
    respond_to do |format|
      format.xls do
        send_xls(@data_source.to_array, "#{@data_source.data_table.title.parameterize}.xls")
      end
    end
  end

  def download_diff
    redirect_to root_url && return unless @data_source.confirmed? && @data_source.diff.any?
    respond_to do |format|
      format.xls do
        send_xls(@data_source.diff_to_array, "#{@data_source.data_table.title.parameterize}_changes.xls")
      end
    end
  end

  private

  def send_xls(data, filename)
    send_data XlsGenerator.new(data).to_xls.string,
              filename: filename,
              type: 'application/vnd.ms-excel'
  end

  def set_data_source
    @data_source = DataSource.find(params[:id])
  end
end
