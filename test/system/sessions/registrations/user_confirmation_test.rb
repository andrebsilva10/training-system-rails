require "application_system_test_case"

class UserConfirmationTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  setup do
    @user = create(:unconfirmed_user)
    visit confirmation_path(email_address: @user.email_address)
  end

  test "user can confirm the account" do
    fill_in :confirmation_code, with: @user.confirmation_code

    click_on I18n.t("sessions.actions.confirm_account")

    assert_current_path new_session_path
    assert_alert(I18n.t("sessions.flash.account_confirmed"))
  end

  test "user can not confirm the account with wrong code" do
    fill_in :confirmation_code, with: "wrongcode"

    click_on I18n.t("sessions.actions.confirm_account")

    assert_alert(I18n.t("sessions.flash.invalid_confirmation_code"))
    assert_current_path confirmation_path(email_address: @user.email_address)
  end

  test "user can resend the confirmation code" do
    perform_enqueued_jobs do
      ActionMailer::Base.deliveries.clear
      accept_alert do
        click_on I18n.t("sessions.actions.resend_confirmation_conde")
      end

      assert_alert(I18n.t("sessions.flash.confirmation_token_resent"))
      assert_current_path confirmation_path(email_address: @user.email_address)
    end
  end

  test "user can not resend the confirmation code if account is already confirmed" do
    @user.confirm_account!(@user.confirmation_code)

    accept_alert do
      click_on I18n.t("sessions.actions.resend_confirmation_conde")
    end

    assert_alert("#{I18n.t('sessions.flash.account_already_confirmed')} E-mail: #{@user.email_address}")
    assert_current_path confirmation_path(email_address: @user.email_address)
  end
end
