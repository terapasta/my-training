require 'rails_helper'

RSpec.describe TaskSearchForm, type: :model do

  describe 'search' do
    let(:user) { create(:user) }
    let(:group) { create(:group) }
    let(:params) { { user_id: user.id } }
    before do
      create(:user_group, user_id: user.id, group_id: group.id)
      task_1 = create(:task, name: 'task-1', status: 'waiting', priority: 'high', group_id: group.id)
      task_1.user_tasks.create(user_id: user.id)
      task_2 = create(:task, name: 'task-2', status: 'working', priority: 'middle', group_id: group.id)
      task_2.user_tasks.create(user_id: user.id)
      task_3 = create(:task, name: 'task-22', status: 'completed', priority: 'low', group_id: group.id)
      task_3.user_tasks.create(user_id: user.id)
    end
    describe 'with name' do
      context 'perfect match' do
        it 'gets one' do
          params[:name] = 'task-1'
          expect(TaskSearchForm.new(params).search.size).to eq 1
        end
      end
      context 'forward match' do
        it 'gets three' do
          params[:name] = 'ta'
          expect(TaskSearchForm.new(params).search.size).to eq 3
        end
      end
      context 'backword match' do
        it 'gets two' do
          params[:name] = '2'
          expect(TaskSearchForm.new(params).search.size).to eq 2
        end
      end
      context 'middle match' do
        it 'gets three' do
          params[:name] = 'sk-'
          expect(TaskSearchForm.new(params).search.size).to eq 3
        end
      end
    end
    describe 'with status' do
      it 'gets one' do
        params[:status] = 'waiting'
        expect(TaskSearchForm.new(params).search.size).to eq 1
      end
    end
    describe 'with priority' do
      it 'gets one' do
        params[:priority] = 'high'
        expect(TaskSearchForm.new(params).search.size).to eq 1
      end
    end
    describe 'with name, status and priority' do
      it 'gets one' do
        params = { user_id: user.id, name: 'task', status: 'waiting', priority: 'high' }
        expect(TaskSearchForm.new(params).search.size).to eq 1
      end
      it 'gets zero' do
        params = { user_id: user.id, name: 'task', status: 'waiting', priority: 'middle' }
        expect(TaskSearchForm.new(params).search.size).to eq 0
      end
    end
  end
end
