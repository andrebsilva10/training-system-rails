class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"

  default template_path: -> { custom_template_path }

  private

  def custom_template_path
    mailer_folder = self.class.name.underscore
    "mailer/#{mailer_folder}"
  end
end
