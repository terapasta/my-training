require 'rails_helper'

RSpec.describe TaskSearchForm, type: :model do

  describe 'search' do
    before do
      create(:task, name: 'task-1', status: 'waiting', priority: 'high')
      create(:task, name: 'task-2', status: 'working', priority: 'middle')
      create(:task, name: 'task-22', status: 'completed', priority: 'low')
    end
    describe 'with name' do
      context 'perfect match' do
        it 'gets one' do
          expect(TaskSearchForm.new({name: 'task-1'}).search.size).to eq 1
        end
      end
      context 'forward match' do
        it 'gets three' do
          expect(TaskSearchForm.new({name: 'ta'}).search.size).to eq 3
        end
      end
      context 'backword match' do
        it 'gets two' do
          expect(TaskSearchForm.new({name: '2'}).search.size).to eq 2
        end
      end
      context 'middle match' do
        it 'gets three' do
          expect(TaskSearchForm.new({name: 'sk-'}).search.size).to eq 3
        end
      end
    end
    describe 'with status' do
      it 'gets one' do
        expect(TaskSearchForm.new({status: 'waiting'}).search.size).to eq 1
      end
    end
    describe 'with priority' do
      it 'gets one' do
        expect(TaskSearchForm.new({priority: 'high'}).search.size).to eq 1
      end
    end
    describe 'with name, status and priority' do
      it 'gets one' do
        expect(TaskSearchForm.new({name: 'task', status: 'waiting', priority: 'high'}).search.size).to eq 1
      end
      it 'gets zero' do
        expect(TaskSearchForm.new({name: 'task', status: 'waiting', priority: 'middle'}).search.size).to eq 0
      end
    end
  end
end
