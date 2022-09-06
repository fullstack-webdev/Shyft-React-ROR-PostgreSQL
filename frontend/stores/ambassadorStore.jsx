var Store = require('flux/utils').Store;
var Dispatcher = require('../dispatcher/dispatcher');
var AmbassadorConstants = require('../constants/ambassadorConstants');
var AmbassadorStore = new Store(Dispatcher);

var _ambassadors = [];
var _hoverAmbassador= null;
var _bookedAmbassadors = [];

var receiveAmbassador = function (ambassadors) {
  _ambassadors = ambassadors.ambassadors;

};

var receiveHoverAmbassador = function( ambassador){
  _hoverAmbassador = ambassador;
}

var clearHoverAmbassdor = function (){
  _hoverAmbassador = null;
}

var receiveBookedAmbassador = function( ambassadorData, role){
  _bookedAmbassadors[role.id] = ambassadorData
}

var receiveBookedAmbassadors = function(data) {
  clearBookedAmbassador()
  _.each(data, function(booking){
    receiveBookedAmbassador(booking.ambassadorData, booking.role)
  })
}
var removeBookedAmbassador = function(role){
  _bookedAmbassadors[role.id] = null
}

var clearBookedAmbassador = function () {
  _bookedAmbassadors = []
}

var fitlerOutAmbassador = function(ambassadorData) {
  _ambassadors = []
  _ambassadors.push(ambassadorData)
}

AmbassadorStore.getAmbassadors = function (){
  
  return _ambassadors
};

AmbassadorStore.getHoverAmbassador = function(){
  return _hoverAmbassador;
}

AmbassadorStore.getBookedAmbassadors = function() {
  return _bookedAmbassadors
}

AmbassadorStore.hasShortListedAmbassadors = function() {
  var length = _.filter(_bookedAmbassadors, function(role){
    return role != null
  }).length
  return length > 0
}

AmbassadorStore.getAmbassadorById = function(id) {
  for (var i = 0; i < _ambassadors.length; i++) {
    if (_ambassadors[i].id === id) {
      return ambassadors[i]
    }
  }
};

AmbassadorStore.__onDispatch = function(payload){
  switch(payload.actionType) {
    case AmbassadorConstants.RECEIVE_AMBASSADORS:
      
      receiveAmbassador(payload.ambassadors)
      AmbassadorStore.__emitChange()
      break;
    case AmbassadorConstants.RECEIVE_BOOKED_AMBASSADORS:
      receiveBookedAmbassadors(payload.data.bookedAmbassadors)
      AmbassadorStore.__emitChange()
      break; 
    case AmbassadorConstants.HOVER_BOOK_AMBASSADOR:
      
      receiveHoverAmbassador(payload.ambassador);
      AmbassadorStore.__emitChange()
      break;
    case AmbassadorConstants.ROLE_SELECTED_AMBASSADORS:
      
      receiveAmbassador(payload.ambassadors)
      AmbassadorStore.__emitChange()
      break;

    case AmbassadorConstants.FILTER_OUT_AMBASSADOR:
      fitlerOutAmbassador(payload.data.ambassadorData)
      AmbassadorStore.__emitChange()
      break;  

    case AmbassadorConstants.BOOK_AMBASSADOR:
      
      receiveBookedAmbassador(payload.data.ambassadorData, payload.data.role.role);
      AmbassadorStore.__emitChange()
      break;
    case AmbassadorConstants.REMOVE_AMBASSADOR:
      
      removeBookedAmbassador(payload.data.role.role);
      AmbassadorStore.__emitChange()
      break;  
  }
};

module.exports = AmbassadorStore;
  