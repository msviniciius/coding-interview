require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  describe "GET #index" do
    it "atribui todas as empresas" do
      User.destroy_all
      Company.destroy_all

      company1 = Company.create!(name: "Empresa 1")
      company2 = Company.create!(name: "Empresa 2")

      get :index

      expect(assigns(:companies)).to match_array([company1, company2])
    end
  end

  describe "GET #new" do
    it "atribui um novo company" do
      get :new
      expect(assigns(:company)).to be_a_new(Company)
    end
  end

  describe "POST #create" do
    context "com dados válidos" do
      it "cria uma empresa e redireciona" do
        expect {
          post :create, params: { company: { name: "Nova Empresa" } }
        }.to change(Company, :count).by(1)

        expect(response).to redirect_to(Company.last)
        expect(flash[:notice]).to eq("Empresa criada com sucesso!")
      end
    end

    context "com dados inválidos" do
      it "não cria empresa e renderiza :new" do
        expect {
          post :create, params: { company: { name: "" } }
        }.not_to change(Company, :count)

        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    let!(:company) { Company.create!(name: "Empresa 1") }

    context "com dados válidos" do
      it "atualiza a empresa e redireciona" do
        patch :update, params: { id: company.id, company: { name: "Empresa Atualizada" } }
        expect(company.reload.name).to eq("Empresa Atualizada")
        expect(response).to redirect_to(company)
        expect(flash[:notice]).to eq("Empresa atualizada com sucesso!")
      end
    end

    context "com dados inválidos" do
      it "não atualiza a empresa e renderiza :edit" do
        patch :update, params: { id: company.id, company: { name: "" } }
        expect(company.reload.name).to eq("Empresa 1")
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:company) { Company.create!(name: "Empresa 1") }

    it "remove a empresa e redireciona" do
      expect {
        delete :destroy, params: { id: company.id }
      }.to change(Company, :count).by(-1)

      expect(response).to redirect_to(companies_url)
      expect(flash[:notice]).to eq("Empresa excluída com sucesso!")
    end
  end
end
