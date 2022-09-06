var EventUtil = require('../utils/eventUtil');
var EventConstants = require('../constants/eventConstants');
var Dispatcher = require('../dispatcher/dispatcher');

var EventAction = {

  editEvent: function(data) {
    EventUtil.editEvent(data, this.receiveNewEvent)
  },

  setEventCurrentLocation: function(data) {
    EventUtil.setEventCurrentLocation(data, this.receiveNewEvent)
  },


  createNewEvent: function(data) {
    EventUtil.createNewEvent(data, this.receiveNewEvent)
  },

  fetchEvent: function(data) {
    EventUtil.fetchEvent(data, this.receiveNewEvent)
  },

  receiveNewEvent: function(newEvent) {
    
    Dispatcher.dispatch({
      actionType: EventConstants.RECEIVE_NEW_EVENT,
      event: newEvent
    });
  },

  // fetchAmbassadors: function() {
  //   EventUtil.fetchAmbassadors(this.receiveAmbassadors);
  // },
  //
  // receiveAmbassadors: function(event) {
  //   Dispatcher.dispatch({
  //     actionType: EventConstants.EVENT_RECEIVED,
  //     event: event
  //   });
  // }


};

module.exports = EventAction;
