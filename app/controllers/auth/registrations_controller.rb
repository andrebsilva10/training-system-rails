class Auth::RegistrationsController < ApplicationController
  layout "session"
  allow_only_unauthenticated_access
  rate_limit to: 5, within: 3.minutes, only: :resend_confirmation,
             with: -> { redirect_to new_session_url, warning: t("sessions.flash.rate_limit") }

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.confirmation_email(@user).deliver_later
      redirect_to confirmation_url(email_address: @user.email_address)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def confirmation
  end

  # Handles the form submission
  def confirm_account
    @user = User.find_by(email_address: params[:email_address])

    if @user&.confirm_account!(params[:confirmation_code])
      redirect_to new_session_path, notice: t("sessions.flash.account_confirmed")
    else
      flash.now[:alert] = t("sessions.flash.invalid_confirmation_code")
      render :confirmation, status: :unprocessable_entity
    end
  end

  def resend_confirmation
    @user = User.find_by(email_address: params[:email_address])

    if @user && !@user.confirmed?
      @user.generate_confirmation_code
      @user.save!
      UserMailer.confirmation_email(@user).deliver_later
      redirect_to confirmation_url(email_address: @user.email_address),
                  notice: t("sessions.flash.confirmation_token_resent")
    else
      flash[:alert] = "#{t('sessions.flash.account_already_confirmed')} E-mail: #{params[:email_address]}"
      redirect_to confirmation_url(email_address: @user.email_address)
    end
  end

  private

  def user_params
    params.expect(user: [ :name, :email_address, :password, :password_confirmation ])
  end
end
