require 'rails_helper'

RSpec.describe TaskSearchForm, type: :model do

  describe 'search' do
    before do
      create(:task, name: 'task-1')
      create(:task, name: 'task-2')
      create(:task, name: 'task-22')
    end
    context 'perfect match with name' do
      it 'gets one' do
        expect(TaskSearchForm.new({name: 'task-1'}).search.size).to eq 1
      end
    end
    context 'forward match with name' do
      it 'gets three' do
        expect(TaskSearchForm.new({name: 'ta'}).search.size).to eq 3
      end
    end
    context 'backword match with name' do
      it 'gets two' do
        expect(TaskSearchForm.new({name: '2'}).search.size).to eq 2
      end
    end
    context 'middle match with name' do
      it 'gets three' do
        expect(TaskSearchForm.new({name: 'sk-'}).search.size).to eq 3
      end
    end
  end
end
