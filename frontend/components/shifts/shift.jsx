import {Component, PropTypes} from 'react';

import RolesContainer from '../role/roles_container';
import EventShiftUtil from '../../utils/eventShiftUtil';
import DateUtil from '../../utils/dateUtil';
import AmbassadorAction from '../../actions/ambassadorAction';
export default class Shift extends Component {
  constructor(props){
    super(props);
    this.state = {
      event_date_shift: this.props.event_date_shift,
      roles:[], render: "",
      hover_ambassador: this.props.hover_ambassador
    };
    this.removeShift = this.removeShift.bind(this);
    this.getRolesData = this.getRolesData.bind(this);
    this.renderRolesContainer = this.renderRolesContainer.bind(this);
    
  }
  
  componentDidMount() {
    this.getRolesData(this.props.event_date_shift.id)
  }

  componentWillReceiveProps(nextProps) {
    this.getRolesData(nextProps.event_date_shift.id)
  }

  componentWillUnmount() {
    this.datesRequest.abort();
  }

  removeShift(){
    //should come with ajax request to remove dates and shifts
    EventShiftUtil.deleteEventShift(this.props.event_date_shift, (data)=>{
      this.props.handleRemoveShift(data);
      //remove any booked ambassadors
      //get booked ambassadors
      AmbassadorAction.fetchShortListedAmbassadors(this.props.event.id)
    })
  }

  getRolesData(shiftId) {
    this.datesRequest = $.ajax({
      type: 'GET',
      url: '/rolesByShift',
      data: {shift_id: shiftId}
    })
    .done(function(data) {
      this.setState({roles: data.roles})
    }.bind(this))
    .fail(function(jqXhr) {
      this.setState({roles: []})
    }.bind(this));
  }

  renderRolesContainer() {
    return <RolesContainer
        shift={this.props.event_date_shift}
        roles={this.state.roles}
        handleAddRole={this.props.handleAddRole}
        hover_ambassador={this.state.hover_ambassador} />
  }

  render() {
    var hasRoles = this.renderRolesContainer().props.roles.length === 0 ? "col" : "rows"
    return(
      <div className={"" + hasRoles} id={this.props.event_date_shift ? 'eventShift' : null}>
        <div className="rows">
          {DateUtil.renderTime(this.props.event_date_shift.start_time)} - {DateUtil.renderTime(this.props.event_date_shift.end_time)} 
          <span className="remove">
            <a className = 'btn'
               id = 'add-location-btn'
               onClick = {this.removeShift}>
              <span className = 'glyphicon glyphicon-remove'></span>
            </a>
          </span>
        </div>
        {this.renderRolesContainer()}
      </div>
    );
  }
}