require 'rails_helper'

RSpec.describe ReportGenerationJob, type: :job do
  include ActiveJob::TestHelper

  it "executa os relatórios de usuários e empresas" do
    allow(Reports::UserTweetsReport).to receive(:call)
    allow(Reports::CompanyUsersReport).to receive(:call)

    perform_enqueued_jobs do
      ReportGenerationJob.perform_later
    end

    expect(Reports::UserTweetsReport).to have_received(:call)
    expect(Reports::CompanyUsersReport).to have_received(:call)
  end
end
