class User < ApplicationRecord
  include AccountConfirmable

  has_secure_password
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  has_many :sessions, dependent: :destroy
  has_one_attached :avatar

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, confirmation: true, presence: true, length: { minimum: 6 }, if: :password_required?

  def avatar_url
    return ActionController::Base.helpers.asset_path("avatars/default_avatar.png") unless avatar.attached?

    Rails.application.routes.url_helpers.rails_blob_url(avatar, only_path: true)
  end

  def update_with_password(params)
    if authenticate(params[:current_password])
      update(params.except(:current_password))
    else
      errors.add(:current_password, I18n.t("activerecord.errors.messages.wrong_current_password"))
      assign_attributes(params.except(:current_password))
      false
    end
  end

  private

  def password_required?
    # Only require password when creating a new record or when a password is present
    new_record? || !password.nil? || !password_confirmation.nil?
  end
end
