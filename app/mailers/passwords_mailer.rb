class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    mail subject: t("mailer.reset_password.subject"), to: user.email_address
  end
end
