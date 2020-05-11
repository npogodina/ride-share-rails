class Passenger < ApplicationRecord
  has_many :trips

  validates :name, presence: true, uniqueness: true
  validates :phone_num, presence: true

  def total_spent
    total_spent = self.trips.sum do |trip|
      trip.cost
    end
  end

  def total_trips
    self.trips.count
  end

end
