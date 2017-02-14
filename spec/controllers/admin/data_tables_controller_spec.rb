# frozen_string_literal: true
require 'rails_helper'
require_relative '../../support/shared_examples_for_activeadmin'

RSpec.describe Admin::DataTablesController, type: :controller do
  include ActionDispatch::TestProcess

  it_behaves_like 'an activeadmin resource' do
    let(:resource_name) { :data_table }
    let(:collection_name) { :data_tables }

    let(:category_1) { create(:category) }
    let(:category_2) { create(:category) }
    let(:tags) { create_list(:tag, 3) }

    let(:create_params) do
      { title: 'wonderful data',
        category_id: category_1.id,
        data_sheet: fixture_file_upload(Rails.root.join('spec', 'data', 'sample.csv'), 'text/csv') }
    end
    let(:update_params) do
      { title: 'more wonderful data',
        description: 'such wonderful data',
        confirmed: true,
        official: true,
        recent: true,
        highlighted: true,
        category_id: category_2.id,
        tag_ids: tags.map(&:id) }
    end
  end
end
