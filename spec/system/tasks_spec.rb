require 'rails_helper'
include DateHelper

RSpec.describe 'Tasks', type: :system do
  let(:task) { create(:task) }

  feature 'new page' do
    scenario 'succeed in creating new task' do
      visit new_task_path

      fill_in t('activerecord.attributes.task.name'), with: 'nameテスト'
      fill_in t('activerecord.attributes.task.description'), with: 'descriptionテスト'
      fill_in t('activerecord.attributes.task.deadline'), with: Date.today.since(1.week)
      select t('enums.task.status.waiting'), from: t('activerecord.attributes.task.status')
      select t('enums.task.priority.middle'), from: t('activerecord.attributes.task.priority')

      click_on t('buttons.create')
      # TODO: ログイン機能を追加後に復活させる
      # expect(page).to have_content t('messages.flash.success.create')
    end

    scenario 'fail creating new task' do
      visit new_task_path

      click_on t('buttons.create')

      expect(page).to have_content t('messages.flash.error.create')
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

      fill_in t('activerecord.attributes.task.name'), with: name
      fill_in t('activerecord.attributes.task.description'), with: description
      fill_in t('activerecord.attributes.task.deadline'), with: deadline
      select status, from: t('activerecord.attributes.task.status')
      select priority, from: t('activerecord.attributes.task.priority')

      click_on t('buttons.update')

      expect(page).to have_content t('messages.flash.success.update')
      expect(page).to have_content name
      expect(page).to have_content description
      expect(page).to have_content format_date_with_wday(deadline)
      expect(page).to have_content status
      expect(page).to have_content priority
    end

    scenario 'fail updating task' do
      visit edit_task_path(task.id)

      fill_in t('activerecord.attributes.task.name'), with: nil
      fill_in t('activerecord.attributes.task.deadline'), with: nil

      click_on t('buttons.update')
      
      expect(page).to have_content t('messages.flash.error.update')
      expect(page).to have_content t('errors.format', attribute: t('activerecord.attributes.task.name'), message: t('errors.messages.blank'))
      expect(page).to have_content t('errors.format', attribute: t('activerecord.attributes.task.deadline'), message: t('errors.messages.blank'))
    end
  end

  feature 'index page' do 
    scenario 'succeed in destroy task' do
      task
      visit tasks_path
      click_on t('links.tasks.destroy')
      expect(page.driver.browser.switch_to.alert.text).to eq t('messages.confirmation.destroy')
      expect {
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content t('messages.flash.success.destroy')
      }.to change { Task.count }.by(-1)
    end

    scenario 'show list order by created_at' do
      5.times { |i| create(:task, name: "#{i}-name") }
      visit tasks_path
      5.times { |i| expect(all('tbody tr')[i]).to have_content "#{4 - i}-name" }
    end
  end
end
