# coding: utf-8

class TasksController < ApplicationController
  
  def index
    puts params
    case params[:scope]
    when "relation"
      @tasks = Task.includes(:author).related_to(@current_user)
    when "creating"
      @tasks = Task.includes(:author).creating(@current_user).available
    when "applying"
      @tasks = Task.includes(:author).created_by(@current_user).outside_charge(@current_user).available
    else
      @tasks = Task.includes(:author).charge_of(@current_user).available
    end
  end

  def show
    @task = Task.includes(:author).find(params[:id])
    @task_logs = TaskLog.includes(:user).history_of(@task)
  end

  def new
    @task = Task.new
    @users = User.exclude(@current_user)
  end
  
  def edit
    @task = Task.includes(:author).find(params[:id])
    @users = User.exclude(@current_user)
  end

  def create
    @task = Task.new(params[:task])
    @task.author = @current_user
    event = params[:commit]

    
    ActiveRecord::Base.transaction do
      case event
      # 保存
      when Task::BUTTON_CONSERVE
        @task.create_conserve!

      # 申請
      when Task::BUTTON_APPLY
        @task.create_apply!
  
      else
        # ?
      end
    end

    redirect_to tasks_path, notice: 'Task was successfully created.'

    rescue => e
      puts e
      puts e.backtrace
      redirect_to tasks_path, notice: 'Creation of the task went wrong.'
  end
  
  
  def update
    @task = Task.find(params[:id])
    event = params[:commit]

    ActiveRecord::Base.transaction do
      case event
      # 保存
      when Task::BUTTON_CONSERVE
        @task.conserve!(@current_user, params)
        
      # 申請
      when Task::BUTTON_APPLY
        @task.apply!(@current_user, params)
  
      # 承認
      when Task::BUTTON_APPROVE
        @task.approve!(@current_user, params)
  
      # 完了
      when Task::BUTTON_COMPLETE
        @task.complete!(@current_user, params)
  
      # 差戻し
      when Task::BUTTON_RETURN
        @task.return!(@current_user, params)
        
      # 削除
      when Task::BUTTON_DELETE
        @task.delete!(@current_user, params)
     
      else
        # ?
      end
    end

    redirect_to tasks_path, notice: 'Task was successfully created.'

    rescue => e
      puts e
      puts e.backtrace
      redirect_to tasks_path, notice: 'Creation of the task went wrong.'

  end

  
end
