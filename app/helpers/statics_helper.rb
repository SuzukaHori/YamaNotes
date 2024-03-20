module StaticsHelper
  def fontawesome_url
    ENV.fetch('FONTAWESOME_URL', nil)
  end
end
