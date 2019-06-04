export default{
  task: {
    statuses: {
      waiting: '未着手',
      working: '着手',
      completed: '完了',
    },
    priorities: {
      low: '低',
      middle: '中',
      high: '高',
    }
  },
  userTask: {
    roles: {
      debtee: '貸し',
      debtor: '借り',
    }
  },
  translateStatus(status) {
    return this.task.statuses[status]
  },
  translatePriority(priority) {
    return this.task.priorities[priority]
  },
  translateRole(role) {
    return this.userTask.roles[role]
  }
}
