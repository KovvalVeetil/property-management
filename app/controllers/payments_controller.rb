class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :update, :destroy]

  # def create
  #   @payment = Payment.new(payment_params)
  #   #binding.pry
  #   begin
  #     charge = Stripe::Charge.create(
  #       amount: @payment.amount,
  #       currency: 'cad',
  #       source: params[:stripeToken],
  #       description: "Booking ID: #{@payment.booking_id}"
  #     )
  #     #binding.pry

  #     if charge.paid
  #       @payment.status = 'completed'
  #       #binding.pry
  #       if @payment.save
  #         #render json: @payment, status: :created
  #         redirect_to payment_path(@payment), notice: 'Payment completed successfully.'
  #       else
  #         Rails.logger.error @payment.errors.full_messages.to_sentence
  #         #Rails.logger.error "Payment could not be processed"
  #     flash[:alert] = "Payment could not be processed."  # Set the flash message
  # render :new
  #       end
  #     else
  #     flash[:alert] = "Charge failed."  # Set the flash message
  # render :new
  #     end
  #   rescue Stripe::CardError => e
  #     # Handle card errors (e.g., declined card)
  #     Rails.logger.error "Card error: #{e.message}"
  #     flash[:alert] = "Card error: #{e.message}"  # Set the flash message
  # render :new
  #     #render :new, alert: "Card error: #{e.message}"
  #   rescue Stripe::InvalidRequestError => e
  #     # Handle invalid request errors (e.g., invalid parameters)
  #     Rails.logger.error "Invalid request: #{e.message}"
  #     flash[:alert] = "Invalid request: #{e.message}"  # Set the flash message
  # render :new
  #     #render :new, alert: "Invalid request: #{e.message}"
  #   rescue Stripe::AuthenticationError => e
  #     # Handle authentication errors (e.g., invalid API key)
  #     Rails.logger.error "Authentication error: #{e.message}"
  #     flash[:alert] = "Authentication error: #{e.message}"  # Set the flash message
  # render :new
  #     render :new, alert: "Authentication error: #{e.message}"
  #   rescue Stripe::APIConnectionError => e
  #     # Handle network errors (e.g., unable to connect to Stripe API)
  #     Rails.logger.error "Connection error: #{e.message}"
  #     flash[:alert] = "Connection error: #{e.message}"  # Set the flash message
  # render :new
  #    # render :new, alert: "Connection error: #{e.message}"
  #   rescue Stripe::StripeError => e
  #     # Handle other Stripe errors
  #     Rails.logger.error "Stripe error: #{e.message}"
  #     flash[:alert] = "Stripe error: #{e.message}"  # Set the flash message
  # render :new
  #     #render :new, alert: "Stripe error: #{e.message}"
  #   rescue StandardError => e
  #     # Handle other unexpected errors
  #     Rails.logger.error "Unexpected error: #{e.message}"
  #     flash[:alert] = "Unexpected error: #{e.message}"  # Set the flash message
  # render :new
  #   end
  # end

  def create
    @payment = Payment.new(payment_params)
    
    begin
      charge = Stripe::Charge.create(
        amount: @payment.amount,
        currency: 'cad',
        source: params[:stripeToken],
        description: "Booking ID: #{@payment.booking_id}"
      )
      
      if charge.paid
        @payment.status = 'completed'
        if @payment.save
          redirect_to payment_path(@payment), notice: 'Payment completed successfully.'
        else
          Rails.logger.error "Payment could not be processed: #{@payment.errors.full_messages.to_sentence}"
          flash[:alert] = 'Payment could not be processed.'  # Set the flash message for invalid payment
          render :new
        end
      else
        flash[:alert] = 'Charge failed.'  # Set the flash message for charge failure
        render :new
      end
    rescue Stripe::CardError => e
      Rails.logger.error "Card error: #{e.message}"
      flash[:alert] = "Card error: #{e.message}"
      render :new
    rescue Stripe::InvalidRequestError => e
      Rails.logger.error "Invalid request: #{e.message}"
      flash[:alert] = "Invalid request: #{e.message}"
      render :new
    rescue Stripe::AuthenticationError => e
      Rails.logger.error "Authentication error: #{e.message}"
      flash[:alert] = "Authentication error: #{e.message}"
      render :new
    rescue Stripe::APIConnectionError => e
      Rails.logger.error "Connection error: #{e.message}"
      flash[:alert] = "Connection error: #{e.message}"
      render :new
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe error: #{e.message}"
      flash[:alert] = "Stripe error: #{e.message}"
      render :new
    rescue StandardError => e
      Rails.logger.error "Unexpected error: #{e.message}"
      flash[:alert] = "Unexpected error: #{e.message}"
      render :new    
    end
  end

  def show
    render json: @payment
  end

  def update
    if @payment.update(payment_params)
      render json: @payment
    else
      render json: @payment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @payment.destroy
    head :no_content
  end

  private

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(:booking_id, :amount, :status)
  end
end
