class HomeController < ApplicationController
  def index
  	if !user_signed_in?
	  	redirect_to new_user_registration_path
	  else
	  	redirect_to user_path(current_user)
	  end
  end
end
