class RecipesController < ApplicationController

    def index
        recipes = Recipe.all
        if(session[:user_id])
            # byebug
            render json: recipes, status: :created
        else
            render json: { errors: ["Not logged in"]}, status: :unauthorized
        end
    end

    def create
        if(session[:user_id])
            user = User.find(session[:user_id])
            new_recipe = Recipe.new(permitted_params)
            new_recipe.user_id = session[:user_id]
            # byebug
            if new_recipe.valid?
                new_recipe.save
                render json: new_recipe, status: :created
            else
                render json: { errors: ["Invalid"] }, status: :unprocessable_entity
            end
        else
            # render json: {error: "Not logged in"}, status: :unauthorized
            render json: { errors: ["Not logged in"]}, status: :unauthorized
        end
    #rescue ActiveRecord::RecordInvalid => e
        #render json: { errors: [e.record.errors.full_messages] }, status: :unprocessable_entity
    end

    private

    def permitted_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end

end
