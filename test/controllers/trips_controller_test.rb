require "test_helper"

describe TripsController do
  describe "show" do
    it "responds with success when showing an existing valid trip" do
      driver = Driver.create(name: "Kari", vin: "123")
      passenger = Passenger.create(name: "Evelynn", phone_num: "123-45-67")
      trip = Trip.create(
        driver_id: driver.id,
        passenger_id: passenger.id,
        date: Date.today,
        cost: 1500        
      )
   
      get trip_path(trip.id)
      must_respond_with :success
    end

    it "responds with 404 for an invalid trip id" do
      trip_id = -1
      trip = Trip.find_by(id: trip_id)
      assert_nil trip

      get trip_path(trip_id)
      must_respond_with :missing
    end
  end

  describe "create" do
    it "can create a new trip with valid information accurately, and redirect" do
      driver = Driver.create(name: "Kari", vin: "123")
      expect(Driver.all.count).must_equal 1

      passenger = Passenger.create(name: "Evelynn", phone_num: "123-45-67")
      trip_form_data = {
        passenger_id: passenger.id
      }

      expect {
        post trips_path, params: trip_form_data
      }.must_change "Trip.count", 1

      new_trip = Trip.find_by(passenger_id: trip_form_data[:passenger_id])
      expect(new_trip.driver_id).must_equal driver.id
      expect(new_trip.date).must_equal Date.today
      expect(new_trip.cost).must_be :>, 999
      expect(new_trip.cost).must_be :<, 3001

      must_respond_with :redirect
      p passenger.id
      must_redirect_to passenger_path(passenger.id)
    end

    it "does not create a trip if passenger is invalid" do
      driver = Driver.create(name: "Kari", vin: "123")
      expect(Driver.all.count).must_equal 1

      passenger_id = -1
      passenger = Passenger.find_by(id: passenger_id)
      assert_nil passenger

      trip_form_data = {
        passenger_id: passenger_id
      }

      expect {
        post trips_path, params: trip_form_data
      }.wont_change "Trip.count"

      must_respond_with :missing
    end

    it "does not create a trip if there are no available drivers and redirects back to passenger's page" do
      driver = Driver.create(name: "Kari", vin: "123", available: false)
      assert_nil Driver.find_by(available: true)
      
      passenger = Passenger.create(name: "Evelynn", phone_num: "123-45-67")
      trip_form_data = {
        passenger_id: passenger.id
      }

      expect {
        post trips_path, params: trip_form_data
      }.wont_change "Trip.count"

      must_respond_with :redirect
      must_redirect_to passenger_path(passenger.id)
    end
    
  end

  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid trip" do
      driver = Driver.create(name: "Kari", vin: "123")
      expect(Driver.all.count).must_equal 1

      passenger = Passenger.create(name: "Evelynn", phone_num: "123-45-67")
      trip_form_data = {
        passenger_id: passenger.id
      }
      
      post trips_path, params: trip_form_data
      expect(Trip.count).must_equal 1
      trip = Trip.first

      get edit_trip_path(trip.id)
      must_respond_with :success
    end

    it "responds with not found when getting the edit page for a non-existing trip" do
      trip_id = -1
      trip = Trip.find_by(id: trip_id)
      assert_nil trip

      get edit_trip_path(trip_id)
      must_respond_with :missing
    end
  end

  describe "update" do
    it "can update an existing trip with valid information accurately, and redirect" do
      driver = Driver.create(name: "Kari", vin: "123")
      expect(Driver.all.count).must_equal 1

      passenger = Passenger.create(name: "Evelynn", phone_num: "123-45-67")
      trip_form_data = {
        passenger_id: passenger.id
      }
      
      post trips_path, params: trip_form_data
      expect(Trip.count).must_equal 1
      trip = Trip.first
      trip_id = trip.id

      updated_form_data = {
        trip: {
          date: Date.today - 1,
          rating: 5,
          cost: 1000
        }
      }

      expect {
        patch trip_path(trip_id), params: updated_form_data
      }.wont_change "Trip.count"

      trip = Trip.find_by(id: trip_id)
      expect(trip.date).must_equal updated_form_data[:trip][:date]
      expect(trip.rating).must_equal updated_form_data[:trip][:rating]
      expect(trip.cost).must_equal updated_form_data[:trip][:cost]
    end

    it "does not update any trip if given an invalid id, and responds with a 404" do
      trip_id = -1
      trip = Trip.find_by(id: trip_id)
      assert_nil trip

      updated_form_data = {
        trip: {
          date: Date.today - 1,
          rating: 5,
          cost: 1000
        }
      }

      expect {
        patch trip_path(trip_id), params: updated_form_data
      }.wont_change "Trip.count"

      must_respond_with :missing
    end

    it "does not update a trip if the form data violates Trip validations, and rerenders the form" do
      driver = Driver.create(name: "Kari", vin: "123")
      expect(Driver.all.count).must_equal 1

      passenger = Passenger.create(name: "Evelynn", phone_num: "123-45-67")
      trip_form_data = {
        passenger_id: passenger.id
      }
      
      post trips_path, params: trip_form_data
      expect(Trip.count).must_equal 1
      trip = Trip.first

      updated_form_data = {
        trip: {
          date: "not sure",
          rating: 5,
          cost: 133
        }
      }

      expect {
        patch trip_path(trip.id), params: updated_form_data
      }.wont_change "Trip.count"

      must_respond_with :success
      # assert_template :edit
    end
  end

  describe "destroy" do
    it "destroys the trip instance in db when trip exists, then redirects" do
      driver = Driver.create(name: "Kari", vin: "123")
      expect(Driver.all.count).must_equal 1

      passenger = Passenger.create(name: "Evelynn", phone_num: "123-45-67")
      trip_form_data = {
        passenger_id: passenger.id
      }
      
      post trips_path, params: trip_form_data
      expect(Trip.count).must_equal 1
      trip = Trip.first

      expect {
        delete trip_path(trip.id)
      }.must_change "Trip.count", -1

      must_redirect_to root_path
    end

    it "does not change the db when the trip does not exist, then responds with " do
      trip_id = -1
      trip = Trip.find_by(id: trip_id)
      assert_nil trip

      expect {
        delete trip_path(trip_id)
      }.wont_change "Trip.count"

      must_respond_with :missing
    end
  end
end
