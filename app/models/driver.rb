class Driver < ApplicationRecord
  has_many :trips

  def total_earnings
    total_earnings = self.trips.sum do |trip|
      (trip.cost - 1.65) * 0.8
    end
  end
end
