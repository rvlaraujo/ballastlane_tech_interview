require "rails_helper"

RSpec.describe GendersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/genders").to route_to("genders#index")
    end

    it "routes to #show" do
      expect(get: "/genders/1").to route_to("genders#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/genders").to route_to("genders#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/genders/1").to route_to("genders#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/genders/1").to route_to("genders#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/genders/1").to route_to("genders#destroy", id: "1")
    end
  end
end
