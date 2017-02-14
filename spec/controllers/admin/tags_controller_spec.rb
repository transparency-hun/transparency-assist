# frozen_string_literal: true
require 'rails_helper'
require_relative '../../support/shared_examples_for_activeadmin'

RSpec.describe Admin::TagsController, type: :controller do
  it_behaves_like 'an activeadmin resource' do
    let(:resource_name) { :tag }
    let(:collection_name) { :tags }

    let(:create_params) { { name: 'some tag' } }
    let(:update_params) { { name: 'some other tag' } }
  end
end
