import {Component, PropTypes} from 'react';
import moment from 'moment';
import DateDropdown from '../common/date_dropdown';

export default class ShiftModalForm extends Component {
  constructor(props){
    super(props);
    this.state = {
      startTime:'', 
      endTime:'', 
    };
    this.isNewShift  = this.isNewShift.bind(this);
    this.formatTimeFromDropdown = this.formatTimeFromDropdown.bind(this);
    this.onAddShift = this.onAddShift.bind(this);
    this.handleAddShift  = this.handleAddShift.bind(this);
    this.handleClose = this.handleClose.bind(this);
    this.handleSaveShift = this.handleSaveShift.bind(this);
    this.handleStartTimeChanged = this.handleStartTimeChanged.bind(this);
    this.handleEndTimeChanged = this.handleEndTimeChanged.bind(this);
    this.renderStartTimePicker = this.renderStartTimePicker.bind(this);
    this.renderEndTimePicker = this.renderEndTimePicker.bind(this);
    this.valid = this.valid.bind(this);
    this.renderValid = this.renderValid.bind(this);
  }

  valid() {
    
    var endTime = moment(this.state.endTime, "hh:mm:ss");

    var startTime = moment(this.state.startTime,"hh:mm:ss");
    var duration = Math.abs(endTime.diff(startTime, 'minutes'));

    return startTime.isValid() && endTime.isValid() &&  duration >=120;
  }

  renderValid(){
    
      return  (!this.valid()) ? <div className="error">Invalid shift range. It should be minimum 2hours.</div> : null;
  }
  
  isNewShift() {
    return this.props.shift_id
  }

  formatTimeFromDropdown(data) {
    var hours = data.hours
    var minutes = data.minutes
    if (data.ampm === "PM") {
      if (hours != "12") {
        var newHours = Number(hours) + 12
        hours = String(newHours)
      }
    } else {
      if (hours === "12") {
        hours = "0"
      }
    }

    return hours + ":" + minutes
  }

  componentDidMount() {
    
    this.setState({
      startTime: '12:00',
      endTime: '12:00'
    })
  }

  componentWillUnmount() {
  }

  onAddShift(data) {
    
    this.props.callback(data)
    this.handleClose()
  }

  onDeleteShift(shift, data) {
  }

  onUpdateShift(shift, newData) {
  }

  handleAddShift() {
    //convert string to local Time
    var startTime = moment(this.state.startTime, 'HH:mm').format()
    var endTime = moment(this.state.endTime, 'HH:mm').format()

    var data = {'event_date_shift': {'start_time':startTime, 'end_time':endTime, 'date_id':this.props.event_date.id}, 'date_id':this.props.event_date.id}

    // Submit form via jQuery/AJAX
    $.ajax({
      type: 'POST',
      url: '/shifts/create',
      data: data
    })
    .done(function(data) {
      // this.props.handleNewDate(data)
      this.onAddShift(data)
    }.bind(this))
    .fail(function(jqXhr) {
    }.bind(this));
  }

  handleClose() {
    $('#shiftModalForm').modal('hide')
  }

  handleSaveShift() {
    
    if(this.valid()){
      this.handleAddShift()  
    } else {
      this.forceUpdate();
    }
  }

  handleStartTimeChanged(data) {
    
    var startTime = this.formatTimeFromDropdown(data)
    this.setState({startTime:startTime})
  }

  handleEndTimeChanged(data) {
    
    var endTime = this.formatTimeFromDropdown(data)
    this.setState({endTime:endTime})
  }

  renderStartTimePicker() {
      return <DateDropdown id='startTimePicker' valueChanged={this.handleStartTimeChanged}/>
  }

  renderEndTimePicker() {
      return <DateDropdown id='endTimePicker' valueChanged={this.handleEndTimeChanged}/>
  }

  render() {
    return (
      <div id="shiftModalForm" className="modal fade" role="dialog">
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <button type="button" className="close" data-dismiss="modal">&times;</button>
              <h4 className="modal-title" align="center">Add a Start and End Time</h4>
            </div>
            <div className="modal-body">
              <div className="form">

                <div className="panel">
                  <div className="panel-body">
                    <div className="col-sm-6">
                      <h4>Start Time:</h4>{this.renderStartTimePicker()}
                    </div>
                    <div className="col-sm-6">
                      <h4>End Time:</h4>{this.renderEndTimePicker()}
                    </div>
                  </div>
                </div>
              </div>
            </div>
            {this.renderValid()}
            <div className="modal-footer center">
              <button type="submit" className="btn btn-small" id="book-btn" onClick={this.handleSaveShift}>Add</button>
            </div>
          </div>
        </div>
      </div>
    )
  }
}