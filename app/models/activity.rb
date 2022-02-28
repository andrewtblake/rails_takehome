class Activity < ApplicationRecord
  include Steppable

  def steps
    %w[step_1 step_2 step_3]
  end

  validates :name, presence: true, if: ->(o){ o.current_step == 'step_1' }
  validates :address, presence: true, if: ->(o){ o.current_step == 'step_2' }
  validates :starts_at, :ends_at, presence: true, if: ->(o){ o.current_step == 'step_3' }
end
