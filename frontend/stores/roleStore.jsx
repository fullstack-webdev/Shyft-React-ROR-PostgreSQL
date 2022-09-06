var Store = require('flux/utils').Store;
var Dispatcher = require('../dispatcher/dispatcher');
var RoleConstants = require('../constants/roleConstants');
var RoleStore = new Store(Dispatcher);

var _roleTypes = [];
var _selectedRole = null
var _addRoleShift = null
var _addedRoleData = null
var _selectedShift = null

var selectRole = function(data) {
    _selectedRole = (data != null && data.role) ? data.role : null
    _selectedShift = ( data != null && data.shift) ? data.shift : null
};

var addRoleShift = function(shift_id){
  _addRoleShift = shift_id
}

var removeRoleShift = function() {
  _addRoleShift = null
}

var setAddedRoleData = function(data) {
  _addedRoleData =  data
}

var clearAddedRoleData = function() {
  _addedRoleData = null
}

RoleStore.selectedRole = function() {
  return _selectedRole;
};

RoleStore.getAddRoleShift = function() {
  return _addRoleShift
}

RoleStore.getAddedRoleData = function() {
  return _addedRoleData
}

var onGetRoleTypes = function (data) {
  _roleTypes = data;
};

RoleStore.roleTypes = function (){
  return _roleTypes
};

RoleStore.__onDispatch = function(payload){
  switch(payload.actionType) {
    case RoleConstants.RECEIVE_ROLE_TYPES:
      onGetRoleTypes(payload.data)
      RoleStore.__emitChange()
      break;
    case RoleConstants.SELECT_ROLE:
      selectRole(payload.data)
      
      if(payload.data != null && payload.data.ambassador == null){
        RoleStore.__emitChange()
      }

      break;
    case RoleConstants.ADD_ROLE_POPUP:
      
      addRoleShift(payload.data)
      RoleStore.__emitChange()
      break;
    case RoleConstants.REMOVE_ROLE_POPUP:
      
      removeRoleShift()
      RoleStore.__emitChange()
      break;
    case RoleConstants.ADD_ROLE:
      
      setAddedRoleData(payload.data)
      RoleStore.__emitChange()
      break;  
    case RoleConstants.CLEAR_ADDED_ROLE:
      
      clearAddedRoleData()
      RoleStore.__emitChange()
      break;        
  }
};

module.exports = RoleStore;
