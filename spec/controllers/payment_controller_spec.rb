require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  let(:user) { User.create(email: 'john@example.com', password: 'password', password_confirmation: 'password') }
  let(:property) { Property.create(title: 'Beautiful House', description: 'Nice description', price: 200.00, location: 'Somewhere', user: user) }
  let!(:booking) { Booking.create(property_id: property.id, user_id: user.id, start_date: Date.today, end_date: Date.today + 1.week, status: "pending") }
  let(:valid_attributes) {
    {
      booking_id: booking.id,
      amount: 100.00,
      status: "pending"
    }
  }

  let(:invalid_attributes) {
    {
      booking_id: nil,  # Invalid booking_id
      amount: nil,      # Invalid amount
      status: ''        # Invalid status
    }
  }

  before do
    # Stub Stripe's charge creation
    allow(Stripe::Charge).to receive(:create).and_return(double('Charge', paid: true))
  end
  
  describe "POST #create" do
    context "with valid params" do
      it "creates a new Payment" do
        expect {
          post :create, params: { payment: valid_attributes, stripeToken: 'tok_visa' }
        }.to change(Payment, :count).by(1)
      end

      it "creates a new Payment and redirects to the payment show page with a notice" do
        post :create, params: { payment: valid_attributes, stripeToken: 'tok_visa' }
        
        expect(response).to redirect_to(payment_path(Payment.last))
        expect(flash[:notice]).to eq('Payment completed successfully.')
    
        # Optionally check that a payment was created
        expect(Payment.last.booking_id).to eq(valid_attributes[:booking_id])
        expect(Payment.last.amount).to eq(valid_attributes[:amount])
        expect(Payment.last.status).to eq('completed')
      end
    end

    context "with invalid payment parameters" do
      it "renders the 'new' template with an alert" do
        post :create, params: { payment: invalid_attributes, stripeToken: 'tok_visa' }
        
        expect(response).to render_template(:new)
        #binding.pry
        expect(flash[:alert]).to eq('Payment could not be processed.')
      end
    end

    context "when Stripe charge fails" do
      it "renders the 'new' template with an alert for charge failure" do
        allow(Stripe::Charge).to receive(:create).and_return(double(paid: false))
        post :create, params: { payment: valid_attributes, stripeToken: 'tok_visa' }
    
        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq('Charge failed.')
      end
    end

    # context "when Stripe raises errors" do
    #   it "handles Stripe::CardError and renders the 'new' template with an alert" do
    #     allow(Stripe::Charge).to receive(:create).and_raise(Stripe::CardError.new('Card error', nil, nil))
    #     post :create, params: { payment: valid_attributes, stripeToken: 'tok_visa' }
    
    #     expect(response).to render_template(:new)
    #     expect(flash[:alert]).to eq('Card error: Card error')
    #   end
    
    #   it "handles Stripe::InvalidRequestError and renders the 'new' template with an alert" do
    #     allow(Stripe::Charge).to receive(:create).and_raise(Stripe::InvalidRequestError.new('Invalid request', nil, nil))
    #     post :create, params: { payment: valid_attributes, stripeToken: 'tok_visa' }
    
    #     expect(response).to render_template(:new)
    #     expect(flash[:alert]).to eq('Invalid request: Invalid request')
    #   end
    
    #   it "handles Stripe::AuthenticationError and renders the 'new' template with an alert" do
    #     allow(Stripe::Charge).to receive(:create).and_raise(Stripe::AuthenticationError.new('Authentication error', nil, nil))
    #     post :create, params: { payment: valid_attributes, stripeToken: 'tok_visa' }
    
    #     expect(response).to render_template(:new)
    #     expect(flash[:alert]).to eq('Authentication error: Authentication error')
    #   end
    
    #   it "handles Stripe::APIConnectionError and renders the 'new' template with an alert" do
    #     allow(Stripe::Charge).to receive(:create).and_raise(Stripe::APIConnectionError.new('Connection error', nil, nil))
    #     post :create, params: { payment: valid_attributes, stripeToken: 'tok_visa' }
    
    #     expect(response).to render_template(:new)
    #     expect(flash[:alert]).to eq('Connection error: Connection error')
    #   end
    
    #   it "handles Stripe::StripeError and renders the 'new' template with an alert" do
    #     allow(Stripe::Charge).to receive(:create).and_raise(Stripe::StripeError.new('Stripe error', nil, nil))
    #     post :create, params: { payment: valid_attributes, stripeToken: 'tok_visa' }
    
    #     expect(response).to render_template(:new)
    #     expect(flash[:alert]).to eq('Stripe error: Stripe error')
    #   end
    # end

    context "when an unexpected error occurs" do
      it "renders the 'new' template with an alert for unexpected errors" do
        allow(Stripe::Charge).to receive(:create).and_raise(StandardError.new('Unexpected error'))
        post :create, params: { payment: valid_attributes, stripeToken: 'tok_visa' }
    
        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq('Unexpected error: Unexpected error')
      end
    end
  end
end





