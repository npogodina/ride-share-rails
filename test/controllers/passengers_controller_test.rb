require "test_helper"

describe PassengersController do
  describe "index" do
    it "responds with success when there are passengers saved" do
      passenger = Passenger.create(name: "Evelynn", phone_num: "123-45-67")
      get passengers_path
      must_respond_with :success
    end

    it "responds with success when there are no passengers saved" do
      passengers = Passenger.all
      expect(passengers).must_equal []
      get passengers_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing an existing valid passenger" do
      passenger = Passenger.create(name: "Evelynn", phone_num: "123-45-67")
      get passenger_path(passenger.id)
      must_respond_with :success
    end

    it "responds with 404 for an invalid passenger id" do
      passenger_id = -1
      passenger = Passenger.find_by(id: passenger_id)
      assert_nil passenger
      
      get passenger_path(passenger_id)
      must_respond_with :missing
    end
  end

  describe "new" do
    it "responds with success" do
      get new_passenger_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new passenger with valid information accurately, and redirect" do
      passenger_form_data = {
        passenger: {
          name: "Cody",
          phone_num: "999-99-99"
        }
      }

      expect {
        post passengers_path, params: passenger_form_data
      }.must_change "Passenger.count", 1

      new_passenger = Passenger.find_by(name: passenger_form_data[:passenger][:name])
      expect(new_passenger.phone_num).must_equal passenger_form_data[:passenger][:phone_num]
    end

    it "does not create a passenger if the form data violates Passenger validations, and re-renders the form" do
      passenger_form_data = {
        passenger: {
          name: "",
          phone_num: ""
        }
      }

      expect {
        post passengers_path, params: passenger_form_data
      }.wont_change "Passenger.count"
    
      must_respond_with :success
      # assert_template :new
    end
  end

  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid passenger" do
      passenger = Passenger.create(name: "Evelynn", phone_num: "123-45-67")
      get edit_passenger_path(passenger.id)
      must_respond_with :success
    end

    it "responds with not found when getting the edit page for a non-existing passenger" do
      passenger_id = -1
      passenger = Passenger.find_by(id: passenger_id)
      assert_nil passenger

      get edit_passenger_path(passenger_id)
      must_respond_with :missing
    end
  end

  describe "update" do
    it "can update an existing passenger with valid information accurately, and redirect" do
      passenger = Passenger.create(name: "Evelynn", phone_num: "123-45-67")
      passenger_id = passenger.id
      passenger_form_data = {
        passenger: {
          name: "Cody",
          phone_num: "999-99-99"
        }
      }

      expect {
        patch passenger_path(passenger_id), params: passenger_form_data
      }.wont_change "Passenger.count"

      passenger = Passenger.find_by(id: passenger_id)
      expect(passenger.name).must_equal passenger_form_data[:passenger][:name]
      expect(passenger.phone_num).must_equal passenger_form_data[:passenger][:phone_num]
    end


    it "does not update any passenger if given an invalid id, and responds with a 404" do
      passenger_id = -1
      passenger = Passenger.find_by(id: passenger_id)
      assert_nil passenger
      passenger_form_data = {
        passenger: {
          name: "Cody",
          phone_num: "999-99-99"
        }
      }

      expect {
        patch passenger_path(passenger_id), params: passenger_form_data
      }.wont_change "Passenger.count"

      must_respond_with :missing
    end

    it "does not create a passenger if the form data violates Passenger validations, and re-renders the form" do
      passenger = Passenger.create(name: "Evelynn", phone_num: "123-45-67")
      passenger_id = passenger.id
      passenger_form_data = {
        passenger: {
          name: "",
          phone_num: ""
        }
      }

      expect {
        patch passenger_path(passenger_id), params: passenger_form_data
      }.wont_change "Passenger.count"

      must_respond_with :success
      # assert_template :new
    end
  end

  describe "destroy" do
    it "destroys the passenger instance in db when passenger exists, then redirects" do
      passenger = Passenger.create(name: "Evelynn", phone_num: "123-45-67")
      expect {
        delete passenger_path(passenger.id)
      }.must_change "Passenger.count", -1
      must_redirect_to passengers_path
    end

    it "does not change the db when the passenger does not exist, then responds with " do
      passenger_id = -1
      passenger = Passenger.find_by(id: passenger_id)
      assert_nil passenger

      expect {
        delete passenger_path(passenger_id)
      }.wont_change "Passenger.count"
      
      must_respond_with :missing
    end
  end
end
