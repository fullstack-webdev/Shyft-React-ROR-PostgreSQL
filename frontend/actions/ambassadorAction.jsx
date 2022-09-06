var AmbassadorUtil = require('../utils/ambassadorUtil');
var AmbassadorConstants = require('../constants/ambassadorConstants');
var Dispatcher = require('../dispatcher/dispatcher');

var AmbassadorAction = {

  fetchAllAmbassadors: function() {
    AmbassadorUtil.fetchAllAmbassadors(this.receiveAllAmbassador)
  },

  receiveAllAmbassador: function(ambassadors) {

    Dispatcher.dispatch({
      actionType: AmbassadorConstants.RECEIVE_AMBASSADORS,
      ambassadors: ambassadors
    });
  },

  receiveAmbassadorByRole: function(ambassadors) {

    Dispatcher.dispatch({
      actionType: AmbassadorConstants.ROLE_SELECTED_AMBASSADORS,
      ambassadors: ambassadors
    });
  },

  canBookAmbassador: function(ambassador, event){
    Dispatcher.dispatch({
      actionType: AmbassadorConstants.HOVER_BOOK_AMBASSADOR,
      ambassador: ambassador,
      event: event
    });
  },

  bookAmbassador: function(ambassadorData, event){
    Dispatcher.dispatch({
      actionType: AmbassadorConstants.BOOK_AMBASSADOR,
      ambassadorData: ambassadorData,
      event: event
    });
  },

  receiveBookedAmbassadors: function(data){
    Dispatcher.dispatch({
      actionType: AmbassadorConstants.RECEIVE_BOOKED_AMBASSADORS,
      data: data
    })
  },

  bookAmbassadorRole: function(ambassadorData, role){
    Dispatcher.dispatch({
      actionType: AmbassadorConstants.BOOK_AMBASSADOR,
      data: {
        ambassadorData: ambassadorData,
        role: role
      }
    });
  },

  removeAmbassadorRole: function(role){
    Dispatcher.dispatch({
      actionType: AmbassadorConstants.REMOVE_AMBASSADOR,
      data: {
        role: role
      }
    });
  },

  filterOutAmbassador: function( ambassadorData, role){
    Dispatcher.dispatch({
      actionType: AmbassadorConstants.FILTER_OUT_AMBASSADOR,
      data: {
        ambassadorData: ambassadorData,
        role: role
      }
    });
  },

  fetchFilteredAmbassadors: function(filters, locationId) {
    AmbassadorUtil.fetchFilteredAmbassadors(filters, locationId, this.receiveAllAmbassador)
  },

  fetchFilterAmbassadorsByRole: function(role){
    AmbassadorUtil.fetchAmbassadorsByRole(role, this.receiveAmbassadorByRole)
  },

  fetchShortListedAmbassadors: function(event_id) {
    AmbassadorUtil.getShortListedAmbassadors(event_id, this.receiveBookedAmbassadors)
  },

  bookAmbassadorForRole: function( ambassadorData, role) {
    AmbassadorUtil.bookAmbassadorForRole(role, ambassadorData, this.bookAmbassadorRole) 
  },

  removeAmbassadorForRole: function( role){
    AmbassadorUtil.removeAmbassadorForRole(role, this.removeAmbassadorRole)
  }


};

module.exports = AmbassadorAction;
