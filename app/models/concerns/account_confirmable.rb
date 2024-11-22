module AccountConfirmable
  extend ActiveSupport::Concern

  included do
    before_create :generate_confirmation_code

    def generate_confirmation_code
      self.confirmation_code = SecureRandom.hex(3) # Generates a 6-character hex code
      self.confirmation_sent_at = Time.current
    end

    def confirm_account!(code)
      if self.confirmation_code.eql?(code) && confirmation_code_valid?
        update(confirmed_at: Time.current, confirmation_code: nil, confirmation_sent_at: nil)
      else
        false
      end
    end

    def confirmation_code_valid?
      confirmation_sent_at && confirmation_sent_at > 10.minutes.ago
    end

    def confirmed?
      confirmed_at.present?
    end
  end
end
