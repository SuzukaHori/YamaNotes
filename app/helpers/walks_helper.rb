# frozen_string_literal: true

module WalksHelper
  def current_walk
    current_user&.walk
  end

  def elapsed_time(walk)
    elapsed_seconds = Time.current - walk.created_at
    convert_to_local_time(elapsed_seconds)
  end

  def time_to_reach_goal(walk)
    return unless walk.finished?

    convert_to_local_time(walk.arrival_of_goal.arrived_at - walk.created_at)
  end

  private

  def convert_to_local_time(m_seconds)
    hours = (m_seconds / 3600).to_i
    minutes = ((m_seconds - (hours * 3600)) / 60).to_i
    "#{hours}時間#{minutes.to_i}分"
  end
end
