require 'rails_helper'

RSpec.describe Price, type: :model do
  it "is invalid without a value" do
    price = Price.new(value: nil)
    price.valid?

    expect(price.errors[:value]).to include("can't be blank")
  end

  it "is invalid without a recorded_at" do
    price = Price.new(recorded_at: nil)
    price.valid?
    expect(price.errors[:recorded_at]).to include("can't be blank")
  end
end
