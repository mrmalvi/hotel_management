class Seizure < ApplicationRecord
  belongs_to :vehicle
  has_many :future_vouchers, dependent: :destroy
  has_many :cash_flows, as: :flowable, dependent: :destroy

  validates :seized_at, presence: true
  validates :total_overdue_amount, presence: true, numericality: { greater_than: 0 }
  validates :release_deadline, presence: true

  enum status: {
    active: 'active',
    released: 'released',
    permanent: 'permanent'
  }

  before_validation :set_release_deadline, on: :create
  after_create :handle_future_vouchers
  after_update :handle_release_vouchers, if: :saved_change_to_status?

  def handle_future_vouchers
    # Destroy future vouchers after seizure date
    vehicle.emi_schedules.where('due_date > ?', seized_at).each do |emi|
      emi.destroy_future_vouchers
    end

    # Create cash flow entry for seizure
    create_cash_flow(
      amount: total_overdue_amount,
      flow_type: 'seizure',
      flow_date: seized_at,
      description: "Vehicle seizure due to overdue EMIs"
    )
  end

  def handle_release_vouchers
    return unless released?

    # Recreate future vouchers after release
    vehicle.emi_schedules.where('due_date > ?', released_at).each do |emi|
      emi.recreate_future_vouchers
    end

    # Create cash flow entry for release
    create_cash_flow(
      amount: -total_overdue_amount,
      flow_type: 'release',
      flow_date: released_at,
      description: "Vehicle release after payment"
    )
  end

  private

  def set_release_deadline
    self.release_deadline = seized_at + 30.days if seized_at.present?
  end
end 