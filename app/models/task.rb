# coding: utf-8

class Task < ActiveRecord::Base
  belongs_to :charge_user, class_name: "User", foreign_key: "charge_user_id"
  belongs_to :author, class_name: "User", foreign_key: "author_id"
  has_many :task_logs
  
  attr_accessible :author_id, :charge_user_id, :content, :flow, :locked, :state, :title
  
  scope :available, ->{ where(locked: 0)}
  scope :charge_of, ->(user){ where(charge_user_id: user.id)}
  scope :creating, ->(user){ where(state: STATUS_CREATING, author_id: user.id)}
  scope :related_to, ->(user){
      tasks = Task.arel_table
      task_logs = TaskLog.arel_table
      where(
        TaskLog.by(user).where(
          task_logs[:task_id].eq(tasks[:id])).exists)
      }
  

  STATUS_CREATING = 0 # 作成中
  STATUS_PROCESSING = 1 # 処理中
  STATUS_SENDING_BACK = 2 # 差戻し中
  STATUS_DELETED = 8 # 削除済み
  STATUS_COMPLETED = 9 # 完了

  BUTTON_CONSERVE = "保存"
  BUTTON_APPLY = "申請"
  BUTTON_DELETE = "削除"
  BUTTON_APPROVE = "承認"
  BUTTON_COMPLETE = "完了"
  BUTTON_RETURN = "差戻し"
  
  class << self
    def STATUS_TEXT_OF( status )
      { STATUS_CREATING => "作成中",
        STATUS_PROCESSING => "処理中",
        STATUS_SENDING_BACK => "差戻し中",
        STATUS_DELETED => "削除済み",
        STATUS_COMPLETED => "完了"
      }[status]
    end
  end

  # create時のメソッド群
  def create_conserve!
    ActiveRecord::Base.transaction do
    self.charge_user = self.author
    self.state = Task::STATUS_CREATING
    self.save!
    end
  end

  def create_apply!
    self.state = Task::STATUS_PROCESSING
    self.save!
    @task_log = TaskLog.new( user_id: self.author.id,
                          task_id: self.id,
                          action: TaskLog::ACTION_APPLY )
    @task_log.save!
  end


  # update時のメソッド群
  def conserve!(current_user, params)
    self.update_attributes!(params[:task])
    self.charge_user = @current_user
    self.save!
  end

  def apply!(current_user, params)
    self.update_attributes!(params[:task])
    self.state = Task::STATUS_PROCESSING
    self.save!
    @task_log = TaskLog.new( user_id: current_user.id,
                          task_id: self.id,
                          action: TaskLog::ACTION_APPLY )
    @task_log.save!
  end

  def approve!(current_user, params)
    self.update_attributes!(params[:task])
    self.state = Task::STATUS_PROCESSING
    self.save!
    @task_log = TaskLog.new( user_id: current_user.id,
                          task_id: self.id,
                          action: TaskLog::ACTION_APPROVAL )
    @task_log.save!
  end

  def complete!(current_user, params)
    self.update_attributes!(params[:task])
    self.state = Task::STATUS_COMPLETED
    self.locked = 1;
    self.save!
    @task_log = TaskLog.new( user_id: current_user.id,
                          task_id: self.id,
                          action: TaskLog::ACTION_COMPLETE )
    @task_log.save!
  end

  def return!(current_user, params)
    self.update_attributes!(params[:task])
    self.state = Task::STATUS_SENDING_BACK
    self.save!
    @task_log = TaskLog.new( user_id: current_user.id,
                          task_id: self.id,
                          action: TaskLog::ACTION_RETURN )
    @task_log.save!
  end

  def delete!(current_user, params)
    self.update_attributes!(params[:task])
    self.state = Task::STATUS_DELETED
    self.locked = 1;
    self.save!
    @task_log = TaskLog.new( user_id: current_user.id,
                          task_id: self.id,
                          action: TaskLog::ACTION_DELETE )
    @task_log.save!
  end

end
