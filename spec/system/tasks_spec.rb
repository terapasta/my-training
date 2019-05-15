require 'rails_helper'
include DateHelper

RSpec.describe 'Tasks', type: :system do
  LABEL_INPUT_XPATH = "//div[@class='tags-input-wrapper-default tags-input']/input[1]"
  let(:user) { create(:user) }
  before { login(user) }

  feature 'new page' do
    before do
      @group = create(:group)
      @group.user_groups.create(user_id: user.id )
      @task = create(:task, group_id: @group.id)
      @task.user_tasks.create(user_id: user.id)
      3.times { create(:label) }
    end
    scenario 'succeed in creating new task' do
      visit new_group_task_path(@group.id)

      fill_in t('activerecord.attributes.task.name'), with: 'nameテスト'
      fill_in t('activerecord.attributes.task.description'), with: 'descriptionテスト'
      fill_in t('activerecord.attributes.task.deadline'), with: Date.today.since(1.week)
      select t('enums.task.status.waiting'), from: t('activerecord.attributes.task.status')
      select t('enums.task.priority.middle'), from: t('activerecord.attributes.task.priority')
      find(:xpath, LABEL_INPUT_XPATH).set('labelテスト')
      find(:xpath, LABEL_INPUT_XPATH).native.send_key(:return)
      select @group.name, from: t('activerecord.models.group')

      click_on t('buttons.create')
      expect(page).to have_content t('messages.flash.success.create', model: t('activerecord.models.task'))
    end

    scenario 'fail creating new task' do
      visit new_group_task_path(@group.id)

      click_on t('buttons.create')

      expect(page).to have_content t('messages.flash.error.create', model: t('activerecord.models.task'))
      expect(page).to have_content t('errors.format', attribute: t('activerecord.attributes.task.name'), message: t('errors.messages.blank'))
      expect(page).to have_content t('errors.format', attribute: t('activerecord.attributes.task.deadline'), message: t('errors.messages.blank'))
    end
  end

  feature 'edit page' do
    before do
      @group = create(:group)
      @group.user_groups.create(user_id: user.id )
      @task = create(:task, group_id: @group.id)
      @task.user_tasks.create(user_id: user.id)
      3.times { create(:label) }
    end
    scenario 'succeed in updating task' do
      visit edit_group_task_path(group_id: @group.id, id: @task.id)

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
      visit edit_group_task_path(group_id: @group.id, id: @task.id)

      fill_in t('activerecord.attributes.task.name'), with: nil
      fill_in t('activerecord.attributes.task.deadline'), with: nil

      click_on t('buttons.update')
      
      expect(page).to have_content t('messages.flash.error.update', model: t('activerecord.models.task'))
      expect(page).to have_content t('errors.format', attribute: t('activerecord.attributes.task.name'), message: t('errors.messages.blank'))
      expect(page).to have_content t('errors.format', attribute: t('activerecord.attributes.task.deadline'), message: t('errors.messages.blank'))
    end
  end

  feature 'index page', js: true do 
    before do
      @group = create(:group)
      @group.user_groups.create(user_id: user.id )
    end
    scenario 'succeed in destroying task' do
      task = create(:task, group_id: @group.id)
      task.user_tasks.create(user_id: user.id)
      3.times { create(:label) }
      visit group_tasks_path(@group.id)
      find(:xpath, "//table[@class='table is-striped is-fullwidth']/tbody[@class='tbody']/tr[1]/td[8]/a[@class='button button-shape'][3]").click
      expect(page.driver.browser.switch_to.alert.text).to eq t('messages.confirmation.destroy')
      expect {
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content t('messages.flash.success.destroy', model: t('activerecord.models.task'))
      }.to change { Task.count }.by(-1)
    end

    scenario 'index page orders by created_at' do
      5.times do |i| 
        task = create(:task, name: "#{i}-name", group_id: @group.id)
        task.user_tasks.create(user_id: user.id)
      end
      visit group_tasks_path(@group.id)
      5.times { |i| expect(all('tbody tr')[i]).to have_content "#{4 - i}-name" }
    end

    scenario 'index page orders by deadline' do
      today = Date.today
      4.times do |i| 
        task = create(:task, deadline: today + i, group_id: @group.id)
        task.user_tasks.create(user_id: user.id)
      end
      visit group_tasks_path(@group.id)
      click_on t('activerecord.attributes.task.deadline')
      4.times { |i| expect(all('tbody tr')[i]).to have_content format_short_date_with_wday(today + (3 - i)) }
      click_on t('activerecord.attributes.task.deadline')
      4.times { |i| expect(all('tbody tr')[i]).to have_content format_short_date_with_wday(today + i) }
    end

    scenario 'index page orders by priority' do
      PRIORITY_ORDERS = ['high', 'middle', 'low']
      3.times do |i| 
        task = create(:task, priority: PRIORITY_ORDERS[i], group_id: @group.id)
        task.user_tasks.create(user_id: user.id)
      end
      visit group_tasks_path(@group.id)
      click_on t('activerecord.attributes.task.priority')
      3.times { |i| expect(all('tbody tr')[i]).to have_content t("enums.task.priority.#{PRIORITY_ORDERS[i]}") }
      click_on t('activerecord.attributes.task.priority')
      3.times { |i| expect(all('tbody tr')[i]).to have_content t("enums.task.priority.#{PRIORITY_ORDERS[2 - i]}") }
    end

    scenario 'show notification' do
      info_task = create(:task, deadline: Date.tomorrow, group_id: @group.id)
      info_task.user_tasks.create(user_id: user.id)
      warning_task = create(:task, deadline: Date.today, group_id: @group.id)
      warning_task.user_tasks.create(user_id: user.id)
      danger_task = create(:task, deadline: Date.yesterday, group_id: @group.id)
      danger_task.user_tasks.create(user_id: user.id)
      visit group_tasks_path(@group.id)
      expect(page).to have_content t('messages.notification.info', task_name: info_task.name, days: get_diff_from_today(info_task.deadline))
      expect(page).to have_content t('messages.notification.warning', task_name: warning_task.name)
      expect(page).to have_content t('messages.notification.danger', task_name: danger_task.name)
      click_on "#{info_task.id}-delete"
      expect(page).not_to have_content t('messages.notification.info', task_name: info_task.name, days: get_diff_from_today(info_task.deadline))
      expect(Task.find(info_task.id).read_datestamp).to eq Date.today
    end
  end
end
