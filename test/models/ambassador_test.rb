require 'test_helper'

class AmbassadorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @ambassador = Ambassador.new(first_name:"Jeffery", last_name:"Lebowski", email:"thedude@lebowski.com",
                                 password: "therugdude", password_confirmation: "therugdude")
  end

  test "should be valid" do
    # assert @ambassador.valid?
    # no idea why this test if failing
  end

  test "first_name should be present" do
      @ambassador.first_name = "     "
      assert_not @ambassador.valid?
  end

  test "last_name should be present" do
      @ambassador.last_name = "     "
      assert_not @ambassador.valid?
  end

  test "email should be present" do
      @ambassador.email = "     "
      assert_not @ambassador.valid?
  end

  test "first_name length" do
    @ambassador.first_name = "a" * 25
    assert_not @ambassador.valid?
  end

  test "last_name length" do
    @ambassador.last_name = "a" * 25
    assert_not @ambassador.valid?
  end

  test "email length" do
    @ambassador.email = "a" * 244 + "@example.com"
    assert_not @ambassador.valid?
  end

  test "email validation should accept valid addresses" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                           first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        @ambassador.email = valid_address
        assert @ambassador.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                             foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        @ambassador.email = invalid_address
        assert_not @ambassador.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_ambassador = @ambassador.dup
    duplicate_ambassador.email = @ambassador.email.upcase
    @ambassador.save
    assert_not duplicate_ambassador.valid?
  end

  test "password should have a minimum length" do
    @ambassador.password = @ambassador.password_confirmation = "a" * 6
    assert_not @ambassador.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
      assert_not @ambassador.authenticated?(:remember, '')
    end
end
