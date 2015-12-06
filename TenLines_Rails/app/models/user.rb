class User < ActiveRecord::Base
    has_many :sketches
    has_many :comments
    has_many :creations, :class_name => "Sketch", :foreign_key => :creator_id

    # Returns whether or not a given password
    # is valid.
    def password_valid?(pwd)
        return self.password == pwd
    end
end
