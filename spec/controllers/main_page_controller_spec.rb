# frozen_string_literal: true
require 'rails_helper'

RSpec.describe MainPageController, type: :controller do
  describe 'GET index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end

    it 'returns a 200 status code' do
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET show' do
    let(:data_table) { FactoryGirl.create(:data_table) }

    it 'renders the show template' do
      get :show, params: { data_table_id: data_table.id }
      expect(response).to render_template('show')
    end

    it 'returns a 200 status code' do
      get :show, params: { data_table_id: data_table.id }
      expect(response).to have_http_status(200)
    end

    it 'returns a 404 status code for invalid data table id' do
      get :show, params: { data_table_id: nil }
      expect(response).to have_http_status(404)
    end
  end
end
