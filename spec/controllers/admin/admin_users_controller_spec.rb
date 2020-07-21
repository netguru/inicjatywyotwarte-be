# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::AdminUsersController, type: :controller do
  let(:logged_in_admin_user) { FactoryBot.create(:admin_user) }

  before { sign_in logged_in_admin_user }

  describe 'GET index' do
    let!(:admin_users) { FactoryBot.create_list(:admin_user, 5) }

    render_views

    it 'renders without errors' do
      get :index
      expect(response).to be_successful
      assert_select 'table.index tbody' do |trs|
        trs.each_with_index do |element, i|
          assert_select element, 'td.col-email', admin_users[i].email
        end
      end
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
        assert_select 'tr.row.row-email td', admin_user2.email
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

    context 'when rendered' do
      render_views

      it 'renders without errors' do
        get :edit, params: { id: admin_user2.id }
        expect(response).to be_successful
        assert_select '#admin_user_email[value=?]', admin_user2.email
      end
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
    context 'when rendered' do
      render_views

      it 'renders without errors' do
        get :new
        expect(response).to be_successful
        assert_select '#admin_user_email[value=?]', ''
      end
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
