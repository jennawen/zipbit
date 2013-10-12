require 'spec_helper'

feature 'Visitor edits listing' do
  scenario 'it lets a visitor edit their listing when visitor submits form' do
    visit '/1'
    fill_in 'title', with:'Dragon Eggs - Only Two Remaining'
    click_on 'Submit Listing'
    visit '/'
    expect(page).to have_content ('Dragon Eggs - Only Two Remaining')
  end
end
