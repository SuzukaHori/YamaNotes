# frozen_string_literal: true

module ApplicationHelper
  def fontawesome_url
    ENV.fetch('FONTAWESOME_URL', nil)
  end

  def feedback_form_url
    'https://docs.google.com/forms/d/e/1FAIpQLSeWKVNjR0qv0WC--4SmcaddRCMbkdlvTJlOfWt29KE9dtM5gA/viewform'
  end
end
