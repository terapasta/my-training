require 'rails_helper'
include DateHelper

RSpec.describe 'Tasks', type: :system do
  LABEL_INPUT_XPATH = "//div[@class='tags-input-wrapper-default tags-input']/input[1]"
  let(:user) { create(:user) }
  let(:task) { create(:task, user_id: user.id) }
  before { login(user) }

  feature 'new page' do
    before { 3.times { create(:label) } }
    scenario 'succeed in creating new task' do
      visit new_task_path

      fill_in t('activerecord.attributes.task.name'), with: 'nameテスト'
      fill_in t('activerecord.attributes.task.description'), with: 'descriptionテスト'
      fill_in t('activerecord.attributes.task.deadline'), with: Date.today.since(1.week)
      select t('enums.task.status.waiting'), from: t('activerecord.attributes.task.status')
      select t('enums.task.priority.middle'), from: t('activerecord.attributes.task.priority')
      find(:xpath, LABEL_INPUT_XPATH).set('labelテスト')
      find(:xpath, LABEL_INPUT_XPATH).native.send_key(:return)

      click_on t('buttons.create')
      expect(page).to have_content t('messages.flash.success.create', model: t('activerecord.models.task'))
    end

    scenario 'fail creating new task' do
      visit new_task_path

      click_on t('buttons.create')

      expect(page).to have_content t('messages.flash.error.create', model: t('activerecord.models.task'))
      expect(page).to have_content t('errors.format', attribute: t('activerecord.attributes.task.name'), message: t('errors.messages.blank'))
      expect(page).to have_content t('errors.format', attribute: t('activerecord.attributes.task.deadline'), message: t('errors.messages.blank'))
    end
  end

  feature 'edit page' do
    before { 3.times { create(:label) } }
    scenario 'succeed in updating task' do
      visit edit_task_path(task.id)

      name = 'name更新テスト'
      description = 'description更新テスト'
      deadline = Date.today.since(1.week)
      status = t('enums.task.status.working')
      priority = t('enums.task.priority.high')
      label1 = Label.first

      fill_in t('activerecord.attributes.task.name'), with: name
      fill_in t('activerecord.attributes.task.description'), with: description
      fill_in t('activerecord.attributes.task.deadline'), with: deadline
      select status, from: t('activerecord.attributes.task.status')
      select priority, from: t('activerecord.attributes.task.priority')
      find(:xpath, LABEL_INPUT_XPATH).set(label1.name)
      find(:xpath, LABEL_INPUT_XPATH).native.send_key(:return)

      click_on t('buttons.update')

      expect(page).to have_content t('messages.flash.success.update', model: t('activerecord.models.task'))
      expect(page).to have_content name
      expect(page).to have_content description
      expect(page).to have_content format_date_with_wday(deadline)
      expect(page).to have_content status
      expect(page).to have_content priority
      expect(page).to have_content label1.name
    end

    scenario 'fail updating task' do
      visit edit_task_path(task.id)

      fill_in t('activerecord.attributes.task.name'), with: nil
      fill_in t('activerecord.attributes.task.deadline'), with: nil

      click_on t('buttons.update')
      
      expect(page).to have_content t('messages.flash.error.update', model: t('activerecord.models.task'))
      expect(page).to have_content t('errors.format', attribute: t('activerecord.attributes.task.name'), message: t('errors.messages.blank'))
      expect(page).to have_content t('errors.format', attribute: t('activerecord.attributes.task.deadline'), message: t('errors.messages.blank'))
    end
  end

  feature 'index page', js: true do 
    scenario 'succeed in destroying task' do
      task
      visit tasks_path
      find(:xpath, "//table[@class='table is-striped is-fullwidth']/tbody[@class='tbody']/tr[1]/td[7]/a[@class='button button-shape'][3]").click
      expect(page.driver.browser.switch_to.alert.text).to eq t('messages.confirmation.destroy')
      expect {
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content t('messages.flash.success.destroy', model: t('activerecord.models.task'))
      }.to change { Task.count }.by(-1)
    end

    scenario 'index page orders by created_at' do
      5.times { |i| create(:task, name: "#{i}-name", user_id: user.id) }
      visit tasks_path
      5.times { |i| expect(all('tbody tr')[i]).to have_content "#{4 - i}-name" }
    end

    scenario 'index page orders by deadline' do
      today = Date.today
      4.times { |i| create(:task, deadline: today + i, user_id: user.id)}
      visit tasks_path
      click_on t('activerecord.attributes.task.deadline')
      4.times { |i| expect(all('tbody tr')[i]).to have_content format_short_date_with_wday(today + (3 - i)) }
      click_on t('activerecord.attributes.task.deadline')
      4.times { |i| expect(all('tbody tr')[i]).to have_content format_short_date_with_wday(today + i) }
    end

    scenario 'index page orders by priority' do
      PRIORITY_ORDERS = ['high', 'middle', 'low']
      3.times { |i| create(:task, priority: PRIORITY_ORDERS[i], user_id: user.id)}
      visit tasks_path
      click_on t('activerecord.attributes.task.priority')
      3.times { |i| expect(all('tbody tr')[i]).to have_content t("enums.task.priority.#{PRIORITY_ORDERS[i]}") }
      click_on t('activerecord.attributes.task.priority')
      3.times { |i| expect(all('tbody tr')[i]).to have_content t("enums.task.priority.#{PRIORITY_ORDERS[2 - i]}") }
    end
  end
end
