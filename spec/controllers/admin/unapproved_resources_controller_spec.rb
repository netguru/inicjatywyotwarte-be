# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UnapprovedResourcesController, type: :controller do
  let(:logged_in_admin_user) { FactoryBot.create(:admin_user) }

  before { sign_in logged_in_admin_user }

  describe 'GET index' do
    before do
      FactoryBot.create_list(:resource, 5)
    end

    render_views

    it 'renders without errors' do
      get :index
      expect(response).to be_successful
    end

    context 'when user is not super_admin' do
      let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }

      it 'renders' do
        get :index
        expect(response).to be_successful
      end
    end
  end

  describe 'GET show' do
    let!(:resource) { FactoryBot.create(:resource) }

    context 'when rendered' do
      render_views

      it 'renders without errors' do
        get :show, params: { id: resource.id }
        expect(response).to be_successful
      end
    end

    context 'when user is not super_admin' do
      let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }

      it 'renders' do
        get :show, params: { id: resource.id }
        expect(response).to be_successful
      end
    end
  end

  describe 'GET edit' do
    let!(:resource) { FactoryBot.create(:resource) }

    it 'renders without errors' do
      get :edit, params: { id: resource.id }
      expect(response).to be_successful
    end

    context 'when user is not super_admin' do
      let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }

      it 'renders' do
        get :edit, params: { id: resource.id }
        expect(response).to be_successful
      end
    end
  end

  describe 'GET new' do
    it 'renders without errors' do
      get :new
      expect(response).to be_successful
    end

    context 'when user is not super_admin' do
      let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }

      it 'renders' do
        get :new
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:resource) { FactoryBot.create(:resource) }

    it 'renders without errors' do
      delete :destroy, params: { id: resource.id }
      expect(response).to redirect_to(admin_unapproved_resources_path)
    end

    context 'when user is not super_admin' do
      let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }

      it 'doesnt allow' do
        delete :destroy, params: { id: resource.id }
        expect(response).not_to be_successful
      end
    end
  end

  describe 'PATCH update' do
    let!(:resource) { FactoryBot.create(:resource, name: 'name') }
    let(:params) do
      {
        id: resource.id,
        resource: {
          name: 'new_name'
        }
      }
    end

    it 'updated record' do
      expect { patch :update, params: params }
        .to change { resource.reload.name }
        .from('name').to('new_name')
    end

    it 'renders without errors' do
      patch :update, params: params
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_unapproved_resource_path(resource))
    end

    context 'when user is not super_admin' do
      let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }

      it 'renders' do
        patch :update, params: params
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_unapproved_resource_path(resource))
      end
    end
  end

  describe 'PUT approve' do
    let!(:resource) { FactoryBot.create(:resource, name: 'name') }

    it 'updated record' do
      expect { put :approve, params: { id: resource.id } }
        .to change { resource.reload.is_approved }
        .from(false).to(true)
    end

    it 'renders without errors' do
      put :approve, params: { id: resource.id }
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_unapproved_resources_path)
    end

    context 'when user is super_reviewer' do
      let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }

      it 'approves' do
        patch :update, params: { id: resource.id }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_unapproved_resource_path(resource))
      end
    end

    context 'when user is reviewer' do
      let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }

      it 'doesnt approve' do
        patch :update, params: { id: resource.id }
        expect(response).not_to be_successful
      end
    end
  end

  describe 'PUT create' do
    let(:attributes) { FactoryBot.attributes_for(:resource) }
    let(:params) do
      {
        resource: attributes
      }
    end

    it 'creates record' do
      expect { put :create, params: params }
        .to change(Resource, :count).by(1)
    end

    it 'renders without errors' do
      put :create, params: params
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_unapproved_resource_path(Resource.last))
    end

    context 'when user is not super_admin' do
      let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }

      it 'renders' do
        put :create, params: params
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_unapproved_resource_path(Resource.last))
      end
    end
  end
end
