# frozen_string_literal: true

def json_body
  JSON.parse(response.body)
end

# For Request Specs
RSpec.shared_examples "show page renders a sucessful response" do
  it "renders a successful response" do
    get_show
    expect(response).to be_successful
  end
end
