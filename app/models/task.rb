class Task < ApplicationRecord
  enum status: { waiting: 0, working: 1, completed: 2 }
  enum priority: { high: 1, middle: 2, low: 3, unselected: 10 }
end
