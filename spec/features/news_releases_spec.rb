require 'rails_helper'

feature 'News releases' do
  context "as a user" do
    scenario "adds a new release" do
      user = create(:user)
      sign_in(user)
      visit(root_path)
      click_link("News")

      expect(page).not_to have_content("BigCo switches to Rails")
      click_link("Add News Release")

      fill_in("Date", with: "2013-07-29")
      fill_in("Title", with: "BigCo switches to Rails")
      fill_in(
        "Body",
        with: "BigCo has released a new website built with open source."
      )
      click_button("Create News release")

      expect(current_path).to eq(news_releases_path)
      expect(page).to have_content("Successfully created news release")
      expect(page).to have_content("2013-07-29: BigCo switches to Rails")
    end
  end

  context "as a guest" do
    scenario "reads a news release" do
      create(:news_release)
      visit(root_path)
      click_link("News")

      expect(current_path).to eq(news_releases_path)
      expect(page).to have_content("2013-07-29: Fake News Release")
    end
  end
end
