# frozen_string_literal: true

require "rails_helper"

describe EventAttendeePolicy, type: :policy do
  # Permissions should match show_details on the profile
  permissions :show? do
    context "with viewing event attendee" do
      let(:event_attendee) { build :event_attendee }

      context "with no user" do
        it { expect(described_class).not_to permit(nil, event_attendee) }
      end

      context "with unconfirmed user" do
        let(:user) { create :user, :unconfirmed }

        it { expect(described_class).not_to permit(user, event_attendee) }
      end

      context "with confirmed user" do
        let(:user) { create :user }

        it { expect(described_class).to permit(user, event_attendee) }
      end

      context "with admin" do
        let(:user) { create :user, :admin }

        it { expect(described_class).to permit(user, event_attendee) }
      end
    end
  end

  permissions :update? do
    let(:event_attendee) { build :event_attendee }

    context "with profile matching current profile" do
      let(:user) { event_attendee.profile.user }

      it { expect(described_class).to permit(user, event_attendee) }
    end

    context "with profile not matching current profile" do
      let(:user) { create :user }

      it { expect(described_class).not_to permit(user, event_attendee) }
    end

    context "when user is admin" do
      let(:user) { create :user, :admin }

      it { expect(described_class).to permit(user, event_attendee) }
    end
  end

  permissions ".scope?" do
    subject { Pundit.policy_scope(user, EventAttendee.all) }

    let(:friends) { create :profile, visibility: :friends }
    let(:everyone) { create :profile, visibility: :everyone }

    let(:event) { create :event }

    let!(:friends_attendee) { create :event_attendee, profile: friends, event: }
    let!(:everyone_attendee) { create :event_attendee, profile: everyone, event: }

    context "with no user" do
      let(:user) { nil }

      it { is_expected.to contain_exactly(everyone_attendee) }
    end

    context "with unconfirmed user" do
      let(:user) { create :user, :unconfirmed }
      let(:current_profile) { create :profile, user:, visibility: :myself }
      let(:current_attendee) { create :event_attendee, profile: current_profile, event: }

      context "when friends profile is friendly with you" do
        let!(:friendship) { create :friendship, buddy: friends, friend: current_profile, status: :accepted }

        it { is_expected.to contain_exactly(everyone_attendee, friends_attendee, current_attendee) }
      end

      context "when you are friendly with friends profile" do
        let!(:friendship) { create :friendship, buddy: current_profile, friend: friends, status: :accepted }

        it { is_expected.to contain_exactly(everyone_attendee, current_attendee) }
      end

      context "when you are blocked" do
        let!(:blocked_by_friends) { create :friendship, buddy: friends, friend: current_profile, status: :blocked }
        let!(:blocked_by_everyone) { create :friendship, buddy: everyone, friend: current_profile, status: :blocked }

        it { is_expected.to contain_exactly(current_attendee) }
      end
    end
  end
end
