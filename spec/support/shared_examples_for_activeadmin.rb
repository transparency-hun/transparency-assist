# frozen_string_literal: true
RSpec.shared_examples 'an activeadmin resource' do
  include Devise::Test::ControllerHelpers
  render_views

  let(:admin) { create(:admin) }

  let(:resource) { create(resource_name) }

  before(:each) do
    sign_in admin
  end

  describe 'index' do
    let!(:collection) { create_list(resource_name, 3) }

    it 'renders the resource list' do
      get :index

      expect(assigns(collection_name)).not_to be_empty
    end
  end

  describe 'show' do
    it 'renders the resource details' do
      get :show, params: { id: resource.to_param }

      expect(assigns(resource_name)).to eq resource
    end
  end

  describe 'new' do
    it 'renders the resource form' do
      get :new

      expect(assigns(resource_name)).not_to be_nil
    end
  end

  describe 'create' do
    it 'creates a resource' do
      post :create, params: { resource_name => create_params }

      expect(assigns(resource_name)).to be_persisted
    end
  end

  describe 'edit' do
    it 'renders the resource form' do
      get :edit, params: { id: resource.to_param }

      expect(assigns(resource_name)).to eq resource
    end
  end

  describe 'update' do
    it 'updates the resource' do
      patch :update, params: { id: resource.to_param, resource_name => update_params }
      resource.reload

      update_params.each do |attr_name, attr_value|
        expect(resource.send(attr_name)).to eq attr_value
      end
    end
  end

  describe 'delete' do
    it 'deletes the resource' do
      delete :show, params: { id: resource.to_param }

      expect(assigns(resource_name)).to eq resource
    end
  end
end
