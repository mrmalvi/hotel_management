class Vehicle < ApplicationRecord
  belongs_to :user
  has_many :payments, as: :payable
  has_many :emi_schedules, dependent: :destroy
  has_one :seizure, dependent: :destroy

  validates :registration_number, presence: true, uniqueness: true
  validates :model, presence: true
  validates :purchase_price, presence: true, numericality: { greater_than: 0 }
  validates :down_payment, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :loan_term_months, presence: true, numericality: { greater_than: 0 }
  validates :interest_rate, presence: true, numericality: { greater_than: 0 }

  enum status: {
    active: 'active',
    seized: 'seized',
    released: 'released'
  }

  def calculate_emi
    principal = purchase_price - down_payment
    monthly_interest_rate = interest_rate / 12 / 100
    emi = principal * (monthly_interest_rate * (1 + monthly_interest_rate)**loan_term_months) / 
          ((1 + monthly_interest_rate)**loan_term_months - 1)
    emi.round(2)
  end

  def generate_emi_schedule
    emi_amount = calculate_emi
    remaining_principal = purchase_price - down_payment
    current_date = Date.today

    loan_term_months.times do |i|
      interest_component = remaining_principal * (interest_rate / 12 / 100)
      principal_component = emi_amount - interest_component
      remaining_principal -= principal_component

      emi_schedules.create!(
        due_date: current_date + (i + 1).months,
        amount: emi_amount,
        principal_component: principal_component,
        interest_component: interest_component,
        remaining_principal: remaining_principal,
        status: 'pending'
      )
    end
  end

  def check_payment_status
    overdue_emis = emi_schedules.where('due_date < ? AND status = ?', Date.today, 'pending')
    if overdue_emis.count >= 3
      SeizeVehicleWorker.perform_async(id)
    end
  end

  def seize!
    return if seized?
    
    transaction do
      update!(status: :seized)
      create_seizure!(
        seized_at: Time.current,
        total_overdue_amount: emi_schedules.overdue.sum(:amount),
        status: :active
      )
    end
  end

  def release!
    return unless seized?
    
    transaction do
      update!(status: :released)
      seizure.update!(status: :released, released_at: Time.current)
    end
  end

  def permanent_seizure!
    return unless seized?
    
    transaction do
      update!(status: :seized)
      seizure.update!(status: :permanent)
    end
  end
end 