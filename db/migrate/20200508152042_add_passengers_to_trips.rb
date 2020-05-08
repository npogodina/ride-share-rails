class AddPassengersToTrips < ActiveRecord::Migration[6.0]
  def change
    add_reference :trips, :passenger, foreign_key: true
  end
end
