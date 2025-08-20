class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    @company = @user.company
    # @url  = 'http://0.0.0.0:3000/login'

    mail(
      to: @user.email,
      subject: 'Bem-vindo à nossa plataforma Coding Interview!'
    )
  end
end
