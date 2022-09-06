var EventDateUtil = require('../utils/eventDateUtil');
var EventDateConstants = require('../constants/eventDateConstants');
var Dispatcher = require('../dispatcher/dispatcher');

var EventDateAction = {

  createEventDate: function(data) {
    EventDateUtil.createEventDate(data, this.receiveEventDate)
  },

  fetchEventDates: function(data) {
    EventDateUtil.fetchEventDates(data, this.receiveEventDates)
  },

  receiveEventDate: function(newEventDate) {
    
    Dispatcher.dispatch({
      actionType: EventDateConstants.RECEIVE_EVENT_DATE,
      date: newEventDate
    });
  },

  receiveEventDates: function(eventDates) {
    
    Dispatcher.dispatch({
      actionType: EventDateConstants.RECEIVE_EVENT_DATES,
      data: eventDates
    });
  }

};

module.exports = EventDateAction;
