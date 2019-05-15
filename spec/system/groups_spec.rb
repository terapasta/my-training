require 'rails_helper'

RSpec.describe 'Groups', type: :system do
  MEMBER_INPUT_XPATH = "//div[@class='tags-input-wrapper-default tags-input']/input[1]"
  let(:user) { create(:user) }
  before { login(user) }

  feature 'new page' do
    let(:member) { create(:user) }
    scenario 'succeed in createing new group' do
      visit new_group_path

      fill_in t('activerecord.attributes.group.name'), with: 'nameテスト'
      find(:xpath, MEMBER_INPUT_XPATH).set(member.email)
      find(:xpath, MEMBER_INPUT_XPATH).native.send_key(:return)

      click_on t('buttons.create')
      expect(page).to have_content t('messages.flash.success.create', model: t('activerecord.models.group'))
      expect(Group.last.users.size).to eq 2
    end
  end

  feature 'edit page' do
    let(:member) { create(:user) }
    before do 
      @group = create(:group)
      UserGroup.create(group_id: @group.id, user_id: user.id)
    end
    scenario 'succeed in updating group' do
      visit edit_group_path(@group.id)

      name = 'name更新テスト'

      fill_in t('activerecord.attributes.group.name'), with: name
      find(:xpath, MEMBER_INPUT_XPATH).set(member.email)
      find(:xpath, MEMBER_INPUT_XPATH).native.send_key(:return)

      click_on t('buttons.update')
      expect(page).to have_content t('messages.flash.success.update', model: t('activerecord.models.group'))
      expect(page).to have_content name
      expect(page).to have_content member.email
    end
  end
end
