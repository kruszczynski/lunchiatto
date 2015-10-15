require 'spec_helper'

describe Api::CompaniesController, type: :controller do
  let(:company) { create :company }
  let(:user) { create :user }

  describe 'GET show' do
    it 'requires authentication' do
      get_company(should_sign_in: false)
      expect(response).to redirect_to(root_path)
    end

    it 'refutes non-member' do
      get_company
      expect(response).to have_http_status(401)
    end

    context 'as company member' do
      before do
        user.company = company
        user.save!
      end
      it 'refutes' do
        get_company
        expect(response).to have_http_status(401)
      end
    end

    context 'as company admin' do
      before do
        user.company = company
        user.company_admin = true
        user.save!
      end
      it 'is a success' do
        get_company
        expect(response).to have_http_status(200)
      end
      it 'returns company' do
        get_company
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['name']).to eq('MyString')
      end
    end

    def get_company(should_sign_in:true)
      sign_in user if should_sign_in
      get :show, id: company.id
    end
  end

  describe 'PUT update' do
    it 'requires authentication' do
      put_company(should_sign_in: false)
      expect(response).to redirect_to(root_path)
    end

    it 'refutes non-member' do
      put_company
      expect(response).to have_http_status(401)
    end

    context 'as company member' do
      before do
        user.company = company
        user.save!
      end
      it 'refutes' do
        put_company
        expect(response).to have_http_status(401)
      end
    end

    context 'as company admin' do
      before do
        user.company = company
        user.company_admin = true
        user.save!
      end
      it 'is a success' do
        put_company
        expect(response).to have_http_status(200)
      end
      it 'returns company' do
        put_company
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['name']).to eq('The new name')
      end
      it 'returns errors' do
        put_company(name: '')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    def put_company(should_sign_in: true, name: 'The new name')
      sign_in user if should_sign_in
      put :update, id: company.id, name: name
    end
  end
end
