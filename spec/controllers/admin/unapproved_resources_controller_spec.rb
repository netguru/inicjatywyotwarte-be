# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UnapprovedResourcesController, type: :controller do
  let(:logged_in_admin_user) { FactoryBot.create(:admin_user) }

  before { sign_in logged_in_admin_user }

  describe 'GET index' do
    let!(:resources) { FactoryBot.create_list(:resource, 5) }

    render_views

    shared_examples 'renders index' do
      it 'renders without errors' do
        get :index
        expect(response).to be_successful
        assert_select 'table.index tbody' do |trs|
          trs.each_with_index do |element, i|
            assert_select element, 'td.col-name', resources[i].name
            assert_select element, 'td.col-description', resources[i].description
          end
        end
      end
    end

    context 'when user is super_admin' do
      include_examples 'renders index'
    end

    context 'when user is not super_admin' do
      let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }
      include_examples 'renders index'
    end
  end

  describe 'GET show' do
    let!(:resource) { FactoryBot.create(:resource) }

    context 'when rendered' do
      render_views

      shared_examples 'renders show' do
        it 'renders without errors' do
          get :show, params: { id: resource.id }
          expect(response).to be_successful
          assert_select 'tr.row.row-name td', resource.name
          assert_select 'tr.row.row-description td', resource.description
        end
      end

      context 'when user is super_admin' do
        include_examples 'renders show'
      end

      context 'when user is not super_admin' do
        let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }
        include_examples 'renders show'
      end
    end
  end

  describe 'GET edit' do
    let!(:resource) { FactoryBot.create(:resource) }

    context 'when rendered' do
      render_views

      shared_examples 'renders edit' do
        it 'renders without errors' do
          get :edit, params: { id: resource.id }
          expect(response).to be_successful
          assert_select 'textarea#resource_description', resource.description
        end
      end

      context 'when user is super_admin' do
        include_examples 'renders edit'
      end

      context 'when user is not super_admin' do
        let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }
        include_examples 'renders edit'
      end
    end
  end

  describe 'GET new' do
    shared_examples 'renders new' do
      it 'renders without errors' do
        get :new
        expect(response).to be_successful
        assert_select 'textarea#resource_description', ''
      end
    end

    context 'when rendered' do
      render_views

      context 'when user is super_admin' do
        include_examples 'renders new'
      end

      context 'when user is not super_admin' do
        let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }
        include_examples 'renders new'
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
