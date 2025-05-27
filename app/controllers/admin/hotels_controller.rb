module Admin
  class HotelsController < Admin::BaseController
    before_action :set_platform
    before_action :set_hotel, only: [:show, :edit, :update, :destroy]

    def index
      @hotels = @platform.hotels.includes(:rooms).page(params[:page]).per(10)
    end

    def show
      @rooms = @hotel.rooms.includes(:amenities).page(params[:page]).per(10)
    end

    def new
      @hotel = @platform.hotels.build
    end

    def create
      @hotel = @platform.hotels.build(hotel_params)

      if @hotel.save
        redirect_to admin_hotel_path(@hotel), notice: 'Hotel was successfully created.'
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @hotel.update(hotel_params)
        redirect_to admin_hotel_path(@hotel), notice: 'Hotel was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @hotel.destroy
      redirect_to admin_hotels_path, notice: 'Hotel was successfully deleted.'
    end

    private

    def set_platform
      @platform = current_platform
    end

    def set_hotel
      @hotel = @platform.hotels.find(params[:id])
    end

    def hotel_params
      params.require(:hotel).permit(
        :name, :address, :description, :star_rating,
        :images, amenity_ids: []
      )
    end
  end
end 