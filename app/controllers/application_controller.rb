class ApplicationController < ActionController::Base
    before_action :set_current_user

    private

    def set_current_user
        @current_user ||= session[:current_user_id] &&
            User.find_by(id: session[:current_user_id])
    end

    def authenticate_user
        if @current_user == nil
            flash[:notice] = "You must be logged in"
            redirect_to "/login"
        end
    end

    def forbid_login_user
        if @current_user
            flash[:notice] = "You are already logged in"
            redirect_to "/"
        end
    end
end
