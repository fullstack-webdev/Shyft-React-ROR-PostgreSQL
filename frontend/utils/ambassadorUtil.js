var AmbassadorUtil = {

  fetchAllAmbassadors: function(receiveAmbassadors) {
    //
    
    // $.ajax({
    //   url: "/filterAmbassadors",
    //   method: "GET",
    //   success: function (data) {
    //     //
    //     
    //     receiveAmbassadors(data);
    //     // this.props.handleNewEvent(data),
    //     // will create event store instead and have event component listen to it
    //   },
    //   error: function(error,status) {
    //
    //   }
    // })
  },

  fetchFilteredAmbassadors: function(filters, locationId, receiveAmbassadors) {
    
    $.ajax({
      url: "/filterAmbassadorsIndex",
      method: "GET",
      data: {
        filters: filters,
        location_id: locationId
      },
      success: function (data) {
        
        receiveAmbassadors(data);
        // this.props.handleNewEvent(data),
        // will create event store instead and have event component listen to it
      },
      error: function(error,status) {

      }
    })
  },

  fetchAmbassadorsByRole: function(role, receiveAmbassadors) {
    
    $.ajax({
      url: "/filterForRole",
      method: "GET",
      data: {
        role_id: role.id
      },
      success: function (data) {
        
        receiveAmbassadors(data);
        // this.props.handleNewEvent(data),
        // will create event store instead and have event component listen to it
      },
      error: function(error,status) {

      }
    })
  },

  getShortListedAmbassadors: function(event_id, receiveBookedAmbassadors){
    $.ajax({
      url: "/getShortListedAmbassadors",
      method: "GET",
      data: {
        event_id: event_id
      },
      success: function(data){
        receiveBookedAmbassadors(data)
      },
      error: function(error, status){

      }
    })
  },

  bookAmbassadorForRole: function(role, ambassadorData, cb){
    
    $.ajax({
      url: "/shortList/add",
      method: "PATCH",
      data:{
        role_ids: role.role.id,
        ambassador_id: ambassadorData.ambassador.id
      },
      success: function( data){
        
        cb(ambassadorData, role)
      },
      error: function(error, status){
        
      }
    })
  },

  removeAmbassadorForRole: function(role, cb){
    
    $.ajax({
      url: "/shortList/removeAmbassador",
      method: "DELETE",
      data:{
        role_id: role.role.id
      },
      success: function( data){
        
        cb(data)
      },
      error: function(error, status){
        
      }
    })
  }
};

module.exports = AmbassadorUtil;
