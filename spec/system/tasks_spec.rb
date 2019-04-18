require 'rails_helper'
include DateHelper

RSpec.describe 'Tasks', type: :system do
  
  scenario 'create new task' do
    visit new_task_path
    fill_in I18n.t('activerecord.attributes.task.name'), with: 'nameテスト'
    fill_in I18n.t('activerecord.attributes.task.description'), with: 'descriptionテスト'
    fill_in I18n.t('activerecord.attributes.task.deadline'), with: Date.today.since(1.week)
    select I18n.t('enums.task.status.waiting'), from: I18n.t('activerecord.attributes.task.status')
    select I18n.t('enums.task.priority.middle'), from: I18n.t('activerecord.attributes.task.priority')
    click_on I18n.t('components.buttons.create')
    expect(page).to have_content 'タスクを作成しました！'
  end

  scenario 'edit task' do
    visit edit_task_path(task.id)
    name = 'name更新テスト'
    description = 'description更新テスト'
    deadline = Date.today.since(1.week)
    status = I18n.t('enums.task.status.working')
    priority = I18n.t('enums.task.priority.high')
    fill_in I18n.t('activerecord.attributes.task.name'), with: name
    fill_in I18n.t('activerecord.attributes.task.description'), with: description
    fill_in I18n.t('activerecord.attributes.task.deadline'), with: deadline
    select status, from: I18n.t('activerecord.attributes.task.status')
    select priority, from: I18n.t('activerecord.attributes.task.priority')
    click_on I18n.t('components.buttons.create')
    expect(page).to have_content 'タスクを更新しました！'
    expect(page).to have_content name
    expect(page).to have_content description
    expect(page).to have_content format_date_with_wday(deadline)
    expect(page).to have_content status
    expect(page).to have_content priority
  end

  scenario 'destroy task' do
    FactoryBot.create(:task)
    visit tasks_path
    click_on '削除'
    expect(page.driver.browser.switch_to.alert.text).to eq I18n.t('components.messages.confirmation.destroy')
    expect {
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content 'タスクを削除しました！'
    }.to change { Task.count }.by(-1)
  end

  scenario 'show list order by created_at' do
    5.times { |i| FactoryBot.create(:task, name: "#{i}-name") }
    visit tasks_path
    5.times { |i| expect(all('tbody tr')[i]).to have_content "#{4 - i}-name" }
  end
end
