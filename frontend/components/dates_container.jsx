import {Component, PropTypes} from 'react';
import EventDates from './event_dates';
import moment from 'moment';
import EventDateAction from '../actions/eventDateAction';
import EventDateStore from '../stores/eventDateStore';
import LocationStore from '../stores/locationStore';
import RoleStore from '../stores/roleStore';
import RolesPopup from './role/rolesPopup';
import update from 'react-addons-update';
import _ from 'lodash';

export default class DatesContainer extends Component{

  constructor(props){
    super(props)
    this.state = {
      event_dates: EventDateStore.getEventDates(),
      hideDatePicker: true,
      location: this.props.location,
      hover_ambassador: EventDateStore.getHoverAmbassador(),
      showPopup: false
    };

    this.onRoleChange = this.onRoleChange.bind(this);
    this.onAddEventDate = this.onAddEventDate.bind(this);
    this.onEventDateChange = this.onEventDateChange.bind(this);
    this.onUpdateEventDate = this.onUpdateEventDate.bind(this);
    this.onDeleteEventDate = this.onDeleteEventDate.bind(this);
    this.handleDateSelected = this.handleDateSelected.bind(this);
    this.renderEventDates = this.renderEventDates.bind(this);
    this.renderRolePopup = this.renderRolePopup.bind(this);
  }
  
  componentDidMount() {
    this.eventDateListener = EventDateStore.addListener(this.onEventDateChange)
    this.roleListener = RoleStore.addListener(this.onRoleChange)
  }

  componentWillUnmount() {
    this.eventDateListener.remove();
    this.roleListener.remove()
  }

  onEventDateChange() {
    this.setState({
      event_dates: EventDateStore.getEventDates(),
      hover_ambassador: EventDateStore.getHoverAmbassador
    })
  }

  onRoleChange() {
    var addRoleShift = RoleStore.getAddRoleShift()
    if(addRoleShift != null){
      this.setState({showPopup: true})
    } else {
      this.setState({showPopup: false})
    }
  }

  componentDidUpdate(prevProps, prevState) {
    if(this.state.showPopup){
      $('#rolePopupModalForm').modal()
    } else {
      $('#rolePopupModalForm').modal('hide')
    }        
  }

  componentWillReceiveProps(nextProps) {
    /*
    if(nextProps.location != null){
      this.setState({
        location: nextProps.location
      })
    }*/
  }

  onAddEventDate(date) {
    var event_dates = update(this.state.event_dates, {$push: [date]})
    this.setState({event_dates: event_dates})
  }

  onDeleteEventDate(data) {
    for(var index = 0; index < this.state.event_dates.length; index ++){
      if(this.state.event_dates[index].id == data.id){
        var event_dates = update(this.state.event_dates, {$splice:[[index, 1]]})
      }
    }
    this.setState({event_dates:event_dates})
  }

  onUpdateEventDate(date, newDate) {
    var index = this.state.event_dates.indexOf(date)
    var event_dates = update(this.state.event_dates, { $splice: [[index, 1, newDate]]})
    this.setState({event_dates: event_dates})
  }

  handleDateSelected(moment) {
    // 
    //var date = moment.locale()._d
    
    if(moment == null)
        return;

    var date = moment.format('YYYY-MM-DD');
    var data = {'event_date': {'event_date':date, 'event_location_id':this.props.location.id}}
    // Submit form via jQuery/AJAX
    //EventDateAction.createEventDate(data);
    $.ajax({
      type: 'POST',
      url: '/eventDate/create',
      data: data
    })
    .done(function(data) {
      //this.props.handleNewDate(data)
      this.onAddEventDate(data)
    }.bind(this))
    .fail(function(jqXhr) {
    }.bind(this));
  }

  renderEventDates() {
    return <EventDates
        location = {this.props.location}
        event ={this.props.event}
        event_dates={this.state.event_dates}
        hover_ambassador={this.props.hover_ambassador}
        handleRemoveDate = {this.onDeleteEventDate}
        handleAddDate = {this.handleDateSelected}
        hideDatePicker = {this.state.hideDatePicker}
    />
  }

  renderRolePopup() {
    return (this.state.showPopup || true) ? (
    <div className="row" id="rolePopupModal">
      <RolesPopup showPopup = {this.state.showPopup}/>
    </div> ): null;
  }

  render() {
    if(!_.isEmpty(this.props.location)){
      return (
          <div className="datesContainer">
            {this.renderEventDates()}
            <div id="rolePopupContainer">
              {this.renderRolePopup()}
            </div>    
          </div>
      )
    } else {
      return null;
    }

  }
}