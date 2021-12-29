# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
  def sample_mail_preview
    UserMailer.sample_email(FactoryBot.create(:user))
  end
end
