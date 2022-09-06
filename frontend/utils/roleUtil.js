var RoleUtil = {

  getRoleTypes: function(callback) {
    $.ajax({
      url: "/roleTypes",
      method: "GET",
      success: function (data) {
        callback(data);
      },
      error: function(error,status) {
      }
    })
  },
  /**
   *
   * @param data
   * @param receiveRole callback
     */
  createRole: function(data, receiveRole) {

    $.ajax({
      url: "/shifts/createRole",
      method: "POST",
      data: data,

      success: function (response) {

        receiveRole(response.data, response.shift_id);
      },
      error: function(error,status) {

      }
    })
  },
  /**
   *
   * @param data
   * @param deleteRole callback
     */
  deleteRole: function(data, deleteRole) {

    $.ajax({
      url: "/roles/" + data.id,
      method: "DELETE",
      data: { date: data},
      success: function (response) {

        deleteRole(response.data);

      },
      error: function(error,status) {

      }
    })
  },

};

module.exports = RoleUtil;
