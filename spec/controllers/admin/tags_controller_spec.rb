# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::TagsController, type: :controller do
  let(:logged_in_admin_user) { FactoryBot.create(:admin_user) }

  before { sign_in logged_in_admin_user }

  describe 'GET index' do
    let!(:tags) { FactoryBot.create_list(:tag, 5) }

    render_views

    it 'renders without errors' do
      get :index
      expect(response).to be_successful
      assert_select 'table.index tbody' do |trs|
        trs.each_with_index do |element, i|
          assert_select element, 'td.col-name', tags[i].name
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
    let!(:tag) { FactoryBot.create(:tag) }

    context 'when rendered' do
      render_views

      it 'renders without errors' do
        get :show, params: { id: tag.id }
        expect(response).to be_successful
        assert_select 'tr.row.row-name td', tag.name
      end
    end

    context 'when user is not super_admin' do
      let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }

      it 'doesnt render' do
        get :show, params: { id: tag.id }
        expect(response).not_to be_successful
      end
    end
  end

  describe 'GET edit' do
    let!(:tag) { FactoryBot.create(:tag) }

    context 'when rendered' do
      render_views

      it 'renders without errors' do
        get :edit, params: { id: tag.id }
        expect(response).to be_successful
        assert_select '#acts_as_taggable_on_tag_name[value=?]', tag.name
      end
    end

    context 'when user is not super_admin' do
      let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }

      it 'doesnt render' do
        get :edit, params: { id: tag.id }
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
        assert_select '#acts_as_taggable_on_tag_name'
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
    let!(:tag) { FactoryBot.create(:tag) }

    it 'renders without errors' do
      delete :destroy, params: { id: tag.id }
      expect(response).to redirect_to(admin_tags_path)
    end

    context 'when user is not super_admin' do
      let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }

      it 'doesnt render' do
        delete :destroy, params: { id: tag.id }
        expect(response).not_to be_successful
      end
    end
  end

  describe 'PATCH update' do
    let!(:tag) { FactoryBot.create(:tag, name: 'name') }
    let(:params) do
      {
        id: tag.id,
        acts_as_taggable_on_tag: {
          name: 'new_name'
        }
      }
    end

    it 'updated record' do
      expect { patch :update, params: params }
        .to change { tag.reload.name }
        .from('name').to('new_name')
    end

    it 'renders without errors' do
      patch :update, params: params
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_tag_path(tag))
    end

    context 'when user is not super_admin' do
      let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }

      it 'doesnt render' do
        patch :update, params: params
        expect(response).not_to be_successful
      end
    end
  end

  describe 'PUT create' do
    let(:params) do
      {
        acts_as_taggable_on_tag: {
          name: 'new_name'
        }
      }
    end

    it 'updated record' do
      expect { put :create, params: params }
        .to change(ActsAsTaggableOn::Tag, :count).by(1)
    end

    it 'renders without errors' do
      put :create, params: params
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(admin_tag_path(ActsAsTaggableOn::Tag.last))
    end

    context 'when user is not super_admin' do
      let(:logged_in_admin_user) { FactoryBot.create(:admin_user, :super_reviewer) }

      it 'doesnt render' do
        put :create, params: params
        expect(response).not_to be_successful
      end
    end
  end
end
