# spec/controllers/users_controller_spec.rb
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:company_1) { Company.create!(name: "Empresa 1") }
  let!(:company_2) { Company.create!(name: "Empresa 2") }

  let!(:user_company_1) { User.create!(username: "user1", display_name: "User One", email: "user1@example.com", company: company_1) }
  let!(:user_company_2) { User.create!(username: "user2", display_name: "User Two", email: "user2@example.com", company: company_2) }

  before do
    User.where.not(id: [user_company_1.id, user_company_2.id]).destroy_all
  end

  describe "GET #index" do
    context "quando filtrando por empresa" do
      it "retorna apenas os usuários da empresa especificada" do
        get :index, params: { company_id: company_1.id }

        expect(assigns(:users)).to contain_exactly(user_company_1)
      end

      it "retorna todos os usuários se não passar company_id" do
        get :index, params: {}

        expect(assigns(:users)).to match_array([user_company_1, user_company_2])
      end
    end

    context "quando filtrando por username ou display_name" do
      it "retorna usuários pelo username" do
        get :index, params: { company_id: company_1.id, username: "user1" }

        expect(assigns(:users)).to contain_exactly(user_company_1)
      end

      it "retorna usuários pelo display_name" do
        get :index, params: { company_id: company_1.id, display_name: "User One" }

        expect(assigns(:users)).to contain_exactly(user_company_1)
      end

      it "retorna todos se não passar termo de busca" do
        get :index, params: { company_id: company_1.id, username: "" }

        expect(assigns(:users)).to contain_exactly(user_company_1)
      end
    end
  end

  describe "GET #new" do
    let(:company) { create(:company) }

    it "inicializa um novo usuário" do
      get :new, params: { company_id: company.id }

      expect(assigns(:user)).to be_a_new(User)
      expect(assigns(:user).company).to eq(company)
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    render_views

    context "com dados válidos" do
      let(:valid_params) do
        {
          company_id: company_1.id,
          user: {
            username: "new_user",
            display_name: "Novo Usuário",
            email: "novo@example.com"
          }
        }
      end

      it "cria um novo usuário e redireciona" do
        expect {
          post :create, params: valid_params
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(company_users_path(company_1))
        expect(flash[:notice]).to eq("Usuário criado com sucesso.")
      end
    end

    context "com dados inválidos" do
      let(:company) { create(:company) }
      let(:invalid_params) do
        { 
          company_id: company.id,
          user: { 
            username: "",
            display_name: "",
            email: "invalido" 
          }
        }
      end

      it "não cria o usuário e renderiza :new" do
        expect {
          post :create, params: invalid_params
        }.not_to change(User, :count)

        expect(flash.now[:alert]).to eq("Erro ao criar usuário.")
        expect(response).to render_template(:new)
      end
    end
  end

  describe "#search_params" do
    it "permite apenas username e company_id" do
      controller.params[:username] = "user1"
      controller.params[:company_id] = 1
      controller.params[:other_param] = "ignore"

      expect(controller.send(:search_params).to_h).to eq({ "username" => "user1", "company_id" => 1 })
    end
  end
end
