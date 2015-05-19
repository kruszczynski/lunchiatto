require 'spec_helper'

describe CompaniesController, type: :controller do
  let(:company) { create :company }
  let(:user) { create :user }

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

  describe "GET show" do
    it "requires authentication" do
      get_company(should_sign_in: false)
      expect(response).to redirect_to(root_path)
    end

    it "refutes non-member" do
      get_company
      expect(response).to have_http_status(401)
    end

    context "as company member" do
      before do
        user.company = company
        user.save!
      end
      it "refutes" do
        get_company
        expect(response).to have_http_status(401)
      end
    end

    context "as company admin" do
      before do
        user.company = company
        user.company_admin = true
        user.save!
      end
      it "is a success" do
        get_company
        expect(response).to have_http_status(200)
      end
      it "returns company" do
        get_company
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["name"]).to eq("MyString")
      end
    end

    def get_company(should_sign_in:true)
      sign_in user if should_sign_in
      get :show, id: company.id
    end
  end

  describe "PUT update" do
    it "requires authentication" do
      put_company(should_sign_in: false)
      expect(response).to redirect_to(root_path)
    end

    it "refutes non-member" do
      put_company
      expect(response).to have_http_status(401)
    end

    context "as company member" do
      before do
        user.company = company
        user.save!
      end
      it "refutes" do
        put_company
        expect(response).to have_http_status(401)
      end
    end

    context "as company admin" do
      before do
        user.company = company
        user.company_admin = true
        user.save!
      end
      it "is a success" do
        put_company
        expect(response).to have_http_status(200)
      end
      it "returns company" do
        put_company
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["name"]).to eq("The new name")
      end
      it "returns errors" do
        put_company(name: "")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    def put_company(should_sign_in: true, name: "The new name")
      sign_in user if should_sign_in
      put :update, id: company.id, name: name
    end
  end
end
