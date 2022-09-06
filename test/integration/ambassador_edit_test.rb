require 'test_helper'

class AmbassadorEditTest < ActionDispatch::IntegrationTest
  def setup
    @ambassador = ambassadors(:lebowski)
  end

  test 'unsuccessful edit' do
    log_in_as( @ambassador )
    get edit_ambassador_path( @ambassador )
    assert_template 'ambassadors/edit'

    patch ambassador_path(@ambassador), ambassador:{
                                          first_name: "",
                                          last_name:"",
                                          email:"something@invalid",
                                          password: "",
                                          password_confirmation: ""
                                        }

    assert_template 'ambassadors/edit'
  end


  test 'successful edit' do
    log_in_as( @ambassador )
    get edit_ambassador_path( @ambassador )
    assert_template 'ambassadors/edit'
    first_name = "Jeffery"
    last_name = "Lebowski"
    email = "thedude@lebowski.com"
    patch ambassador_path(@ambassador), ambassador:{
                                          first_name: first_name,
                                          last_name:last_name,
                                          email:email,
                                          password: "",
                                          password_confirmation: ""
                                        }

    assert_not flash.empty?
    assert_redirected_to @ambassador
    @ambassador.reload
    assert_equal @ambassador.first_name, first_name
    assert_equal @ambassador.last_name, last_name    
    assert_equal @ambassador.email, email
  end

end
