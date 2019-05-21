class UserGroup < ApplicationRecord
  belongs_to :user
  belongs_to :group

  def self.create_user_groups(group, new_user_ids)
    new_user_ids.each do |user_id| 
      group.user_groups.find_or_create_by(user_id: user_id)
    end
  end

  def self.delete_user_groups(group, new_user_ids)
    group.user_groups.each { |user_group| user_group.destroy unless new_user_ids.include?(user_group.user_id) }
  end

  def self.update_user_groups(group, new_user_ids)
    self.create_user_groups(group, new_user_ids)
    self.delete_user_groups(group, new_user_ids)
  end
end
