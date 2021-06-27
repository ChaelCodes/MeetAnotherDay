# frozen_string_literal: true

require 'rails_helper'

describe 'Users#show' do
  let(:user_profile) do
    User.create(name: 'Sample', bio: 'This is a bio', confirmed_at: 1.minute.ago, email: 'chaelcodes@example.com',
                password: 'P@55w0rd')
  end

  before(:each) do
    sign_in user if user
    visit "/users/#{user_profile.id}".dup
  end

  context 'when no user logged in' do
    let(:user) { nil }

    it 'demands signup' do
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
      expect(page).to_not have_content user_profile.name
    end
  end

  context 'logged_in user' do
    let(:user) { User.create(name: 'Sample', bio: 'This is a bio', confirmed_at: 1.minute.ago) }

    it 'shows basic user information' do
      expect(page).to have_content user_profile.name
    end
  end

  context 'unconfirmed user' do
    let(:user) { User.create(name: 'Sample', bio: 'This is a bio', confirmed_at: nil) }

    it 'prompts the user to confirm email' do
      expect(page).to have_content 'You have to confirm your email address before continuing.'
      expect(page).not_to have_content user_profile.name
    end
  end
end
