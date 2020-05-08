class AddDriversToTrips < ActiveRecord::Migration[6.0]
  def change
    add_reference :trips, :driver, foreign_key: true
  end
end
