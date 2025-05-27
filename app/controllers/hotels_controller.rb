class HotelsController < ApplicationController
  before_action :set_platform
  before_action :set_hotel, only: [:show]

  def index
    @hotels = Hotel.all
    
    # Apply filters
    @hotels = @hotels.by_location(params[:location]) if params[:location].present?
    @hotels = @hotels.by_amenities(params[:amenity_ids]) if params[:amenity_ids].present?
    @hotels = @hotels.by_rating(params[:rating]) if params[:rating].present?
    
    # Room filters
    if params[:adults].present? || params[:children].present?
      adults = params[:adults].to_i
      children = params[:children].to_i
      @hotels = @hotels.joins(:rooms).where(rooms: { max_adults: adults.., max_children: children.. }).distinct
    end

    @pagy, @hotels = pagy(@hotels, items: 12)
    @amenities = Amenity.all
    @room_types = RoomType.all.map(&:name)
  end

  def show
    @rooms = @hotel.rooms.includes(:amenities, :room_type)
    
    # Apply room filters
    @rooms = @rooms.by_type(params[:room_type]) if params[:room_type].present?
    @rooms = @rooms.by_capacity(params[:adults].to_i, params[:children].to_i) if params[:adults].present? || params[:children].present?
    @rooms = @rooms.by_price_range(params[:min_price], params[:max_price]) if params[:min_price].present? || params[:max_price].present?
    
    if params[:check_in].present? && params[:check_out].present?
      @rooms = @rooms.available_for_dates(params[:check_in], params[:check_out])
    end
  end

  private

  def set_platform
    @platform = current_platform
  end

  def set_hotel
    @hotel = @platform.hotels.find(params[:id])
  end
end 