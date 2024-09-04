class PaymentsController < ApplicationController
    before_action :set_payment, only: [:show, :update, :destroy]
  
    def create
      @payment = Payment.new(payment_params)
      if @payment.save
        stripe_service = StripeService.new(@payment.amount)
        charge = stripe_service.create_charge(params[:stripeToken])
  
        if charge.paid
          @payment.update(status: 'completed')
          render json: { success: true, charge: charge }, status: :created
        else
          @payment.update(status: 'failed')
          render json: { error: 'Payment failed' }, status: :unprocessable_entity
        end
      else
        render json: @payment.errors, status: :unprocessable_entity
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
  