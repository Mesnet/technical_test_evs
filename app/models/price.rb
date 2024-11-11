class Price < ApplicationRecord
	validates :value, presence: true
	validates :recorded_at, presence: true
end
