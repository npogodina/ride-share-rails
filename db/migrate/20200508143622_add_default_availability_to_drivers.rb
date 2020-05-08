class AddDefaultAvailabilityToDrivers < ActiveRecord::Migration[6.0]
  def change
    change_column :drivers, :available, :boolean, default: true
  end
end
