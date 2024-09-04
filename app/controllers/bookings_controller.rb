class BookingsController < ApplicationController
    before_action :set_booking, only: [:show, :update, :destroy]
  
    def create
      @booking = Booking.new(booking_params)
      if @booking.save
        render json: @booking, status: :created
      else
        render json: @booking.errors, status: :unprocessable_entity
      end
    end
  
    def show
      render json: @booking
    end
  
    def update
      if @booking.update(booking_params)
        render json: @booking
      else
        render json: @booking.errors, status: :unprocessable_entity
      end
    end
  
    def destroy
      @booking.destroy
      head :no_content
    end
  
    private
  
    def set_booking
      @booking = Booking.find(params[:id])
    end
  
    def booking_params
      params.require(:booking).permit(:property_id, :user_id, :start_date, :end_date, :status)
    end
  end
  