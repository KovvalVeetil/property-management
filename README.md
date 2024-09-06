# Real Estate Property Management Backend API

This is the backend API for a Real Estate Property Management system built with Ruby on Rails. It handles user, property, booking, and payment functionalities, including integration with Stripe for payment processing.

## Overview

This project provides the backend services for managing users, properties, bookings, and payments in a Real Estate Property Management system. It integrates with Stripe to handle payment processing, including mock testing with stripe-ruby-mock for development and test environments.

## Features

- User Management: Register, authenticate, and manage users.
- Property Management: Create, update, and delete property listings.
- Booking Management: Handle booking requests and manage booking statuses.
- Payment Processing: Integrate with Stripe to process payments securely.
- Error Handling: Robust error handling for Stripe API interactions, including card errors, authentication errors, and network issues.
- Testing: Comprehensive RSpec tests with Stripe mock to simulate payment scenarios.

## Technologies used
- Ruby on Rails: Backend framework
- PostgreSQL: Database
- Stripe: Payment processing
- RSpec: Testing framework
- stripe-ruby-mock: Stripe API mocking for testing
- Pry: Debugging tool

## API Endpoints

```bash
Users
- POST /users: Register a new user
GET /users/
  Retrieve a specific user

Properties
- POST /properties: Create a new property
- GET /properties/
  Retrieve a specific property

Bookings
- POST /bookings: Create a new booking
- GET /bookings/
  Retrieve a specific booking

Payments
- POST /payments: Process a new payment
- GET /payments/
  Retrieve a specific payment

```
