require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'validations' do
    it 'is invalid without name' do
      user = build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include t('errors.messages.blank')
    end
    it 'is invalid without email' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include t('errors.messages.blank')
    end
    it 'is invalid with email including wrong symbol' do
      user = build(:user, email: 'email()@sample.com')
      user.valid?
      expect(user.errors[:email]).to include t('errors.user.email')
    end
    it 'is invalid with email excluding @' do
      user = build(:user, email: 'emailsample.com')
      user.valid?
      expect(user.errors[:email]).to include t('errors.user.email')
    end
    it 'is invalid with duplicated email' do
      create(:user, email: 'email@sample.com')
      user = build(:user, email: 'email@sample.com')
      user.valid?
      expect(user.errors[:email]).to include t('errors.messages.taken')
    end
    it 'is invalid without password' do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to include t('errors.messages.blank')
    end
    it 'is invalid with shorter than 8 charactors' do
      user = build(:user, password: 'pass11')
      user.valid?
      expect(user.errors[:password]).to include t('errors.user.password')
    end
    it 'is invalid without number' do
      user = build(:user, password: 'hogepassword')
      user.valid?
      expect(user.errors[:password]).to include t('errors.user.password')
    end
    it 'is invalid without charactor' do
      user = build(:user, password: '12345678')
      user.valid?
      expect(user.errors[:password]).to include t('errors.user.password')
    end
  end
end
