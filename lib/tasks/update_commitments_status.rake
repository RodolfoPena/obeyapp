namespace :update_commitments_status do
  desc "TODO"
  task update_status: :environment do
    Commitment.all.each do |commitment|
      CommitmentsHelper.set_status(commitment)
    end
  end

end
