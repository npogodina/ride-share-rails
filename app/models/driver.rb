class Driver < ApplicationRecord
  has_many :trips

  def total_earnings
    total_earnings = self.trips.sum do |trip|
      trip.cost
    end
  end
end
