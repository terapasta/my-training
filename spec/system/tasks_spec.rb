require 'rails_helper'
include DateHelper

RSpec.describe 'Tasks', type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task, user_id: user.id) }
  before { 3.times { create(:label) } }
  before { login(user) }

  feature 'new page' do
    scenario 'succeed in creating new task' do
      visit new_task_path

      fill_in t('activerecord.attributes.task.name'), with: 'nameテスト'
      fill_in t('activerecord.attributes.task.description'), with: 'descriptionテスト'
      fill_in t('activerecord.attributes.task.deadline'), with: Date.today.since(1.week)
      select t('enums.task.status.waiting'), from: t('activerecord.attributes.task.status')
      select t('enums.task.priority.middle'), from: t('activerecord.attributes.task.priority')
      check "task_label_ids_#{Label.first.id}"
      check "task_label_ids_#{Label.second.id}"

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
    scenario 'succeed in updating task' do
      visit edit_task_path(task.id)

      name = 'name更新テスト'
      description = 'description更新テスト'
      deadline = Date.today.since(1.week)
      status = t('enums.task.status.working')
      priority = t('enums.task.priority.high')
      label1 = Label.first
      label2 = Label.second

      fill_in t('activerecord.attributes.task.name'), with: name
      fill_in t('activerecord.attributes.task.description'), with: description
      fill_in t('activerecord.attributes.task.deadline'), with: deadline
      select status, from: t('activerecord.attributes.task.status')
      select priority, from: t('activerecord.attributes.task.priority')
      check "task_label_ids_#{label1.id}"
      check "task_label_ids_#{label2.id}"

      click_on t('buttons.update')

      expect(page).to have_content t('messages.flash.success.update', model: t('activerecord.models.task'))
      expect(page).to have_content name
      expect(page).to have_content description
      expect(page).to have_content format_date_with_wday(deadline)
      expect(page).to have_content status
      expect(page).to have_content priority
      expect(page).to have_content label1.name
      expect(page).to have_content label2.name
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
      click_on t('links.tasks.destroy')
      expect(page.driver.browser.switch_to.alert.text).to eq t('messages.confirmation.destroy')
      expect {
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content t('messages.flash.success.destroy', model: t('activerecord.models.task'))
      }.to change { Task.count }.by(-1)
    end

    scenario 'index page orders by created_at' do
      5.times { |i| create(:task, name: "#{i}-name") }
      visit tasks_path
      5.times { |i| expect(all('tbody tr')[i]).to have_content "#{4 - i}-name" }
    end

    scenario 'index page orders by deadline' do
      today = Date.today
      4.times { |i| create(:task, deadline: today + i)}
      visit tasks_path
      click_on t('activerecord.attributes.task.deadline')
      4.times { |i| expect(all('tbody tr')[i]).to have_content format_short_date_with_wday(today + (3 - i)) }
      click_on t('activerecord.attributes.task.deadline')
      4.times { |i| expect(all('tbody tr')[i]).to have_content format_short_date_with_wday(today + i) }
    end

    scenario 'index page orders by priority' do
      PRIORITY_ORDERS = ['high', 'middle', 'low']
      3.times { |i| create(:task, priority: PRIORITY_ORDERS[i])}
      visit tasks_path
      click_on t('activerecord.attributes.task.priority')
      3.times { |i| expect(all('tbody tr')[i]).to have_content t("enums.task.priority.#{PRIORITY_ORDERS[i]}") }
      click_on t('activerecord.attributes.task.priority')
      3.times { |i| expect(all('tbody tr')[i]).to have_content t("enums.task.priority.#{PRIORITY_ORDERS[2 - i]}") }
    end
  end
end
