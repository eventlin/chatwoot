module Enterprise::Inbox
  def member_ids_with_assignment_capacity
    max_assignment_limit = auto_assignment_config['max_assignment_limit']
    overloaded_agent_ids = max_assignment_limit.present? ? get_agent_ids_over_assignment_limit(max_assignment_limit) : []
    super - overloaded_agent_ids
  end

  private

  def get_agent_ids_over_assignment_limit(limit)
    conversations.open.select(:assignee_id).group(:assignee_id).having("count(*) >= #{limit.to_i}").filter_map(&:assignee_id)
  end
end
