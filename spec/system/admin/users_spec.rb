require 'rails_helper'
include DateHelper

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user, :admin) }
  before { login(user) }

  feature 'new page' do
    scenario 'succeed in creating new user' do
      visit new_admin_user_path

      fill_in t('activerecord.attributes.user.name'), with: 'nameテスト'
      fill_in t('activerecord.attributes.user.email'), with: 'email@g.com'
      fill_in t('activerecord.attributes.user.password'), with: 'password01'

      click_on t('buttons.create')
      expect(page).to have_content t('messages.flash.success.create', model: t('activerecord.models.user'))
    end

    scenario 'fail creating new user' do
      visit new_admin_user_path

      click_on t('buttons.create')

      expect(page).to have_content t('messages.flash.error.create', model: t('activerecord.models.user'))
      expect(page).to have_content t('errors.format', attribute: t('activerecord.attributes.user.name'), message: t('errors.messages.blank'))
      expect(page).to have_content t('errors.format', attribute: t('activerecord.attributes.user.email'), message: t('errors.messages.blank'))
      expect(page).to have_content t('errors.format', attribute: t('activerecord.attributes.user.password'), message: t('errors.messages.blank'))

      fill_in t('activerecord.attributes.user.password'), with: 'password'
      click_on t('buttons.create')
      
      expect(page).to have_content t('errors.format', attribute: t('activerecord.attributes.user.password'), message: t('errors.user.password'))
    end
  end

  feature 'edit page' do
    scenario 'succeed in updating user' do
      visit edit_admin_user_path(user.id)

      name = 'name更新テスト'
      email = 'email@sample.com'
      role = t('enums.user.role.admin')

      fill_in t('activerecord.attributes.user.name'), with: name
      fill_in t('activerecord.attributes.user.email'), with: email
      select role, from: t('activerecord.attributes.user.role')

      click_on t('buttons.update')

      expect(page).to have_content t('messages.flash.success.update', model: t('activerecord.models.user'))
      expect(page).to have_content name
      expect(page).to have_content email
      expect(page).to have_content role
    end

    scenario 'fail updating user' do
      visit edit_admin_user_path(user.id)

      fill_in t('activerecord.attributes.user.name'), with: nil
      fill_in t('activerecord.attributes.user.email'), with: nil

      click_on t('buttons.update')
      
      expect(page).to have_content t('messages.flash.error.update', model: t('activerecord.models.user'))
      expect(page).to have_content t('errors.format', attribute: t('activerecord.attributes.user.name'), message: t('errors.messages.blank'))
      expect(page).to have_content t('errors.format', attribute: t('activerecord.attributes.user.email'), message: t('errors.messages.blank'))
    end
  end

  feature 'index page' do
    scenario 'show correct columns' do
      visit admin_users_path

      expect(page).to have_content t('activerecord.attributes.user.id')
      expect(page).to have_content t('activerecord.attributes.user.name')
      expect(page).to have_content t('activerecord.attributes.user.email')
      expect(page).to have_content t('activerecord.attributes.user.tasks')
      expect(page).to have_content t('activerecord.attributes.user.role')
      expect(page).to have_content t('activerecord.attributes.user.created_at')
    end
    
    scenario 'succeed in destroying user' do
      create(:user)
      visit admin_users_path
      click_on t('links.users.destroy'), match: :first
      expect(page.driver.browser.switch_to.alert.text).to eq t('messages.confirmation.destroy')
      expect {
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content t('messages.flash.success.destroy', model: t('activerecord.models.user'))
      }.to change { User.count }.by(-1)
    end

    scenario 'succeed in destroying user with user_tasks' do
      user_sample = create(:user)
      create(:user_task, user_id: user_sample.id)
      visit admin_users_path
      click_on t('links.users.destroy'), match: :first
      expect(page.driver.browser.switch_to.alert.text).to eq t('messages.confirmation.destroy')
      expect {
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content t('messages.flash.success.destroy', model: t('activerecord.models.user'))
      }.to change { UserTask.count }.by(-1)
    end

    scenario 'fail destroying user if user is last admin' do
      visit admin_users_path
      click_on t('links.users.destroy'), match: :first
      expect(page.driver.browser.switch_to.alert.text).to eq t('messages.confirmation.destroy')
      expect {
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content t('messages.flash.error.destroy', model: t('activerecord.models.user'))
      }.not_to change { User.count }
    end
  end
end
