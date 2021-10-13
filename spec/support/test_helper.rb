# frozen_string_literal: true

def json_body
  JSON.parse(response.body)
end
