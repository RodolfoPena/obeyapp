module TasksHelper
  def task_progress(commitment)
    (((commitment.tasks.where(done: true).count.to_f) / (commitment.tasks.count.to_f)).to_f)*100
  end

  def tasks_done(commitment)
    commitment.tasks.where(done:true).count
  end
end
