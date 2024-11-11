# spec/requests/api/v1/prices_controller_spec.rb
require 'rails_helper'

RSpec.describe "Api::V1::PricesController", type: :request do
  describe "GET /api/v1/prices" do
    context "when date parameter is missing" do
      it "returns a 400 Bad Request error with a specific error message" do
        get "/api/v1/prices"
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq("error" => "Date parameter is required")
      end
    end

    context "when date parameter is in an invalid format" do
      it "returns a 400 Bad Request error with a format-specific error message" do
        get "/api/v1/prices", params: { date: 'invalid-date' }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq("error" => "Invalid date format. Please use YYYY-MM-DD format")
      end
    end

    context "when date parameter is valid" do
      before do
        # Create test data out of order
        Price.create!(recorded_at: "2024-11-20 15:00:00", value: 101.00)
        Price.create!(recorded_at: "2024-11-20 10:00:00", value: 100.25)
        Price.create!(recorded_at: "2024-11-20 12:00:00", value: 100.75)
      end

      it "returns prices ordered by recorded_at in ascending order" do
        get "/api/v1/prices", params: { date: '2024-11-20' }
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)

        # Check the order of the returned prices
        expect(json_response[0]["recorded_at"]).to eq("2024-11-20T10:00:00.000Z")
        expect(json_response[1]["recorded_at"]).to eq("2024-11-20T12:00:00.000Z")
        expect(json_response[2]["recorded_at"]).to eq("2024-11-20T15:00:00.000Z")
      end
    end
  end

  describe "GET /api/v1/prices/max_daily_gap" do
    context "when date parameter is valid" do
      before do
        Price.create!(recorded_at: DateTime.parse("2024-11-20 10:00:00"), value: 100.0)
        Price.create!(recorded_at: DateTime.parse("2024-11-20 12:00:00"), value: 105.0)
        Price.create!(recorded_at: DateTime.parse("2024-11-20 14:00:00"), value: 102.0)
        Price.create!(recorded_at: DateTime.parse("2024-11-20 16:00:00"), value: 110.0)
        Price.create!(recorded_at: DateTime.parse("2024-11-20 18:00:00"), value: 95.0)
        Price.create!(recorded_at: DateTime.parse("2024-11-20 20:00:00"), value: 120.0)
      end

      it "returns the maximum daily gap for the specified date" do
        get "/api/v1/prices/max_daily_gap", params: { date: '2024-11-20' }
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)

        # Expect the max gap to be calculated correctly as 25.0 (buy at 95.0, sell at 120.0)
        expect(json_response["max_daily_gap"]).to eq("25.00")
      end
    end
  end


end
