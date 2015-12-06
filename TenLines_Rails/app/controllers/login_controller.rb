class LoginController < ApplicationController

    # Attempts logging a user in with the given username and password.
    #
    # Parameters:
    # username - username to login with.
    # password - password for the given username.
    def login
        # Check parameters.
        if (not params[:username].present? or
            not params[:password].present?)
            render json: {"result" => "Failure"}
            return
        end

        # Fetch user credentials.
        username = params[:username]
        password = params[:password]
        user = User.find_by(username: username)

        # Return result of lookup.
        if (user and user.password_valid?(password))
            render json: {"result" => "Success", 
                          "user_id" => user.id,
                          "username" => user.username,
                          "firstname" => user.firstname,
                          "lastname" => user.lastname}
        else
            render json: {"result" => "Failure"}
        end
    end

    # Creates a new user account.
    #
    # Parameters:
    # username - username of new account.
    # password - password of new account.
    # image - profile picture of user as base64 string.
    def create
        # Fetch user credentials.
        username = params[:username]
        password = params[:password]
        image = params[:image]

        # Create a new user with those credentials.
        user = User.new(username: username, password: password, icon: image)
        if (user.save)
            render json: {"result" => "Success", "user_id" => user.id}
        else
            render json: {"result" => "Failure"}
        end
    end

end
