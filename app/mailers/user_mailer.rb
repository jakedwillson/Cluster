class UserMailer < ApplicationMailer
  def registration_confirmation(user)
    return unless user.is_a?(User)
    @user = user
    mail(:to => "#{user.first_name} <#{user.email}>", :subject => "Registration Confirmation")
  end

  def sample_email(user)
    return unless user.is_a?(User)
    @user = user
    mail(to: @user.email, subject: 'Sample Email')
  end
end
