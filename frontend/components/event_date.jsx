import  {Component, PropTypes} from 'react';

import ShiftsContainer from './shifts/shifts_container';
import EventDateUtil from '../utils/eventDateUtil';
import DateUtil from '../utils/dateUtil';

export default class EventDate extends Component {
  constructor(props){
    super(props);
    this.state = {
      event_date: this.props.event_date,
      shifts: [],
      hover_ambassador: this.props.hover_ambassador
    };
    this.removeDate = this.removeDate.bind(this);
    this.getShiftsData = this.getShiftsData.bind(this);
    this.renderShiftsContainer = this.renderShiftsContainer.bind(this);
    this.renderDate = this.renderDate.bind(this);
  }

  componentDidMount() {
    this.getShiftsData(this.props.event_date.id)
  }

  componentWillReceiveProps(nextProps) {
    this.getShiftsData(nextProps.event_date.id)
  }

  componentWillUnmount() {
    this.datesRequest.abort();
  }

  removeDate() {
    //should come with ajax request to remove dates and shifts
    EventDateUtil.deleteEventDate(this.props.event_date, (data)=>{this.props.handleRemoveDate(data);})
  }

  getShiftsData(dateId) {

    this.datesRequest = $.ajax({
      type: 'GET',
      url: '/shiftsByDate',
      data: {date_id: dateId}
    })
    .done(function(data) {
      this.setState({shifts: data.shifts})
    }.bind(this))
      .fail(function(jqXhr) {
      this.setState({shifts: []})
    }.bind(this));
  }

  renderShiftsContainer() {
    return <ShiftsContainer
        event_date={this.props.event_date}
        shifts={this.state.shifts}
        event={this.props.event}
        hover_ambassador = {this.state.hover_ambassador}
        handleAddShift={this.props.handleAddShift} />
  }

  renderDate() {
    
    var current = this.props.event_date.event_date
    return DateUtil.renderDateWithoutTZ(current)
  }

  render() {
    //
    return(
      <div className="col-md-4 col-centered eventItem">
        <div className="item" id={this.props.event_date ? 'eventDate' : null}>
            <div className="theshizz rows">              
              <div>
                {this.renderDate()}
                <span className="remove">
                  <a className = 'btn'
                     id = 'add-location-btn'
                     onClick = {this.removeDate}>
                    <span className = 'glyphicon glyphicon-remove'></span>
                  </a>
                </span>
              </div>
              
            </div>
            <div className="rows">
              {this.renderShiftsContainer()}
            </div>
        </div>
      </div>
    );
  }
}