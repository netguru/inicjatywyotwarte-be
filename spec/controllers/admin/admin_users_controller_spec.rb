# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::AdminUsersController, type: :controller do
  let(:logged_in_admin_user) { FactoryBot.create(:admin_user) }

  before { sign_in logged_in_admin_user }

  describe 'GET index' do
    before do
      FactoryBot.create_list(:admin_user, 5)
    end

    render_views

    it 'renders without errors' do
      get :index
      expect(response).to be_successful
    end

    context 'when user is not super_admin' do
      let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }

      it 'doesnt render' do
        get :index
        expect(response).not_to be_successful
      end
    end
  end

  describe 'GET show' do
    let!(:admin_user2) { FactoryBot.create(:admin_user) }

    context 'when rendered' do
      render_views

      it 'renders without errors' do
        get :show, params: { id: admin_user2.id }
        expect(response).to be_successful
      end
    end

    context 'when user is not super_admin' do
      let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }

      it 'doesnt render' do
        get :show, params: { id: admin_user2.id }
        expect(response).not_to be_successful
      end
    end
  end

  describe 'GET edit' do
    let!(:admin_user2) { FactoryBot.create(:admin_user) }

    it 'renders without errors' do
      get :edit, params: { id: admin_user2.id }
      expect(response).to be_successful
    end

    context 'when user is not super_admin' do
      let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }

      it 'doesnt render' do
        get :edit, params: { id: admin_user2.id }
        expect(response).not_to be_successful
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

      it 'doesnt render' do
        get :new
        expect(response).not_to be_successful
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:admin_user2) { FactoryBot.create(:admin_user) }

    it 'renders without errors' do
      delete :destroy, params: { id: admin_user2.id }
      expect(response).to redirect_to(admin_admin_users_path)
    end

    context 'when user is not super_admin' do
      let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }

      it 'doesnt render' do
        delete :destroy, params: { id: admin_user2.id }
        expect(response).not_to be_successful
      end
    end
  end
end
