json.id @event.id
json.name @event.name
json.event_details @event.event_details

json.event_locations do
  json.array! (@event.event_locations) do |location|
    json.id   location.id
    json.label  location.label
    json.address  location.address
    json.zip  location.zip
    json.state  location.state
    json.country  location.country
    json.notes  location.notes
    json.event_id  location.event_id
    json.city  location.city
    json.city_id  location.city_id
    json.event_dates do
      json.array! (location.event_dates) do |event_date|
        json.id event_date.id
        json.event_date event_date.event_date
        json.start_time event_date.start_time
        json.end_time event_date.end_time
        json.event_location_id event_date.event_location_id
      end
    end
  end
end
