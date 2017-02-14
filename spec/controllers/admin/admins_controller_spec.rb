# frozen_string_literal: true
require 'rails_helper'
require_relative '../../support/shared_examples_for_activeadmin'

RSpec.describe Admin::AdminsController, type: :controller do
  it_behaves_like 'an activeadmin resource' do
    let(:resource_name) { :admin }
    let(:collection_name) { :admins }

    let(:create_params) do
      { email: 'some_admin@example.com',
        password: 'password',
        password_confirmation: 'password' }
    end
    let(:update_params) { { email: 'some_other_admin@example.com' } }
  end
end
