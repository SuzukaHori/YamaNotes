# frozen_string_literal: true

module WalksHelper
  def walk_status_label(walk)
    base_classes = 'inline-flex items-center rounded-md px-2 py-1 text-xs font-medium ring-1 ring-inset'

    if walk.finished?
      content_tag :span, '一周完了', class: "#{base_classes} bg-green-50 text-green-700 ring-green-600/20"
    elsif walk.active?
      content_tag :span, '歩行中', class: "#{base_classes} bg-blue-50 text-blue-700 ring-blue-700/10"
    else
      content_tag :span, 'リタイア', class: "#{base_classes} bg-gray-50 text-gray-600 ring-gray-500/10"
    end
  end

  def elapsed_time(walk)
    elapsed_seconds = Time.current - walk.arrival_of_departure.arrived_at
    convert_to_local_time(elapsed_seconds)
  end

  def time_to_reach_goal(walk)
    return unless walk.finished?

    convert_to_local_time(walk.arrival_of_goal.arrived_at - walk.arrival_of_departure.arrived_at)
  end

  private

  def convert_to_local_time(m_seconds)
    hours = (m_seconds / 3600).to_i
    minutes = ((m_seconds - (hours * 3600)) / 60).to_i
    "#{hours}時間#{minutes.to_i}分"
  end
end
