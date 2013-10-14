require 'spec_helper'

feature 'Visitor registers as a user' do
  scenario 'it creates a new user when visitor submits sign up form' do
    visit '/signup'
    fill_in 'user_name', with:'arya3'
    click_on 'Sign Up!'
    visit '/'
    expect(page).to have_content ('contribute to the marketplace')
  end
end



feature 'User edits their own listings' do
  scenario 'user can go to page with their own listings' do
    visit '/'
    click_on 'My Listings'
    visit '/mylistings'
    expect(page).to have_content ('My Listings')
  end
end


