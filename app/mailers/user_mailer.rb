class UserMailer < ApplicationMailer
  def confirmation_email(user)
    @user = user

    mail to: @user.email_address, subject: t("mailer.account_confirmation.subject")
  end
end
