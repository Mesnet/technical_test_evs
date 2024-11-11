class Price < ApplicationRecord
	validates :value, presence: true
	validates :recorded_at, presence: true
	scope :ordered_by_recorded_at, -> { order(recorded_at: :asc) }
end
