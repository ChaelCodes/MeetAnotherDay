# frozen_string_literal: true

RSpec.shared_examples 'unauthenticated user does not have access' do
  before(:each) do
    sign_in user if user
    visit path.dup
  end

  context 'when no user logged in' do
    let(:user) { nil }

    it 'demands signup' do
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

  context 'unconfirmed user' do
    let(:user) { create(:user, :unconfirmed) }

    it 'prompts the user to confirm email' do
      expect(page).to have_content 'You have to confirm your email address before continuing.'
    end
  end
end
