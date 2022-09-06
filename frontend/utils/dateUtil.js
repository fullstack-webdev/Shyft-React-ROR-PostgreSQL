var DateUtil = {
  renderDateWithTZ: function(raw_date){
    debugger
    var weekdays = {
      0: "Sunday",
      1: "Monday",
      2: "Tuesday",
      3: "Wednesday",
      4: "Thursday",
      5: "Friday",
      6: "Saturday"
    }

    var months = {
      0: "Jan.",
      1: "Feb.",
      2: "Mar.",
      3: "Apr.",
      4: "May",
      5: "June",
      6: "July",
      7: "Aug.",
      8: "Sept.",
      9: "Oct.",
      10: "Nov.",
      11: "Dec."
    }
    var current = raw_date

    var dateOriginal = new Date(current)
    //var userTimezoneOffset = new Date().getTimezoneOffset()*60000;
    // var date = new Date(dateOriginal.getTime() + userTimezoneOffset);
    var date = dateOriginal //as dateOriginal has TZ info, we don't need to add TZ offesest
    var day = weekdays[date.getDay()]
    var month = months[date.getMonth()]
    var dayNum = this.paddedDate(date.getDate())
    return day + ", " + month + " " + dayNum
  },

  renderDateWithoutTZ: function(raw_date){
    debugger
    var weekdays = {
      0: "Sunday",
      1: "Monday",
      2: "Tuesday",
      3: "Wednesday",
      4: "Thursday",
      5: "Friday",
      6: "Saturday"
    }

    var months = {
      0: "Jan.",
      1: "Feb.",
      2: "Mar.",
      3: "Apr.",
      4: "May",
      5: "June",
      6: "July",
      7: "Aug.",
      8: "Sept.",
      9: "Oct.",
      10: "Nov.",
      11: "Dec."
    }
    var current = raw_date

    var dateOriginal = new Date(current)
    var userTimezoneOffset = new Date().getTimezoneOffset()*60000;
    var date = new Date(dateOriginal.getTime() + userTimezoneOffset);
    //var date = dateOriginal //as dateOriginal has TZ info, we don't need to add TZ offesest
    var day = weekdays[date.getDay()]
    var month = months[date.getMonth()]
    var dayNum = this.paddedDate(date.getDate())
    return day + ", " + month + " " + dayNum
  },

  paddedDate: function(date) {
    var lastDigit = String(date)[String(date).length-1]
    if (date === 11 || date === 12 || date === 13) {
      return date + "th"
    } else if (lastDigit === "1") {
      return date + "st"
    } else if (lastDigit === "2") {
      return date + "nd"
    } else if (lastDigit === "3") {
      return date + "rd"
    } else {
      return date + "th"
    }
  },

  paddedHour: function(time) {
    if (time === 0) {
      return "12"
    } else if (time > 12) {
      return time - 12 + ""
    } else {
      return time + ""
    }
  },

  paddedMinute: function(time) {
    if (time === 0) {
      return ""
    }
    else if (time < 10) {
      return ":0" + time
    } else {
      return ":" + time
    }
  },

  ampm: function(time) {
    if (time < 12) {
      return "AM"
    } else {
      return "PM"
    }
  },
   
  renderTime: function(strTime){
    var _time = new Date(strTime)
    return this.paddedHour(_time.getHours()) + this.paddedMinute(_time.getMinutes()) + this.ampm(_time.getHours())
  }  

};

module.exports = DateUtil;
