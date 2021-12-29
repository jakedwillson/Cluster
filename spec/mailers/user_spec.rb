require "rails_helper"
require "email_spec"
require "email_spec/rspec"
require "minitest-matchers"

RSpec.describe UserMailer, type: :mailer do
  let!(:user) { FactoryBot.create(:user, email: 'johndoe@gmail.com') }
  describe '#sample_email' do
    let(:mail) { UserMailer.sample_email(user) }

    it { expect(mail.subject).to eq('Sample Email') }
    it { expect(mail.to).to include(user.email) }
    it { expect(mail.from).to include('dividenconquers@gmail.com') }
    it { expect(mail).to deliver_to(user.email) }
  end
end
