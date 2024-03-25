module ArrivalsHelper
  def elapsed_time(departure_time)
    elapsed_seconds = Time.now - departure_time
    hours = (elapsed_seconds / 3600).to_i
    minutes = ((elapsed_seconds % 3600) / 60).to_i
    "#{hours}時間#{minutes}分"
  end
end
