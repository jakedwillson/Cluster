require "rails_helper"

RSpec.describe HomeController, type: :routing do
  describe "routing" do
    it "routes to #show" do
      expect(:get => "home").to route_to("home#show")
    end
  end
end
