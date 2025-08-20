require 'rails_helper'

RSpec.describe "Users index", type: :request do
  describe "GET /companies/:company_id/users" do
    let!(:company_a) { create(:company, name: "Empresa A") }
    let!(:company_b) { create(:company, name: "Empresa B") }

    let!(:alice_a) { create(:user, company: company_a, username: "alice", display_name: "Alice A") }
    let!(:bob_a)   { create(:user, company: company_a, username: "BobBuilder", display_name: "Bob A") }
    let!(:carol_b) { create(:user, company: company_b, username: "carol", display_name: "Carol B") }

    it "lista somente usuários da empresa" do
      get company_users_path(company_a.id)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Alice A")
      expect(response.body).to include("Bob A")
      expect(response.body).not_to include("Carol B")
    end

    it "aplica filtro por username (parcial e case-insensitive)" do
      get company_users_path(company_a.id), params: { username: "builder" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Bob A")
      expect(response.body).not_to include("Alice A")
      expect(response.body).not_to include("Carol B")
    end
  end
end
