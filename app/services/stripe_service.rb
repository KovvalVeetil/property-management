# class StripeService
#     def initialize(amount, currency = 'cad')
#       @amount = amount
#       @currency = currency
#     end
  
#     def create_charge(token)
#       Stripe::Charge.create({
#         amount: @amount,
#         currency: @currency,
#         source: token,
#         description: 'Real Estate Booking'
#       })
#     end
#   end
  
require 'stripe'

class StripeService
  def initialize
    Stripe.api_key = Rails.application.credentials.stripe[:secret_key]
  end

  def create_payment(amount:, currency:, source:, description:)
    begin
      # Create a charge with Stripe
      Stripe::Charge.create(
        amount: amount,
        currency: currency,
        source: source,
        description: description
      )
    rescue Stripe::CardError => e
      # Handle card errors (e.g., insufficient funds, card declined)
      { success: false, error: e.message }
    rescue Stripe::InvalidRequestError => e
      # Handle invalid requests (e.g., invalid parameters)
      { success: false, error: e.message }
    rescue Stripe::AuthenticationError => e
      # Handle authentication errors (e.g., invalid API key)
      { success: false, error: "Authentication error: #{e.message}" }
    rescue Stripe::APIConnectionError => e
      # Handle network errors (e.g., unable to connect to Stripe API)
      { success: false, error: "Connection error: #{e.message}" }
    rescue Stripe::StripeError => e
      # Handle other Stripe errors
      { success: false, error: "Stripe error: #{e.message}" }
    rescue StandardError => e
      # Handle other unexpected errors
      { success: false, error: "Unexpected error: #{e.message}" }
    end
  end
end
