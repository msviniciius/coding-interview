require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "#welcome_email" do
    let(:company) { Company.create!(name: "Empresa Teste") }
    let(:user) { User.create!(username: "msvinicius", display_name: "Marcos Vinicius", email: "no-reply@codinginterview.com", company: company) }
    let(:mail) { UserMailer.welcome_email(user) }

    it "envia o e-mail para o destinatário correto" do
      expect(mail.to).to eq([user.email])
    end

    it "define o assunto correto" do
      expect(mail.subject).to eq("Bem-vindo à nossa plataforma Coding Interview!")
    end

    it "contém o nome do usuário no corpo do e-mail" do
      expect(mail.body.encoded).to match(/#{Regexp.escape(user.display_name)}/i)
    end

    it "contém o nome da empresa no corpo do e-mail" do
      expect(mail.body.encoded).to match(company.name)
    end

    it "é enviado com o endereço 'from' correto" do
      expect(mail.from).to eq(["no-reply@codinginterview.com"])
    end
  end
end
