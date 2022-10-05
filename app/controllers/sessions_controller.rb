class SessionsController < ApplicationController

    def create
        user = find_user_by_username()
        if user&.authenticate(params[:password])
            session[:user_id] = user.id
            render json: user, only: [:id, :username, :image_url, :bio], status: :created
        else
            render json: { error: "Invalid username or password" }, status: :unauthorized
            # render json: {errors: ActiveRecord.record.errors.full_messages}, status: :unauthorized
        end
    rescue ActiveRecord::RecordNotFound => e
            render json: {errors: [e]}, status: :unauthorized
    end

    def destroy
        if(session[:user_id])
            session.delete :user_id
            head :no_content
        else
            render json: {errors: ["Not logged in"] }, status: :unauthorized
        end
    rescue NoMethodError => e
        byebug
        render json: {errors: [e]}, status: :unauthorized
    # rescue ActiveRecord::RecordNotFound => e
    end

    private

    def find_user_by_username
        User.find_by!(username: params[:username])
    end

end
