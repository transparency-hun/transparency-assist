# frozen_string_literal: true
require 'rails_helper'

RSpec.describe DataTablesController, type: :controller do
  describe 'GET download' do
    let(:data_table) { FactoryGirl.create(:data_table) }

    it 'sends the correct file' do
      get :download, params: { data_table_id: data_table.id }
      expect(response.body).to eq(Paperclip.io_adapters.for(data_table.data_sheet).read)
    end

    it 'returns a 200 status code' do
      get :download, params: { data_table_id: data_table.id }
      expect(response).to have_http_status(200)
    end
  end
end
