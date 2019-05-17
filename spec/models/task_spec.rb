require 'rails_helper'

RSpec.describe Task, type: :model do

  describe 'valitions' do
    it 'is invalid without name' do
      task = build(:task, name: nil)
      task.valid?
      expect(task.errors[:name]).to include t('errors.messages.blank')
    end

    it 'is invalid without deadline' do
      task = build(:task, deadline: nil)
      task.valid?
      expect(task.errors[:deadline]).to include t('errors.messages.blank')
    end

    # it 'is invalid without status' do
    #   task = build(:task, status: nil)
    #   task.valid?
    #   expect(task.errors[:status]).to include t('errors.messages.blank')
    # end

    # it 'is invalid without priority' do
    #   task = build(:task, priority: nil)
    #   task.valid?
    #   expect(task.errors[:priority]).to include t('errors.messages.blank')
    # end
  end
end
