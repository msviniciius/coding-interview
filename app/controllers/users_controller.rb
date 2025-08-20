class UsersController < ApplicationController
  before_action :set_company

  # GET /users
  def index
    @users = User.all
    @users = @users.by_company(params[:company_id])
    @users = @users.by_username_or_display_name(params[:username] || params[:display_name])
  end

  def new
    @user = @company.users.new
  end

  def create
    @user = @company.users.new(user_params)

    if @user.save
      redirect_to company_users_path(@company), notice: 'Usuário criado com sucesso.'
    else
      flash.now[:alert] = 'Erro ao criar usuário.'
      render :new
    end
  end

  private

  def set_company
    @company = Company.find_by(id: params[:company_id])
  end

  def search_params
    params.permit(:username, :company_id)
  end

  def user_params
    params.require(:user).permit(:display_name, :email, :username, :company_id)
  end
end
