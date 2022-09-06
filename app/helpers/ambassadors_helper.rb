module AmbassadorsHelper

  # Returns the Gravatar for the given user.
    def gravatar_for(ambassador)
      gravatar_id = Digest::MD5::hexdigest(ambassador.email.downcase)
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
      image_tag(gravatar_url, alt: ambassador.first_name + ' ' + ambassador.last_name, class: "gravatar")
    end
end
