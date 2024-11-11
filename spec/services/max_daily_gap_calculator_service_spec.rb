# spec/services/max_daily_gap_calculator_service_spec.rb
require 'rails_helper'

RSpec.describe Prices::MaxDailyGapCalculatorService, type: :service do
  let(:date) { Date.new(2024, 11, 20) }

  before do
    Price.create!(recorded_at: date.to_datetime.change({ hour: 10 }), value: 100.0)
    Price.create!(recorded_at: date.to_datetime.change({ hour: 12 }), value: 105.0)
    Price.create!(recorded_at: date.to_datetime.change({ hour: 14 }), value: 102.0)
    Price.create!(recorded_at: date.to_datetime.change({ hour: 16 }), value: 110.0)
    Price.create!(recorded_at: date.to_datetime.change({ hour: 18 }), value: 95.0)
    Price.create!(recorded_at: date.to_datetime.change({ hour: 20 }), value: 120.0)
  end

  it "calculates the maximum daily gap correctly" do
    service = Prices::MaxDailyGapCalculatorService.new(date)
    expect(service.execute).to eq(25.0)  # Buy at 95.0, sell at 120.0
  end

  it "returns 0 if there are no prices for the date" do
    empty_service = Prices::MaxDailyGapCalculatorService.new(Date.new(2024, 11, 23))  # Date with no data
    expect(empty_service.execute).to eq(0)
  end

  it "returns 0 if all prices are in descending order" do
		Price.delete_all
    descending_prices = [
      Price.create!(recorded_at: date.to_datetime.change({ hour: 10 }), value: 120.0),
      Price.create!(recorded_at: date.to_datetime.change({ hour: 12 }), value: 110.0),
      Price.create!(recorded_at: date.to_datetime.change({ hour: 14 }), value: 105.0)
    ]
    descending_service = Prices::MaxDailyGapCalculatorService.new(date)
    expect(descending_service.execute).to eq(0)
  end
end
