class ReportGenerationJob < ApplicationJob
  queue_as :default

  def perform
    Reports::UserTweetsReport.call
    Reports::CompanyUsersReport.call
  end
end