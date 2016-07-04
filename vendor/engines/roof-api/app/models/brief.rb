class Brief < Composable::Model

  attr_accessor :description,
    :budget,
    :preferred_start,
    :ownership,
    :plans,
    :planning_permission,
    :structural_drawings,
    :party_wall_agreement

  validates_presence_of :description

end
