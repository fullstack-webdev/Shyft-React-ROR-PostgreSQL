var EventUtil = {

  fetchEvent: function(data, receiveEvent) {

    $.ajax({
      url: "/api/events/",
      method: "GET",
      success: function (data) {
        receiveEvent(data);
        // this.props.handleNewEvent(data),
        // will create event store instead and have event component listen to it
      },
      error: function(error,status) {

      }
    })
  },

  editEvent: function(data, updateEvent) {
    //
    $.ajax({
      url: "/api/events/" + data.id,
      method: "PATCH",
      data: {event: {
        name: data.name,
        event_details: data.event_details
      }},
      success: function (data) {

        //this.props.handleNewEvent(data),
        // will create event store instead and have event component listen to it
        updateEvent(data)
      },
      error: function(error,status) {
        //
      }
    })
  },

  setEventCurrentLocation: function(data, updateEvent) {
    //
    $.ajax({
      url: "/api/events/" + data.id,
      method: "PATCH",
      data: {event: {
        current_location_id: data.current_location_id,
      }},
      success: function (data) {

        //this.props.handleNewEvent(data),
        // will create event store instead and have event component listen to it
        updateEvent(data)
      },
      error: function(error,status) {
        //
      }
    })
  },

  createNewEvent: function(data, receiveNewEvent) {

    $.ajax({
      url: "/api/events",
      method: "POST",
      data: { event: {
        name: data.name,
        event_details: data.event_details
      }},

      success: function (data) {
        
        receiveNewEvent(data);
      },
      error: function(error,status) {

      }
    })
  }

};
module.exports = EventUtil;
