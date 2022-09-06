var Store = require('flux/utils').Store;
var Dispatcher = require('../dispatcher/dispatcher');
var ShiftConstants = require('../constants/shiftConstants');
var ShiftStore = new Store(Dispatcher);

var _shifts = []
var _selectedShift = null
var receiveShift = function (shift) {
  _shifts.push(shift)
  
};

var selectShift = function(shift) {
    _selectedShift = shift;
};

ShiftStore.selectedShift = function() {
  return _selectedShift;
};


ShiftStore.getShifts = function (){
  return _shifts
};

ShiftStore.__onDispatch = function(payload){
  
  switch(payload.actionType) {
    case ShiftConstants.RECEIVE_SHIFT:
      
      receiveShift(payload.shift)
      ShiftStore.__emitChange()
      break;
    case ShiftConstants.SELECT_SHIFT:
      
      selectShift(payload.data)
      ShiftStore.__emitChange()
      break;
  }
};

module.exports = ShiftStore;
