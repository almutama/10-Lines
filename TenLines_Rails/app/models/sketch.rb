class Sketch < ActiveRecord::Base
    has_many :lines
    has_many :comments
    has_many :users
    belongs_to :creator, :class_name => "User", :foreign_key => :creator_id
end
