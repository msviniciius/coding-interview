class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  # GET /companies
  def index
    @companies = Company.all
  end

  # GET /companies/:id
  def show
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # POST /companies
  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to @company, notice: 'Empresa criada com sucesso!'
    else
      render :new
    end
  end

  # GET /companies/:id/edit
  def edit
  end

  # PATCH/PUT /companies/:id
  def update
    if @company.update(company_params)
      redirect_to @company, notice: 'Empresa atualizada com sucesso!'
    else
      render :edit
    end
  end

  # DELETE /companies/:id
  def destroy
    @company.destroy
    redirect_to companies_url, notice: 'Empresa excluída com sucesso!'
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:name)
  end
end