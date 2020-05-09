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

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new
    if @trip.save 
      redirect_to trips_path 
      return
    else 
      render :new 
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
