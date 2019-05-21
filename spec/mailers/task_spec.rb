require "rails_helper"

RSpec.describe TaskMailer, type: :mailer do
  describe "task_mailer" do
    let(:debtee) { create(:user) }
    let(:debtor) { create(:user) }
    let(:task) { create(:task, deadline: Date.today) }
    before do 
      debtee.user_tasks.create(task_id: task.id, task_role: 'debtee')
      debtor.user_tasks.create(task_id: task.id, task_role: 'debtor')
    end
    let(:email) { TaskMailer.remind_task(debtor, task) }
    it 'sends an email' do
      expect {
        email.deliver_now
      }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it 'renders the subject' do
      expect(email.subject).to eq "【#{task.name}】を確認してください！！"
    end

    it "renders the receiver email" do
      expect(email.to).to eq [debtor.email]
    end

    it "renders the sender email" do
      expect(email.from).to eq ["toritate@example.com"]
    end
  end
end
