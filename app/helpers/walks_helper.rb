module WalksHelper
  def current_walk
    current_user&.walk
  end

  def elapsed_time(walk)
    elapsed_seconds = Time.current - walk.created_at
    hours = (elapsed_seconds / 3600).to_i
    minutes = ((elapsed_seconds % 3600) / 60).to_i
    "#{hours}時間#{minutes}分"
  end

  def time_to_reach_goal(walk)
    return unless walk.finished?

    Time.at(walk.arrival_of_goal.arrived_at - walk.arrival_of_departure.arrived_at).utc.strftime('%k時間%M分')
  end
end
