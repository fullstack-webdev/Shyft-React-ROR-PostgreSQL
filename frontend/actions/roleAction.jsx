var RoleUtil = require('../utils/roleUtil');
var RoleConstants = require('../constants/roleConstants');
var Dispatcher = require('../dispatcher/dispatcher');

var RoleAction = {
  getRoleTypes: function() {
    RoleUtil.getRoleTypes(this.onGetRoleTypes)
  },
  selectRole: function(data){
    Dispatcher.dispatch({
      actionType: RoleConstants.SELECT_ROLE,
      data: data
    })
  },
  onGetRoleTypes: function(data) {
    Dispatcher.dispatch({
      actionType: RoleConstants.RECEIVE_ROLE_TYPES,
      data: data
    });
  },
  addRolePopup: function(shift_id){
    Dispatcher.dispatch({
      actionType: RoleConstants.ADD_ROLE_POPUP,
      data:  shift_id
    })
  },
  removeRolePopup: function(role){
    Dispatcher.dispatch({
      actionType: RoleConstants.REMOVE_ROLE_POPUP,
      data: role
    })
  },
  addRole: function (role, shift_id){
    Dispatcher.dispatch({
      actionType: RoleConstants.ADD_ROLE,
      data: {
        role: role,
        shift_id: shift_id
      }
    })
  },
  clearAddedRole: function (role){
    Dispatcher.dispatch({
      actionType: RoleConstants.CLEAR_ADDED_ROLE,
      data: {
        role: role
      }
    })
  }
};

module.exports = RoleAction;
