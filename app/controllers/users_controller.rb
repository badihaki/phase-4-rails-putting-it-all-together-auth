class UsersController < ApplicationController

    def create
        new_user = User.create!(permitted_params)
        session[:user_id] = new_user.id
        render json: new_user, only: [:id, :username, :image_url, :bio], status: :created
    rescue ActiveRecord::RecordInvalid => e
        render json: {errors: e.record.errors.full_messages}, status: :unprocessable_entity
    end

    def show
        # byebug
        if(params[:recipe_id])
            user = User.find(params[:id])
            render json: user, status: :ok
        else
            user = User.find_by(id: session[:user_id])
            if user
                render json: user, only: [:id, :username, :image_url, :bio], status: :created
            else
                render json: {error: "Not authorized"}, status: :unauthorized
            end
        end
    end

    private

    def permitted_params
        params.permit(:username, :password, :password_confirmation, :image_url, :bio)
    end

end
