# frozen_string_literal: true

Geocoder.configure(lookup: :test)

Geocoder::Lookup::Test.set_default_stub(
  [
    {
      "coordinates" => [40.7143528, -74.0059731],
      "address" => "123 Main St",
      "state" => "New York",
      "country" => "United States"
    }
  ]
)
