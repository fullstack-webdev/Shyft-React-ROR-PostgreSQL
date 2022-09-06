class Agency < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable
         :confirmable

  validates :first_name, presence:true
  validates :last_name, presence:true
  validates :company_name, presence:true
  validates :phone_number, length: { is:10 }, uniqueness: {case_sensitive: false}

  has_many :reviews

  has_many :events, :dependent => :destroy
  accepts_nested_attributes_for :events, :allow_destroy => true
  has_many :messages, :as => :user

    # Sends activation email.
  def send_activation_email
    
    AgencyMailer.account_signup_admin(self).deliver_now
  end

  def display_name
    self.company_name
  end

  def full_name
    [first_name, last_name].join(' ')
  end
end
