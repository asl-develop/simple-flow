# coding: utf-8

class TaskLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :task
  attr_accessible :action, :user_id, :task_id

  scope :by, ->(user){ where( user_id: user.id) }
  scope :history_of, ->(task){ where( task_id: task.id) }


  ACTION_APPLY = 1 # 申請
  ACTION_APPROVAL = 2 # 承認
  ACTION_RETURN = 3 # 差戻し
  ACTION_DELETE = 8 # 削除
  ACTION_COMPLETE = 9 # 完了

  class << self
    def ACTION_TEXT_OF( action )
      { ACTION_APPLY => "申請",
        ACTION_APPROVAL => "承認",
        ACTION_RETURN => "差戻し",
        ACTION_DELETE => "削除",
        ACTION_COMPLETE => "完了"
      }[action]
    end
  end


end
