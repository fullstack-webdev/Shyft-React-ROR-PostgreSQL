var Store = require('flux/utils').Store;
var Dispatcher = require('../dispatcher/dispatcher');
var EventDateConstants = require('../constants/eventDateConstants');
var AmbassadorConstants = require('../constants/ambassadorConstants');
var EventDateStore = new Store(Dispatcher);

var _eventDates = []
var _hoverAmbassador = null;

var receiveEventDate = function (eventDate) {
  _eventDates.push(eventDate)

};

var receiveEventDates = function (eventDates) {
  _eventDates = eventDates

};

var receiveHoverAmbassador = function(ambassador){
  _hoverAmbassador = ambassador;
  
}

var createEventDate = function(eventDate, callback){
  $.ajax({
    type: 'POST',
    url: '/eventDate/create',
    data: eventDate
  })
  .done(function(data) {
    // this.props.handleNewDate(data)
    callback(data);
  })
  .fail(function(jqXhr) {
  })
}

var recieveBookableRoles = function(eventDate, shift, callback){
  var data = [1];
  callback(data);
}


EventDateStore.getEventDates = function (){
  return _eventDates
};

EventDateStore.getHoverAmbassador = function() {
  return _hoverAmbassador
}

EventDateStore.__onDispatch = function(payload){
  switch(payload.actionType) {
    case EventDateConstants.RECEIVE_EVENT_DATE:
      
      receiveEventDate(payload.date)
      EventDateStore.__emitChange()
      break;
    case EventDateConstants.RECEIVE_EVENT_DATES:
      
      receiveEventDates(payload.data)
      EventDateStore.__emitChange()
      break;  
    case EventDateConstants.CREATE_EVENT_DATE:
      
      createEventDate(payload.date)
      EventDateStore.__emitChange()
      break;
    
  }
};

module.exports = EventDateStore;
  