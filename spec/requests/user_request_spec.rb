# spec/requests/users_spec.rb
require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:company1) { Company.create!(name: "Company 1") }
  let!(:company2) { Company.create!(name: "Company 2") }

  let!(:user_company1_a) { User.create!(username: "user_company1_a", display_name: "User A", email: "a@company1.com", company: company1) }
  let!(:user_company1_b) { User.create!(username: "user_company1_b", display_name: "User B", email: "b@company1.com", company: company1) }
  let!(:user_company2)   { User.create!(username: "user_company2", display_name: "User C", email: "c@company2.com", company: company2) }

  describe "GET /companies/:company_id/users" do
    it "retorna apenas usuários da empresa especificada" do
      get company_users_path(company1)

      html = Nokogiri::HTML(response.body)
      user_names = html.css('table tbody tr td:nth-child(2)').map(&:text)

      expect(user_names).to include("User A", "User B")
      expect(user_names).not_to include("User C")
    end

    it "filtra usuários por nome de usuário" do
      get company_users_path(company1, params: { username: "user_company1_a" })

      html = Nokogiri::HTML(response.body)
      user_names = html.css('table tbody tr td:nth-child(2)').map(&:text)

      expect(user_names).to eq(["User A"])
    end

    it "retorna todos os usuários se o filtro de nome de usuário estiver em branco" do
      get company_users_path(company1, params: { username: "" })

      html = Nokogiri::HTML(response.body)
      user_names = html.css('table tbody tr td:nth-child(2)').map(&:text)

      expect(user_names).to include("User A", "User B")
    end
  end
end
