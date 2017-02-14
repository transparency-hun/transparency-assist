# frozen_string_literal: true
class DataTablesController < ApplicationController
  def create
    @data_table = load_category.data_tables.new(data_table_params)

    if captcha_verified? && @data_table.save
      alert = { type: 'success',
                message: 'Köszönjük! Sikeresen feltöltötted a táblázatot, ' \
                         'ami jóváhagyás után fog megjelenni az oldalon.' }
      @data_table = DataTable.new
    else
      alert = { type: 'danger',
                message: 'Hiba történt! Kérjük próbáld újra!' }
    end

    respond_to do |format|
      format.html
      format.js { render 'new', locals: { alert: alert } }
    end
  end

  def download
    @data_table = DataTable.find(params[:data_table_id])

    if @data_table.official?
      redirect_to_data_source_download
    else
      render 'main_page/index'
      send_file(Paperclip.io_adapters.for(@data_table.data_sheet).path,
                type: @data_table.data_sheet_content_type,
                disposition: 'attachment',
                filename: @data_table.data_sheet_file_name)
    end
  end

  def new
    @data_table = DataTable.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show_preview_with_diff
    @data_table = DataTable.find_by(id: params[:data_table_id])
    @data_sources = @data_table.data_sources.confirmed.ordered_by_newest
    @hide_diff = params[:hide_diff]
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def data_table_params
    params.require(:data_table).permit(:title, :description, :source,
                                       :data_sheet, :uploader_email,
                                       :terms_of_service)
  end

  def redirect_to_data_source_download
    if @data_table.last_confirmed_data_source.present?
      redirect_to download_data_source_url(@data_table.last_confirmed_data_source, format: :xls)
    else
      redirect_to root_url
    end
  end

  def captcha_verified?
    verify_recaptcha(model: @data_table) || Rails.env.development?
  end

  def load_category
    @category ||= Category.find_by!(name: 'Feltöltött')
  end
end
