# frozen_string_literal: true
require 'spec_helper'

describe PagesController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #index' do
    it 'renders index page' do
      get :index
      expect(response).to render_template :index
    end

    it 'redirects logged in user to dashboard' do
      sign_in user
      get :index
      expect(response).to redirect_to orders_today_path
    end
  end
end
