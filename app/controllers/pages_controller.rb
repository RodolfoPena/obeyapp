class PagesController < ApplicationController
    def obeya_skills
      @users = User.all
    end
end
