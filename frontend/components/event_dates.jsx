import  {Component, PropTypes} from 'react';

import EventDate from './event_date';
import AmbassadorStore from '../stores/ambassadorStore';
//import DatePicker from 'react-bootstrap-date-picker';
import DatePicker from 'react-datepicker';
import moment from 'moment';
import RolesPopup from './role/rolesPopup';
import ShiftModalForm from './shifts/shift_modal_form';

export default class EventDates extends Component {
  constructor(props){
    super(props);
    this.state = {
      event_dates: this.props.event_dates,
      hover_ambassador: this.props.hover_ambassador,
      location: this.props.location,
      hidden: this.props.hideDatePicker,
      eventDate: moment()
    };

    this.handleAddShift = this.handleAddShift.bind(this);
    this.handleRemoveDate = this.handleRemoveDate.bind(this);
    this.handleScroll = this.handleScroll.bind(this);
    this.renderAddDateButton = this.renderAddDateButton.bind(this);
    this.handleAddDateButton = this.handleAddDateButton.bind(this);
    this.renderDatePicker = this.renderDatePicker.bind(this);
    this.removeDatePicker = this.removeDatePicker.bind(this);
    this.handleChange = this.handleChange.bind(this);
  }
  
  componentWillReceiveProps(nextProps) {
    this.state ={
      event_dates: nextProps.event_dates,
      hover_ambassador: nextProps.hover_ambassador,
      hidden: nextProps.hideDatePicker
    };
  }

  componentDidUpdate(prevProps, prevState){
    if ($('.react-datepicker__input-container').length > 0)
      $('.react-datepicker__input-container')[0].childNodes[0].focus()

  }
  handleAddShift(date, callback) {
    
    ReactDOM.render(<ShiftModalForm key={date.id} event_date={date} shift_id={''} callback={callback}/>, document.getElementById('shiftModalFormContainer'));
    $('#shiftModalForm').modal()
  }

  handleRemoveDate(e){
    this.props.handleRemoveDate(e);
  }

  handleScroll(e) {
    e.preventDefault();
    var element = $('.eventDatesInnerContainer')
    var windowSize = element.width();
    //
    if (e.target.id === "left") {

        $('.eventDatesInnerContainer').animate({scrollLeft: element.scrollLeft() - 950}, 800);
    } else if (e.target.id === "right"){

        $('.eventDatesInnerContainer').animate({scrollLeft: element.scrollLeft() + 950}, 800);
    }

  }

  renderAddDateButton() {
    return (
        <div className="date-button">
          <a onClick={this.handleAddDateButton}>
          <span className="glyphicon glyphicon-plus"></span>
          <p>Add Date</p>
          </a>
        </div>
    );
  }

  handleAddDateButton() {
    if (this.state.hidden === true) {
      this.setState({hidden: false})

    } else {
      this.setState({hidden: true})
    }
  }

  removeDatePicker(){
    this.setState({hidden: true});
  }

  handleChange(date) {
    this.setState({
      eventDate: date
    });
    this.props.handleAddDate(date);
  }


  renderDatePicker() {
    let checkedDates = this.props.event_dates.map(function(date){return date.event_date });
    var noDate = (this.props.event_dates.length == 0) ? (<h3>You need to add a date
            </h3>) : null
    return  (!this.state.hidden) ?
        (
            <div className='datePickerContainer'>
              <DatePicker
                  selected={this.state.eventDate}
                  onChange={this.handleChange}
                  excludeDates = {checkedDates}
                  placeholderText="Click to select a date"
                  minDate={moment()}
                  />    
              <div className="remove">
                <a className = 'btn'
                   id = 'add-location-btn'
                   onClick = {this.removeDatePicker}>
                  <span className = 'glyphicon glyphicon-remove'></span>
                </a>
              </div>    
            </div>):
        (
        <div className="row">
          <div className="row">
            {noDate}
            {this.renderAddDateButton()}
          </div>
        </div>
    );
  }

  render() {
    if (this.props.event_dates.length > 0) {
      return (
        <div>
          <div className="row eventDatesContainer">
            <div className="col center chevron" onClick={this.handleScroll}>
              <i className="fa fa-chevron-left fa-5x" id="left" aria-hidden="true"></i>
            </div>
            <div className="row row-centered eventDatesInnerContainer">
            {this.props.event_dates.map((date) => {
              return <EventDate
                  key={date.id}
                  event_date={date}
                  event={this.props.event}
                  hover_ambassador = {this.state.hover_ambassador}
                  handleAddShift={this.handleAddShift}
                  handleRemoveDate = {this.handleRemoveDate}
              />
            })}
              {this.renderDatePicker()}
            </div>
            <div className="col center chevron" onClick={this.handleScroll}>
              <i className="fa fa-chevron-right fa-5x" id="right" aria-hidden="true"></i>
            </div>
          </div>
          <div className="row" id="shiftModalFormContainer">
          </div>

          <div className="row" id="fucker">
          </div>  
            
        </div>
      );
    } else {
      return (
          <div className="row">
            
            {this.renderDatePicker()}
          </div>
      );
    }
  }
}