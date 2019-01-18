class TasksController < ApplicationController
  before_action :set_task, except: [:create]

  def create
    @task = Task.new(task_params)
    @task.commitment = Commitment.find(params[:commitment_id])
    respond_to do |format|
      if @task.save
        @commitment = @task.commitment
        format.html { redirect_to teams_path, notice: 'Commitment was successfully created'}
        format.json { render json: @task, status: :created, location: @commitment }
        format.js
      else
        format.html { redirect_to  teams_path, alert: 'Unprocessable entity'}
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
    set_progress
  end

  def destroy
    @task.destroy
    set_progress
  end

  def done
    if @task.done == false
      @task.update_attribute(:done, true)
    else
      @task.update_attribute(:done, false)
    end
    set_progress
  end

  private

  def set_progress
    @total_tasks = (@task.commitment.tasks.count.to_f).round(1)
    @total_tasks_done_true = (@task.commitment.tasks.where(done: true).count.to_f).round(1)
    @progress = ((@total_tasks_done_true/@total_tasks)*100).round(2)
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name)
  end
end
