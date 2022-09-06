json.array!(@orders) do |order|
  json.extract! order, :id, :full_name, :company, :telephone, :email, :address_1, :address_2, :city, :state, :country
  json.url order_url(order, format: :json)
end
