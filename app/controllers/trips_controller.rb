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

  def create
    driver = Driver.find_by(available: true)
    # what if none available?

    # check if passenger exists?

    @trip = Trip.new(
      passenger_id: params[:passenger_id],
      driver_id: driver.id,
      date: Date.today,
      rating: nil,
      cost: rand(1000..3000)
    )
    if @trip.save
      driver.set_unavailable 
      redirect_to passenger_path(params[:passenger_id])
      return
    else 
      redirect_to passenger_path(params[:passenger_id])
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
    elsif @trip.update(trip_params)
      redirect_to trip_path(params[:id])
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

    redirect_to drivers_path
    return
  end

  def trip_params
    return params.require(:trip).permit(:date, :rating, :cost)
  end
end
