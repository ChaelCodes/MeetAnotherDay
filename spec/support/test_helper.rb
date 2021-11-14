# frozen_string_literal: true

def json_body
  JSON.parse(response.body)
end

# For Request Specs
RSpec.shared_examples "show page renders a sucessful response" do
  it "renders a successful response" do
    subject
    expect(response).to be_successful
  end
end

RSpec.shared_examples "unprocessable entity" do
  it "returns an unprocessable entity code" do
    subject
    expect(response.status).to eq(422)
  end
end
