# frozen_string_literal: true

require "rails_helper"

RSpec.describe Friendship, type: :model do
  let(:friendship) { create(:friendship) }

  it { expect(friendship).to be_valid }
end
