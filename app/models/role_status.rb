class RoleStatus < ActiveRecord::Base

  def self.empty_status
    role_status = self.find_by(:status=>'empty')
    return role_status.status
  end

  def self.short_list
    role_status = self.find_by(:status=>'short-list')
    return role_status.status
  end

  def self.pending
    role_status = self.find_by(:status=>'pending')
    return role_status.status
  end

  def self.declined
    role_status = self.find_by(:status=>'declined')
    return role_status.status
  end

  def self.confirmed
    role_status = self.find_by(:status=>'confirmed')
    return role_status.status
  end

  def self.expired
    role_status = self.find_by(:status=>'expired')
    return role_status.status
  end
end
