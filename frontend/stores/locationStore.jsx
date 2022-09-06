var Store = require('flux/utils').Store;
var Dispatcher = require('../dispatcher/dispatcher');
var LocationConstants = require('../constants/locationConstants');

var LocationStore = new Store(Dispatcher);

var _locations = [];
var _location = {};

var receiveLocation = function (location) {
  _locations.push(location)
};

var receiveLocations = function (locations){
  _locations = locations
};

var setLocation = function(location) {
  localStorage.setItem("shyft/event/new/location", JSON.stringify(location))
  _location = location
};

var editLocation = function(editLocation) {

  for (var i = 0; i < _locations.length; i++) {
    if (_locations[i].id === editLocation.id) {
      _locations[i] = editLocation
    }
  }
  _location = editLocation
};

var deleteLocation = function(deleteLocation) {

  for (var i = 0; i < _locations.length; i++) {
    if (_locations[i].id == deleteLocation) {
      _locations.splice(i, 1)
    }
  }
  if(_locations.length > 0)
    _location = _locations[0];
  else
    _location = null;
};

LocationStore.getLocations = function (){
  return _locations
};

LocationStore.getLocation = function (){
  return _location
};

LocationStore.getLocationById = function (id) {
  _locations.forEach(function(location) {
    if (location.id === id) {
      return location
    }
  })
};

LocationStore.__onDispatch = function(payload){

  switch(payload.actionType) {
    case LocationConstants.RECEIVE_LOCATION:
      receiveLocation(payload.location)
      setLocation(payload.location)
      LocationStore.__emitChange()
      break;
    case LocationConstants.RECEIVE_LOCATIONS:
      receiveLocations(payload.data)
      let current_location_id = payload.current_location_id
      if (payload.data.length == 0) {
        _location = {}
        localStorage.removeItem("shyft/event/new/location")
      } else {
        //load locations
        receiveLocations(payload.data)
        //read saved locations
        var savedLocation = localStorage.getItem("shyft/event/new/location")

        if (current_location_id != null) {
          var index = _.findIndex(payload.data, function(o){return o.id == current_location_id})
          savedLocation = payload.data[index]
        } else {
          if (typeof savedLocation === "undefined") {
            savedLocation = null;
          } else {

            savedLocation = JSON.parse(savedLocation)
            if (typeof savedLocation === "undefined"){
              savedLocation = null;
            }
          }  
        }
        
        if (savedLocation != null){
          //check validtity of saved location
          var isRight = payload.data.find(function(data){
            return data.id == savedLocation.id
          })
          if(isRight != null){
            setLocation(savedLocation)
          } else {
            //still we need to set default location
            if(_locations.length>0){
              setLocation(_locations[0])  
            }  
          }
        }else {
          //if no location is saved as current, we choose very first one
          if(_locations.length>0){
            setLocation(_locations[0])  
          }  
        }
      }
      LocationStore.__emitChange()
      break;
    case LocationConstants.RECEIVE_EDIT_LOCATION:
      editLocation(payload.location)
      LocationStore.__emitChange()
      break;
    case LocationConstants.SET_LOCATION:
      setLocation(payload.location)
      LocationStore.__emitChange()
      break;
    case LocationConstants.RECEIVE_DELETE_LOCATION:
      deleteLocation(payload.location)
      LocationStore.__emitChange()
      break;
  }
};

module.exports = LocationStore;
