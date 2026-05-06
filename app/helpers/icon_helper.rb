# frozen_string_literal: true

module IconHelper
  def icon_svg(name, options = {})
    file = Rails.root.join("app/assets/images/icons/#{name}.svg")
    svg = Rails.cache.fetch("icon_svg/#{name}") { File.read(file) }

    if options[:class]
      svg = svg.sub("<svg", "<svg class=\"#{options[:class]}\"")
    end

    svg.html_safe
  end
end
