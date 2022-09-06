var ShiftUtil = require('../utils/shiftUtil');
var ShiftConstants = require('../constants/shiftConstants');
var Dispatcher = require('../dispatcher/dispatcher');

var ShiftAction = {
  selectShift: function(data){
    Dispatcher.dispatch({
      actionType: ShiftConstants.SELECT_SHIFT,
      data: data
    })
  },
  receiveShift: function(data) {
    Dispatcher.dispatch({
      actionType: ShiftConstants.RECEIVE_SHIFT,
      data: data
    });
  },
};

module.exports = ShiftAction;
