class SeizeVehicleWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(vehicle_id)
    vehicle = Vehicle.find_by(id: vehicle_id)
    return unless vehicle

    # Check if vehicle is already seized
    return if vehicle.seized?

    # Calculate total overdue amount
    overdue_emis = vehicle.emi_schedules.overdue
    total_overdue = overdue_emis.sum(:amount)

    # Seize the vehicle
    vehicle.seize!

    # Notify user about seizure
    VehicleMailer.seizure_notification(vehicle).deliver_later

    # Schedule release worker if payment is made within 30 days
    ReleaseVehicleSeizureWorker.perform_in(30.days, vehicle_id)

    # Log seizure details
    Rails.logger.info("Vehicle #{vehicle.registration_number} seized with overdue amount: #{total_overdue}")
  rescue ActiveRecord::RecordNotFound
    # Log error if vehicle not found
    Rails.logger.error("Vehicle with ID #{vehicle_id} not found for seizure")
  rescue StandardError => e
    # Log any other errors
    Rails.logger.error("Error seizing vehicle #{vehicle_id}: #{e.message}")
    raise e
  end
end 