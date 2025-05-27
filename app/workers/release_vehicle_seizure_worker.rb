class ReleaseVehicleSeizureWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(vehicle_id)
    vehicle = Vehicle.find_by(id: vehicle_id)
    return unless vehicle

    # Check if vehicle is seized and has an active seizure
    return unless vehicle.seized? && vehicle.seizure&.active?

    # Check if all overdue EMIs are paid
    if vehicle.emi_schedules.overdue.exists?
      # If still has overdue EMIs, make seizure permanent
      vehicle.permanent_seizure!
      VehicleMailer.permanent_seizure_notification(vehicle).deliver_later
    else
      # If all EMIs are paid, release the vehicle
      vehicle.release!
      VehicleMailer.release_notification(vehicle).deliver_later
    end
  rescue ActiveRecord::RecordNotFound
    # Log error if vehicle not found
    Rails.logger.error("Vehicle with ID #{vehicle_id} not found for release")
  rescue StandardError => e
    # Log any other errors
    Rails.logger.error("Error releasing vehicle #{vehicle_id}: #{e.message}")
    raise e
  end
end 