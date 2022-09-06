class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :images, dependent: :destroy
  has_many :ambassadors
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  accepts_attachments_for :images, attachment: :file, append: true
  def edit
  	@images = Ambassador.images
  end       

end
