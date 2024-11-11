class Prices::MaxDailyGapCalculatorService
	attr_reader :date

  def initialize(date)
    @date = date
  end

  def execute
		calculate_max_gap
  end

	private

	def calculate_max_gap
    prices = price_values
    return 0 if prices.empty?

    min_price = prices.first
    max_gap = 0

    prices.each do |current_price|
			# Calculate the potential gap
      potential_gap = current_price - min_price
      max_gap = [max_gap, potential_gap].max

      min_price = [min_price, current_price].min
    end

    max_gap
  end

  def price_values
    @price_values ||= Price.where(recorded_at: date.all_day).ordered_by_recorded_at.pluck(:value)
  end
end