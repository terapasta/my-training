class Label < ApplicationRecord
  has_many :task_labels, dependent: :destroy
  validates :name, presence: true
end
