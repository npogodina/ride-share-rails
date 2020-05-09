class DriversController < ApplicationController
  def index
    @drivers = Driver.all
  end

  def show
    driver_id = params[:id]
    @driver = Driver.find_by(id: driver_id)
    if @driver.nil?
      head :not_found # !
      return
    end
  end

  def new
    @driver = Driver.new
  end

  def create
    @driver = Driver.new(driver_params) 
    if @driver.save 
      redirect_to drivers_path 
      return
    else 
      render :new 
      return
    end
  end

  def driver_params
    return params.require(:driver).permit(:name, :vin, :available)
  end

end
