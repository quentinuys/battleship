class Nuke < ActiveRecord::Base
	belongs_to :nukeable, polymorphic: :true

end
