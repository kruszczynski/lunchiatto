require 'spec_helper'

describe CompaniesController, type: :controller do
  it 'requires authentication' do
    get :new
    expect(response).to redirect_to(root_path)
  end

  context 'with a signed in user' do
    let(:user) { create(:user) }
    before { sign_in(user) }

    {post: :create, get: :new}.each do |verb, action|
      it "#{action}redirects to dashboard if user already has a company" do
        allow(controller).to receive(:current_user) { user }
        allow(user).to receive(:company) { instance_double('Company') }
        send verb, action, company: {name: ''}
        expect(response).to redirect_to(root_url)
        expect(flash[:notice]).to match /couldn't overwrite an existing company/
      end
    end

    describe 'GET new' do
      it 'renders form' do
        get :new
        expect(assigns(:company)).to be_a(Company)
        expect(response).to render_template(:new)
      end
    end

    describe 'POST create' do
      it 'creates a company' do
        post_with_name 'DaftCorp'
        expect(response).to redirect_to(root_url)
      end

      it 'renders an error when name is blank' do
        post_with_name ''
        expect(response).to render_template(:new)
        expect_company_error_message('can\'t be blank')
      end

      it 'renders an error when name is not unique' do
        create(:company, name: 'DaftCorp')
        post_with_name 'DaftCorp'
        expect(response).to render_template(:new)
        expect_company_error_message('has \w+ been taken')
      end

      it 'assigns the company to user' do
        post_with_name 'DaftCorp'
        user.reload
        expect(user.company).to be_truthy
        expect(user.company_admin).to be_truthy
      end

      def post_with_name(name)
        post :create, company: {name: name}
      end

      def expect_company_error_message(msg)
        errors = assigns(:company).errors.full_messages.join(' ')
        expect(errors).to match /#{msg}/
      end
    end
  end

end