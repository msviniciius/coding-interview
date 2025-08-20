require "rails_helper"

RSpec.describe User, type: :model do
  describe "Associações" do
    it "pertence a uma empresa" do
      expect(User.reflect_on_association(:company).macro).to eq(:belongs_to)
    end

    it "tem muitos tweets" do
      expect(User.reflect_on_association(:tweets).macro).to eq(:has_many)
    end
  end

  # describe "Callbacks" do
  #   it "enfileira email de boas-vindas após criação" do
  #     user = build(:user)
  #     expect {
  #       user.save
  #     }.to have_enqueued_job(SendWelcomeEmailJob).with(user.id)
  #   end
  # end

  describe "Scopes" do
    let!(:company1) { create(:company) }
    let!(:company2) { create(:company) }
    let!(:user1) { create(:user, username: "ana", display_name: "Ana", company: company1) }
    let!(:user2) { create(:user, username: "bruno", display_name: "Bruno", company: company2) }

    describe ".by_company" do
      it "retorna apenas usuários da empresa especificada" do
        expect(User.by_company(company1.id)).to contain_exactly(user1)
      end

      it "retorna todos os usuários se não passar empresa" do
        expect(User.by_company(nil)).to include(user1, user2)
      end
    end

    describe ".by_username_or_display_name" do
      it "filtra por username parcial" do
        expect(User.by_username_or_display_name("an")).to include(user1)
      end

      it "filtra por display_name parcial" do
        expect(User.by_username_or_display_name("bru")).to include(user2)
      end

      it "retorna todos se não passar termo" do
        expect(User.by_username_or_display_name(nil)).to include(user1, user2)
      end
    end
  end
end
