class ReportsController < ApplicationController
  REPORTS_DIR = Rails.root.join("tmp/reports")

  def index
    @reports = Report.order(created_at: :desc)
  end

  def generate
    ReportGenerationJob.perform_later
    redirect_to reports_path, notice: "Relatórios estão sendo gerados em segundo plano!"
  end

  def download
    report = Report.find(params[:id])
    send_data report.content, filename: "#{report.name.parameterize}.txt", type: "text/plain"
  end
end
