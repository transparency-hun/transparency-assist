# frozen_string_literal: true
require 'rails_helper'
require_relative '../../support/shared_examples_for_activeadmin'

RSpec.describe Admin::CategoriesController, type: :controller do
  it_behaves_like 'an activeadmin resource' do
    let(:resource_name) { :category }
    let(:collection_name) { :categories }

    let(:create_params) { { name: 'some category' } }
    let(:update_params) { { name: 'some other category' } }
  end
end
