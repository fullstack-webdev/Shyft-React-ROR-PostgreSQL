import  {Component, PropTypes} from 'react';
import EventStore from '../stores/eventStore';
import AmbassadorStore from '../stores/ambassadorStore';
import LocationForm from './location_form';
import LocationAction from '../actions/locationAction';
import EventAction from '../actions/eventAction';
import FormSelect from './common/form_select';

export default class EventLocations extends Component {

  constructor(props){
    super(props);
    this.state = {
      edit: false,
      locations: this.props.location_data,
      event: this.props.event,
      location: this.props.location,
      hasShortListedAmbassadors: AmbassadorStore.hasShortListedAmbassadors()
    };
    this.handleAddLocation = this.handleAddLocation.bind(this);
    this.renderEditLocationForm = this.renderEditLocationForm.bind(this);
    this.renderAddLocationForm = this.renderAddLocationForm.bind(this);
    this.renderLocationItems = this.renderLocationItems.bind(this);
    this.renderLocationItemOptions = this.renderLocationItemOptions.bind(this);
    this.renderLocationInfo = this.renderLocationInfo.bind(this);
    this.onLocationSelected = this.onLocationSelected.bind(this);
    this.onEditLocation = this.onEditLocation.bind(this);
    this._onAmbassadorChange = this._onAmbassadorChange.bind(this);
    this.onSubmit = this.onSubmit.bind(this);
  }
  
  componentDidMount() {
    this.ambassadorListener = AmbassadorStore.addListener(this._onAmbassadorChange)     
  }

  componentWillUnmount() {
    this.ambassadorListener.remove()
  }

  componentWillReceiveProps(nextProps) {
      if(nextProps.location_data.length > this.props.location_data.length){
        this.setState({locations: nextProps.location_data})
      }  
  }
  
  _onAmbassadorChange() {
    this.state.hasShortListedAmbassadors = AmbassadorStore.hasShortListedAmbassadors();
  }

  renderAddLocationForm() {
    // 
    return (
      <LocationForm
        key = 'addLocation'
        event = {this.state.event}
        modalId = 'newLocationModal'/>
    )
  }

  renderEditLocationForm() {

    // these handle locations are being passed down so they can update the state here.
    //updating here will cause the props to change in the forms. Instead, we should
    // just force a store rerender of the state using listeners here.
    // handleNewLocation = {this.addLocation}
    // handleRemoveLocation = {this.deleteLocation}
    // handleEditLocation = {this.updateLocation}
    // 
    return (
      <LocationForm
        key={this.state.location? this.state.location.id : 'editLocation'}
        location = {this.state.location}
        event = {this.state.event}
        modalId = 'editLocationModal'/>
    )
  }

  renderLocationItems() {
    var items = []
    this.state.locations.forEach(function(location) {
      items.push(
        <div
          key = {location.id}
          val = {location}
          value = {location}
          onClick = {this.onLocationSelected}>
          {location.label}
        </div>
      )
    })
    items.push(
      <div
        className = 'divider'
        key = 'separator'
        role = 'separator'>
        <div
          key = 'add_location'
          onClick = {this.handleAddLocation}>
          Add Location
        </div>
      </div>
    )

    return items
  }

  renderLocationItemOptions() {
    var items = []
    this.state.locations.forEach(function(location) {
      items.push(
          {
            label: location.label,
            value: location.id
          }
      )
    })
    return items
  }

  componentWillReceiveProps(nextProps) {
    
    this.setState({
      locations: nextProps.location_data,
      location: nextProps.location,
      event: nextProps.event
    })
  }

  renderLocationInfo() {
    // 
    if (this.state.locations.length === 0) {
      return (
        <a
          className = 'btn btn-default'
          id = 'book-btn'
          onClick = {this.handleAddLocation}>
          Add Location
        </a>
      )
    } else {
      return (
        <div className = 'dropdown center event-locations'>
          <FormSelect name='event-locations'
            value={this.state.location.id}
            options= {this.renderLocationItemOptions()}
            includeBlank= {false}
            onChange={this.onLocationSelected} />
          <a
            className = 'btn'
            id = 'edit-btn'
            onClick = {this.onEditLocation}>
            <span className = 'glyphicon glyphicon-pencil'>
            </span>
          </a>
          <a
              className = 'btn'
              id = 'add-location-btn'
              onClick = {this.handleAddLocation}>
            <span className = 'glyphicon glyphicon-plus'>
            </span>
          </a>
        </div>
      )
    }
  }

  renderSubmitButton(){
    return (this.state.hasShortListedAmbassadors > 0) ?
      <div className="col-sm-6 col-md-6 text-left">
          <button type="button" className="btn btn-warning" onClick={this.onSubmit} id="submit-btn">View Summary</button>
        </div> : null;
  }

  onLocationSelected(e) {
    var newLocation = this.state.locations.filter(function(el){
      return el.id == e
    });

    if (newLocation != null){
      newLocation = newLocation[0];
      this.setState({
        location: newLocation
      })

      LocationAction.setLocation(newLocation);

      //now we are saving current location in event
      let data = {
        id: this.state.event.id,
        current_location_id: newLocation.id
      }

      EventAction.setEventCurrentLocation(data);
    }
  }

  onEditLocation(e) {
    e.preventDefault();

    /*this.setState({
      edit: true
    })*/

    $('#editLocationModal').modal('show')
  }

  handleAddLocation(e) {
    
    e.preventDefault();

   /* this.setState({
      edit: false
    })*/

    $('#newLocationModal').modal('show')
  }

  // THIS IS JUST TEMPORARY
  onSubmit(e) {
    
    $.ajax({
      url: "/shortList/book",
      method: "GET",
      data:{
        // SEND THE EVENT ID
        'event_id': this.state.event.id
      },
      success(data){
        // RESPONSE WILL BE THE URL TO THE BOOKING SUMMARY
        var url = data.next_url
        window.location.assign(url)
        // callback(data)
      },
      error(error, status){
      }
    })
  }

  render() {
    return (
      <div className="location-container">
        <div className="col-md-6 col-sm-6">
          {this.renderLocationInfo()}
        </div>
        {this.renderSubmitButton()}
        {this.renderEditLocationForm()}
        {this.renderAddLocationForm()}
      </div>
    );
  }

}
