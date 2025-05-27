class EmiSchedule < ApplicationRecord
  belongs_to :vehicle
  has_many :future_vouchers, dependent: :destroy
  has_many :payments, as: :payable

  validates :due_date, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :principal_component, presence: true, numericality: { greater_than: 0 }
  validates :interest_component, presence: true, numericality: { greater_than: 0 }
  validates :remaining_principal, presence: true, numericality: { greater_than_or_equal_to: 0 }

  enum status: {
    pending: 'pending',
    paid: 'paid',
    overdue: 'overdue'
  }

  scope :overdue, -> { where('due_date < ? AND status = ?', Date.today, 'pending') }
  scope :upcoming, -> { where('due_date >= ? AND status = ?', Date.today, 'pending') }

  def destroy_future_vouchers
    future_vouchers.destroy_all
  end

  def recreate_future_vouchers
    return if due_date <= Date.today

    create_future_voucher!(
      amount: amount,
      due_date: due_date,
      description: "EMI payment for vehicle #{vehicle.registration_number}"
    )
  end

  def mark_as_paid!(payment)
    transaction do
      update!(status: :paid)
      payments.create!(
        amount: amount,
        payment_date: payment.payment_date,
        payment_method: payment.payment_method,
        reference_number: payment.reference_number
      )
      destroy_future_vouchers
    end
  end

  def check_overdue
    return unless pending?
    return unless due_date < Date.today

    update!(status: :overdue)
    vehicle.check_payment_status
  end
end 