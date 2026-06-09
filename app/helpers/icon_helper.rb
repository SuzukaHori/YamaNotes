# frozen_string_literal: true

module IconHelper
  def icon_svg(name, options = {})
    file = Rails.root.join("app/assets/images/icons/#{name}.svg")
    svg = Rails.cache.fetch("icon_svg/#{name}") { File.read(file) }

    svg = svg.sub('<svg', "<svg class=\"#{options[:class]}\"") if options[:class]

    svg.html_safe # rubocop:disable Rails/OutputSafety
  end
end
