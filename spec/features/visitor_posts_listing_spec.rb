require 'spec_helper'

feature 'Visitor submits listing' do
  scenario 'it creates a new listing when visitor submits form' do
    visit '/'
    fill_in 'title', with:'Womens Size XXL Chainmail Shirt'
    click_on 'Submit Listing'
    expect(page).to have_content ('Womens Size XXL Chainmail Shirt')
  end
end



