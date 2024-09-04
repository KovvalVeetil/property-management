# spec/controllers/payments_controller_spec.rb

#To do: create a booking in the DB and test it 
#in progress
require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  let(:valid_attributes) do
    {
        id: 1,
      booking_id: 1,
      amount: 1000.to_i, # Amount in cents
      status: 'pending'
    }
  end

  let(:invalid_attributes) do
    {
      booking_id: nil,
      amount: nil,
      status: nil
    }
  end

  before do
    # Mock the Stripe::Charge.create method to avoid real API calls
    allow(Stripe::Charge).to receive(:create).and_return(double(paid: true))
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Payment' do
        expect {
          post :create, params: { payment: valid_attributes, stripeToken: 'fake_token' }
        }.to change(Payment, :count).by(1)
      end

      it 'renders a JSON response with the new payment' do
        post :create, params: { payment: valid_attributes, stripeToken: 'fake_token' }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(payment_path(Payment.last))
      end
    end

    context 'with invalid params' do
      before do
        allow_any_instance_of(Payment).to receive(:save).and_return(false)
      end

      it 'does not create a new Payment' do
        expect {
          post :create, params: { payment: invalid_attributes, stripeToken: 'fake_token' }
        }.to change(Payment, :count).by(0)
      end

      it 'renders a new template with an alert message' do
        post :create, params: { payment: invalid_attributes, stripeToken: 'fake_token' }
        expect(response).to have_http_status(:ok)
        expect(flash[:alert]).to eq('Payment could not be processed.')
      end
    end

    context 'when Stripe::CardError is raised' do
      before do
        allow(Stripe::Charge).to receive(:create).and_raise(Stripe::CardError.new('Card error', 'error'))
      end

      it 'renders a new template with an alert message' do
        post :create, params: { payment: valid_attributes, stripeToken: 'fake_token' }
        expect(response).to have_http_status(:ok)
        expect(flash[:alert]).to eq('Card error: Card error')
      end
    end

    # Add additional contexts for other Stripe errors as needed
  end

  describe 'GET #show' do
    let(:payment) { Payment.create!(valid_attributes) }

    it 'returns a success response' do
      get :show, params: { id: payment.to_param }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(payment.amount.to_s)
    end
  end

  describe 'PUT #update' do
    let(:payment) { Payment.create!(valid_attributes) }

    context 'with valid params' do
      let(:new_attributes) do
        {
          amount: 2000,
          status: 'completed'
        }
      end

      it 'updates the requested payment' do
        put :update, params: { id: payment.to_param, payment: new_attributes }
        payment.reload
        expect(payment.amount).to eq(2000)
        expect(payment.status).to eq('completed')
      end

      it 'renders a JSON response with the updated payment' do
        put :update, params: { id: payment.to_param, payment: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('completed')
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) do
        {
          amount: nil,
          status: nil
        }
      end

      it 'renders a JSON response with errors for the payment' do
        put :update, params: { id: payment.to_param, payment: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Amount can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:payment) { Payment.create!(valid_attributes) }

    it 'destroys the requested payment' do
      expect {
        delete :destroy, params: { id: payment.to_param }
      }.to change(Payment, :count).by(-1)
    end

    it 'renders a no content response' do
      delete :destroy, params: { id: payment.to_param }
      expect(response).to have_http_status(:no_content)
    end
  end
end
