var EventShiftUtil = {

    createEventShift: function(data, receiveEventShift) {

        $.ajax({
            url: "/shifts/create",
            method: "POST",
            data: data,

            success: function (data) {

                receiveEventShift(data);
            },
            error: function(error,status) {

            }
        })
    },

    deleteEventShift: function(data, deleteEventShift) {

        $.ajax({
            url: "/shifts/" + data.id,
            method: "DELETE",
            data: { date: data},
            success: function (response) {

                deleteEventShift(response.data);

            },
            error: function(error,status) {

            }
        })
    },

};

module.exports = EventShiftUtil;
