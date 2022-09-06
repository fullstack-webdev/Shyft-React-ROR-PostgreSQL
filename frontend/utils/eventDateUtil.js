var EventDateUtil = {

  fetchEventDates: function(data, receiveEventDates) {

    $.ajax({
      url: "/api/event_dates/",
      method: "GET",
      data: {
        event_location_id: data.event_location_id
      },

      success: function (data) {
        
        receiveEventDates(data);
      },
      error: function(error,status) {
        
      }
    })
  },

  createEventDate: function(data, receiveEventDate) {

    $.ajax({
      url: "/api/event_dates/create",
      method: "POST",
      data: data,

      success: function (data) {
        
        receiveEventDate(data);
      },
      error: function(error,status) {
        
      }
    })
  },

  deleteEventDate: function(data, deleteEventDate) {

    $.ajax({
      url: "/api/event_dates/" + data.id,
      method: "DELETE",
      data: { date: data},
      success: function (data) {

        deleteEventDate(data);

      },
      error: function(error,status) {

      }
    })
  },

};

module.exports = EventDateUtil;
