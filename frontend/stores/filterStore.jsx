var Store = require('flux/utils').Store;
var Dispatcher = require('../dispatcher/dispatcher');
var FilterConstants = require('../constants/filterConstants');
var FilterStore = new Store(Dispatcher);

var _event = {
  price: {
    min: 10,
    max: 50
  },

};

var receivePrice = function (priceRange) {
  _event.price = {
    min: priceRange.min,
    max: priceRange.max
  }

};

FilterStore.getFilters = function (){
  return _event
};

FilterStore.__onDispatch = function(payload){
  switch(payload.actionType) {
    case FilterConstants.UPDATE_PRICE_RANGE:
    receivePrice(payload.priceRange)
    FilterStore.__emitChange()
    break;
  }
};

module.exports = FilterStore;
