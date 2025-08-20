require 'rails_helper'

RSpec.describe SendWelcomeEmailJob, type: :job do
  include ActiveJob::TestHelper

  let(:company) { Company.create!(name: "Empresa Teste") }
  let(:user) { User.create!(username: "msvinicius", display_name: "Marcos Vinicius", email: "user@example.com", company: company) }

  it "executa o job e chama o mailer" do
    mailer = double("UserMailer")
    allow(UserMailer).to receive(:welcome_email).with(user).and_return(mailer)
    allow(mailer).to receive(:deliver_now)

    perform_enqueued_jobs do
      SendWelcomeEmailJob.perform_later(user.id)
    end

    expect(UserMailer).to have_received(:welcome_email).with(user)
    expect(mailer).to have_received(:deliver_now)
  end
end
