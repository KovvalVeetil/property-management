class PaymentsController < ApplicationController
  before_action :set_payment, only: [:show, :update, :destroy]

  def create
    @payment = Payment.new(payment_params)
    binding.pry
    begin
      charge = Stripe::Charge.create(
        amount: @payment.amount,
        currency: 'cad',
        source: params[:stripeToken],
        description: "Booking ID: #{@payment.booking_id}"
      )
      binding.pry

      if charge.paid
        @payment.status = 'completed'
        if @payment.save
          redirect_to payment_path(@payment), notice: 'Payment completed successfully.'
        else
          Rails.logger.error @payment.errors.full_messages.to_sentence
  render :new, alert: 'Payment could not be processed.'
        end
      else
        render :new, alert: 'Charge failed.'
      end
    rescue Stripe::CardError => e
      # Handle card errors (e.g., declined card)
      render :new, alert: "Card error: #{e.message}"
    rescue Stripe::InvalidRequestError => e
      # Handle invalid request errors (e.g., invalid parameters)
      render :new, alert: "Invalid request: #{e.message}"
    rescue Stripe::AuthenticationError => e
      # Handle authentication errors (e.g., invalid API key)
      render :new, alert: "Authentication error: #{e.message}"
    rescue Stripe::APIConnectionError => e
      # Handle network errors (e.g., unable to connect to Stripe API)
      render :new, alert: "Connection error: #{e.message}"
    rescue Stripe::StripeError => e
      # Handle other Stripe errors
      render :new, alert: "Stripe error: #{e.message}"
    rescue StandardError => e
      # Handle other unexpected errors
      render :new, alert: "Unexpected error: #{e.message}"
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
