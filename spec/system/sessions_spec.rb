require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  let(:user) { create(:user) }

  feature 'new page' do
    scenario 'succeed in createing new session' do
      login(user)
      expect(page).to have_content t('messages.flash.success.login')
    end
    scenario 'fail creating new session' do
      good_email = user.email
      user.email = 'bad.email@sample.com'
      login(user)
      expect(page).to have_content t('messages.flash.error.login')
      user.email = good_email
      user.password = 'badpassword01'
      expect(page).to have_content t('messages.flash.error.login')
    end
  end
  feature 'logout' do
    scenario 'succeed in destroying session' do
      login(user)
      click_on t('links.sessions.destroy')
      expect(page.driver.browser.switch_to.alert.text).to eq t('messages.confirmation.logout')
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content t('messages.flash.success.logout')
    end
  end
end
