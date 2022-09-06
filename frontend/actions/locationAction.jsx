var LocationUtil = require('../utils/locationUtil');
var LocationConstants = require('../constants/locationConstants');
var Dispatcher = require('../dispatcher/dispatcher');

var LocationAction = {

  editLocation: function(data) {
    LocationUtil.editLocation(data, this.receiveEditLocation)
  },

  setLocation: function(data) {
    Dispatcher.dispatch({
      actionType: LocationConstants.SET_LOCATION,
      location: data
    });
  },

  fetchLocations: function(data){
    LocationUtil.fetchLocations(data, this.receiveLocations)
  },

  createLocation: function(data) {
    
    LocationUtil.createLocation(data, this.receiveLocation)
  },

  deleteLocation: function(data){
    LocationUtil.deleteLocation(data, this.receiveDeleteLocation)
  },

  receiveEditLocation: function(editLocation) {
    Dispatcher.dispatch({
      actionType: LocationConstants.RECEIVE_EDIT_LOCATION,
      location: editLocation
    });
  },

  receiveLocations: function(locations, current_location_id) {
    Dispatcher.dispatch({
      actionType: LocationConstants.RECEIVE_LOCATIONS,
      data: locations,
      current_location_id: current_location_id
    });
  },

  receiveLocation: function(newLocation) {
    Dispatcher.dispatch({
      actionType: LocationConstants.RECEIVE_LOCATION,
      location: newLocation
    });
  },

  receiveDeleteLocation: function (deleteLocation){
    Dispatcher.dispatch({
      actionType: LocationConstants.RECEIVE_DELETE_LOCATION,
      location: deleteLocation.id
    });
  }



};

module.exports = LocationAction;
