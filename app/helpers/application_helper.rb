# frozen_string_literal: true

module ApplicationHelper
  def fontawesome_url
    ENV.fetch('FONTAWESOME_URL', nil)
  end
end
