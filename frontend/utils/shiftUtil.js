var ShiftUtil = {

  getShiftByDates: function(callback) {
    $.ajax({
      url: "shiftsByDate/",
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
   * @param receiveShift callback
     */
  createShift: function(data, receiveShift) {

    $.ajax({
      url: "/shifts/create",
      method: "POST",
      data: data,

      success: function (data) {

        receiveShift(data);
      },
      error: function(error,status) {

      }
    })
  },
  /**
   *
   * @param data
   * @param deleteShift callback
     */
  deleteShift: function(data, deleteShift) {

    $.ajax({
      url: "/shifts/" + data.id,
      method: "DELETE",
      data: { date: data},
      success: function (response) {

        deleteShift(response.data);

      },
      error: function(error,status) {

      }
    })
  },

};

module.exports = ShiftUtil;
