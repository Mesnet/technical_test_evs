# db/seeds.rb

# Clear out existing data to avoid duplicates
Price.destroy_all

# Seed data for a specific date
seed_date = Date.new(2024, 11, 11)

# Create a few sample price entries at different times
Price.create!(recorded_at: seed_date.to_datetime.change({ hour: 9, min: 0 }), value: 100.25)
Price.create!(recorded_at: seed_date.to_datetime.change({ hour: 10, min: 0 }), value: 100.50)
Price.create!(recorded_at: seed_date.to_datetime.change({ hour: 11, min: 30 }), value: 99.75)
Price.create!(recorded_at: seed_date.to_datetime.change({ hour: 14, min: 0 }), value: 101.00)
Price.create!(recorded_at: seed_date.to_datetime.change({ hour: 15, min: 45 }), value: 100.10)

puts "Seeded #{Price.count} price records."
