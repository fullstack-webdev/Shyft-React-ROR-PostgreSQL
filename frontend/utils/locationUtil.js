var LocationUtil = {

  fetchLocations: function(data, receiveLocations) {

    $.ajax({
      url: "/api/event_locations/",
      method: "GET",
      data: {
        event_id: data.event_id
      },
      success: function (response) {

        receiveLocations(response, data.current_location_id);

      },
      error: function(error,status) {
      }
    })
  },

  editLocation: function(data, updateLocation) {
    $.ajax({
      url: "/api/event_locations/" + data.id,
      method: "PATCH",
      data: { location: {
        label: data.label,
        address: data.address,
        city: data.city,
        zip: data.zip,
        state: data.state,
        country: data.country,
        notes: data.notes,
        event_id: data.event_id
      }},
      success: function (response) {

        updateLocation(response);

      },
      error: function(error,status) {
        //console.log(error);
      }
    })
  },

  deleteLocation: function(data, deleteLocation) {

    $.ajax({
      url: "/api/event_locations/" + data.id,
      method: "DELETE",
      data: { location: {
        label: data.label,
        address: data.address,
        city: data.city,
        zip: data.zip,
        state: data.state,
        country: data.country,
        notes: data.notes,
        event_id: data.event_id
      }},
      success: function (response) {

        deleteLocation(response);

      },
      error: function(error,status) {

      }
    })
  },

  createLocation: function(data, receiveNewLocation) {

    $.ajax({
      url: "/api/event_locations",
      method: "POST",
      data: { location: {
        label: data.label,
        address: data.address,
        city: data.city,
        zip: data.zip,
        state: data.state,
        country: data.country,
        notes: data.notes,
        event_id: data.event_id
      }},
      success: function (response) {

        receiveNewLocation(response);
      },
      error: function(error,status) {

      }
    })
  }

};
module.exports = LocationUtil;
