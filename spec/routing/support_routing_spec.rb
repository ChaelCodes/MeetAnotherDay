# frozen_string_literal: true

require "rails_helper"

RSpec.describe SupportController, type: :routing do
  describe "routing" do
    it "routes to #about(Root)" do
      expect(get: "/").to route_to("support#about")
    end

    it "routes to #about" do
      expect(get: "/about").to route_to("support#about")
    end
  end
end
