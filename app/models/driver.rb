class Driver < ApplicationRecord
  has_many :trips, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :vin, presence: true

  def total_earnings
    total_earnings = self.trips.sum do |trip|
      (trip.cost - 1.65) * 0.8
    end
  end

  def average_rating
    average_rating = 0

    rated_trips = self.trips.select { |trip| trip.rating != nil }
    rated_trips_num = rated_trips.count

    if rated_trips_num > 0
      rating_sum = rated_trips.sum { |trip| trip.rating }
      average_rating = rating_sum / rated_trips_num
    end

    return average_rating
  end

  def set_unavailable
    self.available = false
    self.save 
    return true
  end

end
