// var FilterUtil = require('../utils/filterUtil');
var FilterConstants = require('../constants/filterConstants');
var Dispatcher = require('../dispatcher/dispatcher');


var FilterActions = {

  updatePriceRange: function(value) {
    Dispatcher.dispatch({
      actionType: FilterConstants.UPDATE_PRICE_RANGE,
      priceRange: value
    });
  },

}

module.exports = FilterActions;
