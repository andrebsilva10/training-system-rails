class Auth::SessionsController < ApplicationController
  layout "session"
  allow_only_unauthenticated_access only: %i[ new create ]
  rate_limit to: 5, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url,
                                                                             warning: t("sessions.flash.rate_limit") }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      handle_authenticated_user(user)
    else
      redirect_to new_session_path, alert: t("sessions.flash.error")
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, notice: t("sessions.flash.signed_out")
  end

  private

  def handle_authenticated_user(user)
    if user.confirmed?
      start_new_session_for(user)
      redirect_to users_root_path
    else
      redirect_to confirmation_url(email_address: user.email_address), notice: t("sessions.flash.unconfirmed_account")
    end
  end
end
