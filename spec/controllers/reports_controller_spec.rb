# spec/controllers/reports_controller_spec.rb
require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  before do
    ActiveJob::Base.queue_adapter = :test
  end

  let!(:report1) { Report.create!(name: "Relatório 1", content: "Conteúdo 1") }
  let!(:report2) { Report.create!(name: "Relatório 2", content: "Conteúdo 2") }

  describe "GET #index" do
    it "atribui todos os relatórios em ordem decrescente de criação" do
      get :index
      expect(assigns(:reports)).to eq([report2, report1])
    end
  end

  describe "POST #generate" do
    it "dispara o job de geração de relatórios e redireciona com notice" do
      expect {
        post :generate
      }.to have_enqueued_job(ReportGenerationJob)

      expect(response).to redirect_to(reports_path)
      expect(flash[:notice]).to eq("Relatórios estão sendo gerados em segundo plano!")
    end
  end

  describe "GET #download" do
    it "envia o conteúdo do relatório como arquivo txt" do
      get :download, params: { id: report1.id }

      expect(response.body).to eq(report1.content)
      expect(response.header['Content-Type']).to include "text/plain"
      expect(response.header['Content-Disposition']).to include "relatorio-1.txt"
    end
  end
end
