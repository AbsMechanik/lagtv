require 'acceptance/acceptance_helper'

feature 'Public proile pages' do
  context "for not logged in visitors" do
    background do
      @user = Fabricate(:member, :name => 'Bouse')
    end

    scenario 'cannot view public profile pages' do
      visit user_path(@user)
      page.should have_content("You do not have permission to access that page")
    end
  end

  context "for logged in members" do
    background do
      @user = Fabricate(:member, :name => 'Bouse')
      login_as(@user)
    end

    scenario 'current user can easily view their public profile page' do
      click_link('My Public Profile')
      page.should have_css("h1.public_profile", :text => "Bouse")
    end

    context 'show service icons in the correct visual state' do
      scenario 'when services have a url' do
        @user.facebook = ""
        @user.twitter = ""
        @user.twitch = ""
        @user.you_tube = ""
        @user.save!
        click_link('My Public Profile')
        
        page.should have_css(".facebook.icon.disabled", :count => 1) 
        page.should have_css(".twitter.icon.disabled", :count => 1) 
        page.should have_css(".twitch.icon.disabled", :count => 1) 
        page.should have_css(".you_tube.icon.disabled", :count => 1) 
      end

      scenario 'when services do not have a value' do
        @user.facebook = "a"
        @user.twitter = "b"
        @user.twitch = "c"
        @user.you_tube = "d"
        @user.save!
        click_link('My Public Profile')

        page.should have_css(".facebook.icon.active", :count => 1) 
        page.should have_css(".twitter.icon.active", :count => 1) 
        page.should have_css(".twitch.icon.active", :count => 1) 
        page.should have_css(".you_tube.icon.active", :count => 1) 
      end
    end
  end
end