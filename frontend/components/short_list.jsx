import {Component, PropTypes} from 'react';
import Event from './event';
import DatesContainer from './dates_container';
import FilterNotification from './filter_notification';
import EventAction from '../actions/eventAction';
import EventDateAction from '../actions/eventDateAction';
import LocationAction from '../actions/locationAction';
import AmbassadorAction from '../actions/ambassadorAction';
import AmbassadorsContainer from './ambassador/ambassador_container';
import EventLocations from './event_locations';
import EventStore from '../stores/eventStore';
import AmbassadorStore from '../stores/ambassadorStore';
import LocationStore from '../stores/locationStore';

export default class ShortList extends Component {
  constructor(props){
    super(props);
    this.state =  {
      event: EventStore.getEvent(),
      ambassadors: AmbassadorStore.getAmbassadors(),
      location_data: LocationStore.getLocations(),
      location: LocationStore.getLocation(),
      selectedDate: null,
      selectedShift: null,
      selectedRole: null
    };

    //bind methods
    this._onEventChange = this._onEventChange.bind(this);
    this._onLocationChange = this._onLocationChange.bind(this);
    this._onAmbassadorChange = this._onAmbassadorChange.bind(this);
    this.renderAmbassadors = this.renderAmbassadors.bind(this);
  }

  componentDidMount() {
    this.eventListener = EventStore.addListener(this._onEventChange)
    this.ambassadorListener = AmbassadorStore.addListener(this._onAmbassadorChange)
    this.locationListener = LocationStore.addListener(this._onLocationChange)
    //read newly created event for the first time
    EventAction.fetchEvent();
  }

  componentWillUnmount() {
      this.eventListener.remove()
      this.ambassadorListener.remove()
      this.locationListener.remove()

  }

  _onLocationChange() {
    var newLocation = LocationStore.getLocation()
    var invalidLocation = newLocation == null || typeof newLocation == 'undefined' || Object.keys(newLocation).length === 0
    this.setState({
      location_data: LocationStore.getLocations()
    })

    if(!invalidLocation){
      this.setState({
        location: newLocation
      })
      //read event dates...
      EventDateAction.fetchEventDates({event_location_id: newLocation.id})

    }

  }

  _onEventChange() {
    debugger
    this.setState({
      event: EventStore.getEvent(),
    })
    //read locations...
    LocationAction.fetchLocations({event_id: this.state.event.id, current_location_id: this.state.event.current_location_id})
    //get booked ambassadors
    AmbassadorAction.fetchShortListedAmbassadors(this.state.event.id)
  }

  _onAmbassadorChange() {
    this.setState({
      ambassadors: AmbassadorStore.getAmbassadors()
    })
  }

  renderEventLocations() {
    return
    // return <EventLocations/>
  }

  renderAmbassadors() {
    return <AmbassadorsContainer/>
  }

  render() {
    return (
      <div>
        <div className="dates-section">
          <div className="row container">
            <div className="col-sm-4 col-md-4 event-container">
              <Event event={this.state.event}/>
            </div>
            <div className="col-sm-8 col-md-8">
              <EventLocations
                  event={this.state.event}
                  location_data={this.state.location_data}
                  location={this.state.location}/>
            </div>
          </div>
          <div className="row container">
            <DatesContainer event={this.state.event} location={this.state.location}/>
          </div>
        </div>
        <div className="ambassadors-section">
          <div className="row container unselectable">
            <FilterNotification event_date={this.state.selectedDate}
                                  role={this.state.selectedRole}
                                  shift={this.state.selectedShift}
                                  location={this.state.location}/> 
            {this.renderAmbassadors()}
          </div>  
        </div>
      </div>
    );
  }
}
