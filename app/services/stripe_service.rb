class StripeService
    def initialize(amount, currency = 'usd')
      @amount = amount
      @currency = currency
    end
  
    def create_charge(token)
      Stripe::Charge.create({
        amount: @amount,
        currency: @currency,
        source: token,
        description: 'Real Estate Booking'
      })
    end
  end
  