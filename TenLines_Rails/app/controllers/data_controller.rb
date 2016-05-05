class DataController < ApplicationController

    # Returns news feed items.
    def feed
        render json: []
    end

    # Adds a sketch for the given user.
    #
    # Parameters:
    # user - user ID of user creating this sketch.
    # title - sketch title.
    def add_sketch
        title = params[:title]
        user_id = params[:user_id]
        creator = User.find_by(id: user_id)
        if (not creator)
            render json: {"result" => "Failure"}
            return
        end

        # Create sketch.
        sketch = Sketch.new(title: title)
        sketch.creator = creator
        sketch.ispublic = (params[:public].present?) ? true : false
        creator.creations << sketch

        # Commit transaction.
        if (sketch.save and creator.save)
            render json: {"result" => "Success", "sketch_id" => sketch.id}
        else
            render json: {"result" => "Failure"}
        end
    end

    # Invites another user to join a sketch.
    #
    # Parameters:
    # sketch_id - sketch ID of sketch to share.
    # user_id - user ID of the sketch's creator.
    # guest_id - user ID of guest to invite.
    def invite
        # Validate sketch.
        creator_id = params[:user_id]
        sketch_id = params[:sketch_id]
        sketch = Sketch.find_by(creator_id: creator_id, id: sketch_id)
        if (not sketch)
            render json: {"result" => "Failure"}
            return
        end

        # Validate guest.
        guest_id = params[:guest_id]
        guest = User.find_by(id: guest_id)
        if (not guest)
            render json: {"result" => "Failure"}
            return
        end

        # Add guest to sketch.
        guest.sketches << sketch
        sketch.users << guest

        # Commit transaction.
        if (sketch.save and guest.save)
            render json: {"result" => "Success"}
        else
            render json: {"result" => "Failure"}
        end
    end

    # Adds a line to a sketch.
    # 
    # Parameters:
    # user_id - user ID of user making this request.
    # sketch_id - sketch ID of sketch to modify.
    # color - line color.
    # width - line stroke width.
    # points - line points encoded as JSON.
    def add_line
        # Validate sketch.
        user_id = params[:user_id]
        sketch_id = params[:sketch_id]
        sketch = Sketch.find_by(user_id: user_id, id: sketch_id)
        if (not sketch)
            sketch = Sketch.find_by(creator_id: user_id, id: sketch_id)
            if (not sketch)
                render json: {"result" => "Failure"}
                return
            end
        end

        # Create line
        color = params[:color]
        width = params[:width].to_i
        points = params[:points]
        line = Line.new(color: color, width: width, lines: points)
        sketch.lines << line

        # Commit transaction.
        if (line.save and sketch.save)
            render json: {"result" => "Success", "line_id" => line.id}
        else
            render json: {"result" => "Failure"}
        end
    end

    # Removes a line to a sketch.
    # 
    # Parameters:
    # user_id - user ID of user making this request.
    # sketch_id - sketch ID of sketch to modify.
    # color - line color.
    # width - line stroke width.
    # points - line points encoded as JSON.
    def remove_line
        # Validate sketch.
        user_id = params[:user_id]
        sketch_id = params[:sketch_id]
        sketch = Sketch.find_by(user_id: user_id, id: sketch_id)
        if (not sketch)
            sketch = Sketch.find_by(creator_id: user_id, id: sketch_id)
            if (not sketch)
                render json: {"result" => "Failure"}
                return
            end
        end

        # Validate line.
        line_id = params[:line_id]
        line = Line.find_by(id: line_id)
        if (not line)
            render json: {"result" => "Failure"}
        end

        # Remove line.
        line.destroy()
        render json: {"result" => "Success"}
    end

    # Adds a comment to a user sketch.
    # 
    # Parameters:
    # user_id - user ID of user making this request.
    # sketch_id - sketch ID of sketch to modify.
    # comment - the comment text.
    def add_comment
        # Bail if no comment provided.
        if (not params[:comment].present?)
            render json: {"result" => "Failure"}
            return
        end

        # Validate sketch.
        user_id = params[:user_id]
        sketch_id = params[:sketch_id]
        sketch = Sketch.find_by(user_id: user_id, id: sketch_id)
        if (not sketch)
            sketch = Sketch.find_by(creator_id: user_id, id: sketch_id)
            if (not sketch)
                render json: {"result" => "Failure"}
                return
            end
        end

        # Find user.
        user = User.find_by(id: user_id)

        # Create comment.
        comment = Comment.new(text: params[:comment])
        comment.user = user
        comment.sketch = sketch
        sketch.comments << comment
        user.comments << comment

        # Commit transaction.
        if (comment.save and sketch.save and user.save)
            render json: {"result" => "Success", "comment_id" => comment.id}
        else
            render json: {"result" => "Failure"}
        end
    end

    # Adds a screenshot to the given sketch.
    #
    # Parameters:
    # user_id - user ID of user making this request.
    # sketch_id - sketch ID of sketch that was screenshot'ed.
    # screenshot - base64 string with screenshot image data.
    def add_screenshot
        # Sanity check that we actually received image data.
        if (not params[:screenshot].present?)
            render json: {"result" => "Failure"}
        end

        # Validate sketch.
        user_id = params[:user_id]
        sketch_id = params[:sketch_id]
        sketch = Sketch.find_by(user_id: user_id, id: sketch_id)
        if (not sketch)
            sketch = Sketch.find_by(creator_id: user_id, id: sketch_id)
            if (not sketch)
                render json: {"result" => "Failure"}
                return
            end
        end

        # Update sketch.
        sketch.url = params[:screenshot]

        # Commit transaction.
        if (sketch.save)
            render json: {"result" => "Success"}
        else
            render json: {"result" => "Failure"}
        end
    end

    # Gets the lines for a sketch.
    #
    # Parameters:
    # user_id - user ID of user making this request.
    # sketch_id - sketch ID of sketch to get lines from.
    def get_lines
        # Validate sketch.
        user_id = params[:user_id]
        sketch_id = params[:sketch_id]
        sketch = Sketch.find_by(user_id: user_id, id: sketch_id)
        if (not sketch)
            sketch = Sketch.find_by(creator_id: user_id, id: sketch_id)
            if (not sketch)
                render json: {"result" => "Failure"}
                return
            end
        end
        render json: sketch.lines
    end

    # Gets the comments for a sketch.
    #
    # Parameters:
    # user_id - user ID of user making this request.
    # sketch_id - sketch ID of sketch to get comments for.
    def get_comments
        # Validate sketch.
        user_id = params[:user_id]
        sketch_id = params[:sketch_id]
        sketch = Sketch.find_by(user_id: user_id, id: sketch_id)
        if (not sketch)
            sketch = Sketch.find_by(creator_id: user_id, id: sketch_id)
            if (not sketch)
                render json: {"result" => "Failure"}
                return
            end
        end

        output = Array.new
        sketch.comments.each do |comment|
            temp = Hash.new
            temp["username"] = comment.user.username
            temp["firstname"] = comment.user.firstname
            temp["lastname"] = comment.user.lastname
            temp["text"] = comment.text
            output.push(temp)
        end
        render json: output
    end

    # Gets the invites for a given user.
    #
    # Parameters:
    # user_id - user ID of user making this request.
    def get_invites
        # Validate user first.
        user_id = params[:user_id]
        user = User.find_by(id: user_id)
        if (not user)
            render json: {"result" => "Failure"}
            return
        end

        output = Array.new
        user.sketches.each do |sketch|
            temp = Hash.new
            temp["id"] = sketch.id
            temp["title"] = sketch.title
            temp["creator"] = sketch.creator.username
            temp["artists"] = 1 + sketch.users.size
            temp["lines"] = sketch.lines.size
            temp["upvotes"] = (sketch.upvotes) ? sketch.upvotes : 0
            temp["comments"] = sketch.comments.size
            output.push(temp)
        end
        render json: output
    end

    # Gets the sketches created by a given user.
    #
    # Parameters:
    # user_id - user ID of the creator.
    def get_sketches
        # Validate user first.
        if (params[:user_id].present?)
            user_id = params[:user_id]
            creator = User.find_by(id: user_id)
            if (not creator)
                render json: {"result" => "Failure"}
                return
            end
            sketches = creator.creations
        else
            if (params[:public].present?)
                output = Array.new
                Sketch.where(ispublic: true, created_at: :desc).limit(10).each do |creation|
                    temp = Hash.new
                    temp["id"] = creation.id
                    temp["title"] = creation.title
                    temp["creator"] = creation.creator.username
                    temp["artists"] = 1 + creation.users.size
                    temp["lines"] = creation.lines.size
                    temp["upvotes"] = (creation.upvotes) ? creation.upvotes : 0
                    temp["comments"] = creation.comments.size
                    output.push(temp)
                end
                render json: output
            else
                output = Array.new
                Sketch.order(created_at: :desc).limit(10).each do |creation|
                    temp = Hash.new
                    temp["id"] = creation.id
                    temp["title"] = creation.title
                    temp["creator"] = creation.creator.username
                    temp["artists"] = 1 + creation.users.size
                    temp["lines"] = creation.lines.size
                    temp["upvotes"] = (creation.upvotes) ? creation.upvotes : 0
                    temp["comments"] = creation.comments.size
                    output.push(temp)
                end
                render json: output
            end
        end
    end

    # Returns the image data for a single sketch as a
    # base64 string.
    # 
    # Parameters:
    # sketch_id - ID of sketch to get image data from.
    def get_sketch
        # Validate sketch.
        sketch_id = params[:sketch_id]
        sketch = Sketch.find_by(id: sketch_id)
        if (not sketch)
            render json: {"result" => "Failure"}
        else
            render json: [sketch.url]
        end
    end

    # Returns the image data for a user profile picture 
    # as a base64 string.
    #
    # Parameters:
    # user_id - ID of user to get profile picture for.
    def get_user_pic
        # Validate user.
        user_id = params[:user_id]
        user = User.find_by(id: user_id)
        if (not user)
            render json: {"result" => "Failure"}
        else
            render json: [user.icon]
        end
    end

    # Gets all registered users excluding the user making
    # this request.
    #
    # Parameters:
    # user_id - ID of user making this request.
    def get_users
        # Get user
        if (params[:user_id].present?)
            user_id = params[:user_id]
            user = User.find_by(id: user_id)
        else
            render json: {"result" => "Failure"}
            return
        end

        output = Array.new
        User.all.each do |user|
            next if (user.id == user_id.to_i)
            temp = Hash.new
            temp["id"] = user.id
            temp["username"] = user.username
            temp["firstname"] = user.firstname
            temp["lastname"] = user.lastname
            output.push(temp)
        end
        render json: output
    end

end
