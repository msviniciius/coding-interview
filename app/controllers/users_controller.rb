class UsersController < ApplicationController
  before_action :set_company

  # GET /users
  def index
    @users = User.all
    @users = @users.by_company(params[:company_id])
    @users = @users.by_username(params[:username])
  end

  private

  def set_company
    @company = Company.find_by(id: params[:company_id])
  end

  def search_params
    params.permit(:username, :company_id)
  end
end
