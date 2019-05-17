require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }
  let(:member) { create(:user) }
  before do 
    group = create(:group)
    user.user_groups.create(group_id: group.id)
    member.user_groups.create(group_id: group.id)
    task = create(:task)
    user.user_tasks.create(task_id: task.id, task_role: 'debtee')
    member.user_tasks.create(task_id: task.id, task_role: 'debtor')
    login(user)
  end

  feature 'show page' do
    scenario 'show correct items' do
      visit users_mypage_path

      expect(page).to have_content user.name
      expect(page).to have_content user.email
      expect(page).to have_content "1個"
      expect(page).to have_content "0個"
    end
  end

  feature 'edit page' do
    scenario 'edit succeed in updating task' do
      visit users_edit_path(user.id)

      name = 'name更新テスト'
      email = 'email更新テスト'

      fill_in t('activerecord.attributes.user.name'), with: name
      fill_in t('activerecord.attributes.user.email'), with: email

      click_on t('buttons.update')

      expect(page).to have_content name
      expect(page).to have_content email
    end
  end
end
