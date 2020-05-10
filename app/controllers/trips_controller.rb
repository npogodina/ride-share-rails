class TripsController < ApplicationController
  
  def show
    trip_id = params[:id]
    @trip = Trip.find_by(id: trip_id)
    if @trip.nil?
      head :not_found
      return
    end

    @driver = @trip.driver
    @passenger = @trip.passenger
  end

  def new # ?
    @trip = Trip.new
  end

  def create
    driver = Driver.find_by(available: true)

    @trip = Trip.new(
      passenger_id: params[:passenger_id],
      driver_id: driver.id,
      date: Date.today,
      rating: nil,
      cost: 1000
    )
    if @trip.save
      driver.set_unavailable 
      redirect_to passengers_path 
      return
    else 
      redirect_to drivers_path 
      return
    end
  end

  def edit
    @trip = Trip.find_by(id: params[:id])

    if @trip.nil?
      head :not_found
      return
    end
  end

  def update
    @trip = Trip.find_by(id: params[:id])
    if @trip.nil?
      head :not_found
      return
    elsif @trip.update()
      redirect_to trips_path
      return
    else 
      render :edit
      return
    end
  end

  def destroy
    @trip = Trip.find_by(id: params[:id])

    if @trip.nil?
      head :not_found
      return
    end

    @trip.destroy

    redirect_to trips_path
    return
  end
end
