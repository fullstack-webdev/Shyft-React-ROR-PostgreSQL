class Ambassador < ActiveRecord::Base
  extend FriendlyId
  friendly_id :full_name, :use => [:slugged, :finders]

  attr_accessor :remember_token, :activation_token, :reset_token, :tag_list
  before_save   :downcase_email
  before_create :create_activation_digest
  has_many :line_items
  has_many :orders, :through => :line_items
  has_one :weekly_unavailability
  accepts_nested_attributes_for :weekly_unavailability

  has_many :busy_shifts
  has_many :ambassador_roles
  accepts_nested_attributes_for :ambassador_roles
  has_many :event_roles

  # This is for the photo uploads
  has_many :images, dependent: :destroy
  accepts_attachments_for :images, attachment: :file, append: true

  has_many :messages, :as => :user
  has_many :reviews, dependent: :destroy

  has_many :property_ambassadors
  has_many :properties, :through => :property_ambassadors

  accepts_nested_attributes_for :property_ambassadors,
    :allow_destroy => true

  acts_as_taggable # Alias for acts_as_taggable_on :tags
  acts_as_taggable_on :skills

  before_destroy :ensure_not_referenced_by_any_line_item
  before_save { self.email = email.downcase }
  validates :first_name, presence:true, length: { maximum:24, minimum:1}
  validates :last_name, presence:true, length: { maximum:24, minimum:1}
  validates :phone_number, presence:true, length: { is:10 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:true, length: { maximum:255, minimum:5},
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, length: { minimum: 7 }, allow_blank: true
  validates :rate, numericality: { greater_than_or_equal_to: 1 }

  # Scopes
  scope :activated, -> { where(activated: true) }
  scope :notActivated, -> { where(activated: false) }


  # Returns the hash digest of the given string.
  def Ambassador.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def Ambassador.new_token
    SecureRandom.urlsafe_base64
  end

  # Remember a user in the database for persistent sessions.
  def remember
    self.remember_token = Ambassador.new_token
    update_attribute(:remember_digest, Ambassador.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end


  # ensure that there are no line items referencing this ambassador
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'Line Items present')
      return false
    end
  end

  def create_reset_digest
    self.reset_token = Ambassador.new_token
    update_attribute(:reset_digest,  Ambassador.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Activates an account.
  def confirm_email
    update_attribute(:email_confirmed, true)
  end

  def confirm_phone
    update_attribute(:phone_confirmed, true)
  end

  # Sends activation email.
  def send_activation_email
    AmbassadorMailer.account_activation(self).deliver_now
    AmbassadorMailer.account_signup_admin(self).deliver_now
  end

  # Sends password reset email.
  def send_password_reset_email
    AmbassadorMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def profile_photo
    if !images.first.nil?
      images.first
    end
  end
  # this is the info needed to login with facebook
  def self.find_or_create_from_auth_hash(auth_hash)
    ambassador = where(provider: auth_hash.provider, uid: auth_hash.uid).first_or_create
    ambassador.update(
      name: auth_hash.info.name,
      oauth_token: auth_hash.credentials.token,
      oauth_expires_at: auth_hash.credentials.expires_at
      )
    ambassador
  end

  def self.from_omniauth(auth)
  where(auth.slice(:provider, :uid)).first_or_initialize.tap do |ambassador|
    ambassador.provider = auth.provider
    ambassador.uid = auth.uid
    ambassador.name = auth.info.name
    ambassador.oauth_token = auth.credentials.token
    ambassador.oauth_expires_at = Time.at(auth.credentials.expires_at)
    ambassador.save!
  end
end

  def verification_phone_number
    if phone_confirmed
      area = '(' + phone_number[0..2] + ') xxx-xxxx'
      return area
    else
      return 'not verified'
    end

  end

  def verification_email
    if email_confirmed
      index = email.index('@')
      email_host = email[index..email.length]
      hide_email = email[0..index-1]
      hide_email = 'x' * (hide_email.length + 2)
      return hide_email + email_host
    else
      return 'not verified'
    end
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def average_rating
    reviews.count == 0 ? 0 : reviews.average(:star).round(2)
  end

  def available_for_shift(shift)
    end_time = @unavailable_to

    start_time = shift.start_time
    end_time = shift.end_time

    busy_from = Time.new(start_time.year, start_time.month, start_time.day, @unavailable_from.hour, @unavailable_from.min, @unavailable_from.sec)
    busy_to = Time.new(end_time.year, end_time.month, end_time.day, @unavailable_to.hour, @unavailable_to.min, @unavailable_to.sec)

    if shift.ends_on_following_day?
      # NOTE: If the start time is greater than the end time
      # the shift is going into the next day
      # we must validate that the end time comes before the start time of the following
      # weekly_unavailability day
      next_day = shift.end_time.strftime("%A").downcase
      next_day_busy_from = self.weekly_unavailability[next_day + '_start']

      if end_time
        busy_to = Time.new(end_time.year, end_time.month, end_time.day, next_day_busy_from.hour, next_day_busy_from.min, next_day_busy_from.sec)
      end
    end

    valid_start = true
    valid_end = true
    # checks if shift falls between busy times
    if start_time >= busy_from && start_time <= busy_to
      valid_start = false
    end
    if end_time >= busy_from && end_time <= busy_to
      valid_end = false
    end
    if !(valid_start && valid_end)
      return false
    end

    valid_start = true
    valid_end = true

    if busy_from >= start_time && busy_from <= end_time
        valid_start = false
    end

    if busy_to >= start_time && busy_to <= end_time
        valid_end = false
    end

    return valid_start && valid_end
  end

  # NOTE - Returns Array of Shifts by Id that Ambassador is not previously short-listed or confirmed for during
  # the sane time period
  # NOTE - shifts_by_id: The shifts we are checking to see if the Ambassador is available for
  def already_booked(shifts_by_id, event_id)
    shift_ids_to_check = EventRole.where(ambassador_id:self.id).where('role_status = ? AND event_id = ? OR role_status = ? OR role_status = ?', 'short-list', event_id, 'confirmed', 'pending').pluck(:event_date_shift_id)

    booked_shift_ids = []
    if booking = Booking.find_by(event_id: event_id)
      booking_staff = BookingStaff.where('booking_id = ? AND ambassador_id = ?', booking.id, self.id)
      if booking_staff.length > 0
        booked_roles = booking_staff.first.booking_staff_items.pluck(:event_role_id)
        booked_shift_ids = EventRole.where(id: booked_roles).pluck(:event_date_shift_id)
      end
    end

    available_shifts = []

    if shift_ids_to_check.length == 0 && booked_shift_ids.length == 0
      return shifts_by_id
    else
      if booked_shift_ids.length > 0
        shifts_by_id = self.shifts_where_first_request(shifts_by_id, booked_shift_ids)
      end

      new_shifts = EventDateShift.where(id: shifts_by_id)

      new_shifts.each do |shift|
        # MINIMUM_SHIFT_BUFFER_HOURS * 3600
        # NEED TO ADD BUFFER TO THESE QUERIES
        shifts1 = EventDateShift.where(id: shift_ids_to_check).where('start_time <= ? AND end_time >= ?', shift.start_time, shift.start_time)
        shifts2 = EventDateShift.where(id: shift_ids_to_check).where('start_time >= ? AND end_time <= ?', shift.end_time, shift.end_time)

        if shifts1.length == 0 && shifts2.length == 0
          available_shifts.push(shift.id)
        end
      end
    end
    return available_shifts
  end

  def shifts_where_first_request(shifts, booked_shifts)
    shifts.sort
    booked_shifts.sort
    unique_shifts = []
    shifts.each { |e|
      if booked_shifts.index(e).nil?
        unique_shifts.push(e)
      end
    }
    return unique_shifts
  end

  def available_for_shifts_on_day(shifts_by_id, day, event_id)
    unbooked_shifts_for_times = already_booked(shifts_by_id, event_id)

    availableShifts = {}
    shifts = EventDateShift.where(id: unbooked_shifts_for_times)

    shifts.each do |shift|
      available = true
      @unavailable_from = self.weekly_unavailability[day + '_start']
      @unavailable_to = self.weekly_unavailability[day + '_end']

      if !@unavailable_from.nil? && !@unavailable_to.nil?
        available = available_for_shift(shift)
      end

      if available
        # NOTE - IF WE HAVE VALID TIME, VALIDATE THAT WE ARE THE RIGHT ROLE AND RATE FOR THIS POSITION

        my_roles = self.ambassador_roles.pluck(:role_type_id)
        availableRoles = shift.event_roles.where(role_type_id: my_roles).where('hourly_rate >= ?', self.rate.to_f).pluck(:id)

        if availableRoles.length > 0
          availableShifts = {:shift_id => shift.id, :roles => availableRoles}
        end
      end
    end
    return availableShifts
  end

  def shift_ends_tomorrow(shift)
    shift.start_time.wday != shift.end_time.wday
  end

  def is_new?
    false
  end

  private
    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = Ambassador.new_token
      self.activation_digest = Ambassador.digest(activation_token)
    end
end
