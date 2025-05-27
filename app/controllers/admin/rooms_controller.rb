module Admin
  class RoomsController < Admin::BaseController
    before_action :set_platform
    before_action :set_hotel
    before_action :set_room, only: [:show, :edit, :update, :destroy]

    def index
      @rooms = @hotel.rooms.includes(:amenities).page(params[:page]).per(10)
    end

    def show
    end

    def new
      @room = @hotel.rooms.build
    end

    def create
      @room = @hotel.rooms.build(room_params)

      if @room.save
        redirect_to admin_hotel_room_path(@hotel, @room), notice: 'Room was successfully created.'
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @room.update(room_params)
        redirect_to admin_hotel_room_path(@hotel, @room), notice: 'Room was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @room.destroy
      redirect_to admin_hotel_rooms_path(@hotel), notice: 'Room was successfully deleted.'
    end

    private

    def set_platform
      @platform = current_platform
    end

    def set_hotel
      @hotel = @platform.hotels.find(params[:hotel_id])
    end

    def set_room
      @room = @hotel.rooms.find(params[:id])
    end

    def room_params
      params.require(:room).permit(
        :name, :room_type, :price_per_night, :capacity,
        :max_adults, :max_children, :description,
        :images, amenity_ids: []
      )
    end
  end
end 