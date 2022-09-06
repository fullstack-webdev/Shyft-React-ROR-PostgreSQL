class Image < ActiveRecord::Base
	belongs_to :ambassador
  	attachment :file

end
