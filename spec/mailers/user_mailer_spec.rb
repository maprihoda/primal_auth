require "spec_helper"

describe UserMailer do
  describe "password_reset" do
    let(:user) { Factory(:user, :password_reset_token => "anything") }
    let(:mail) { UserMailer.password_reset(user) }

    it "send user password reset url" do
      mail.subject.should eq("Password Reset")
      mail.to.should eq([user.email])
      mail.from.should eq(["from@example.com"])
      mail.body.encoded.should match(edit_password_reset_url(user.password_reset_token))
    end
  end

  describe 'confirmation_instructions' do
    let(:user) { Factory(:user, :confirmation_token => "anything") }
    let(:mail) { UserMailer.confirmation_instructions(user) }

    it "send user confirmation url" do
      mail.subject.should eq("Confirmation instructions")
      mail.to.should eq([user.email])
      mail.from.should eq(["from@example.com"])
      mail.body.encoded.should match(confirmation_url(user.confirmation_token))
    end
  end

end

