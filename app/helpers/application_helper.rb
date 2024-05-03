# frozen_string_literal: true

module ApplicationHelper
  def fontawesome_url
    ENV.fetch('FONTAWESOME_URL', nil)
  end

  def default_meta_tags
    {
      site: 'YamaNotes',
      reverse: true,
      separator: '|'
    }
  end
end
