class Review < ActiveRecord::Base
  belongs_to :ambassador
  default_scope -> { order(created_at: :desc) }
  validates :ambassador_id, presence: true
  validates :content, presence: true, length: { minimum: 50 }
end
