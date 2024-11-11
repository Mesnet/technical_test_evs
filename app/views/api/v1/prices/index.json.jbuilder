json.array!(@prices) do |price|
  json.recorded_at price.recorded_at
  json.value format("%.2f", price.value)  # Ensure two decimal places
end
