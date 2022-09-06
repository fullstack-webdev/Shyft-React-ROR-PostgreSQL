var Store = require('flux/utils').Store;
var Dispatcher = require('../dispatcher/dispatcher');
var EventConstants = require('../constants/eventConstants');
var AmbassadorConstants = require('../constants/ambassadorConstants');
var EventStore = new Store(Dispatcher);

var _event = {
  name: "New Event",
  eventDetail: "Describe your event here",
  event_locations: [],
  event_dates: [],
  id: null
};

var receiveEvent = function (event) {
  //we only read id at the moment...
  _event = event

};

EventStore.getEvent = function (){
  return _event
};

EventStore.__onDispatch = function(payload){
  switch(payload.actionType) {
    case EventConstants.RECEIVE_NEW_EVENT:
      receiveEvent(payload.event)
      EventStore.__emitChange()
      break;
    default:
      break;
  }
};

module.exports = EventStore;
