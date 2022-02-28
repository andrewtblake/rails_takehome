class Activity < ApplicationRecord
  include Steppable

  def steps
    %w[step_1 step_2 step_3]
  end
end
