class UserGroup < ApplicationRecord
  belongs_to :user
  belongs_to :group

  def self.create_user_groups(group, new_user_ids)
    new_user_ids.each do |user_id| 
      group.user_groups.find_or_create_by(user_id: user_id)
    end
  end

  def self.delete_user_groups(group, new_user_ids)
    delete_user_ids = group.user_groups.map(&:user_id) - new_user_ids
    group.user_groups.where(user_id: delete_user_ids).destroy_all
  end

  def self.update_user_groups(group, new_user_ids)
    self.create_user_groups(group, new_user_ids)
    self.delete_user_groups(group, new_user_ids)
  end
end
