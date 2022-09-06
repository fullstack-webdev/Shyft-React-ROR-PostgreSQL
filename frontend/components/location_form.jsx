import  {Component, PropTypes} from 'react';
import LocationAction from '../actions/locationAction';

import classnames from 'classnames';
import Superform from 'react-superform';

class LocationForm extends Superform{
  constructor(props){
    super(props);
    
    this.state = {
      location: this.props.location,
      event: this.props.event,
      label: "",
      address: "",
      zip: "",
      city: "",
      state: "Ontario",
      country: "Canada",
      notes: ""
    };

    this.valid = this.valid.bind(this);
    this.validDelete = this.validDelete.bind(this);
    this.close = this.close.bind(this);
    this.handleChange= this.handleChange.bind(this);
    this.removeLocation = this.removeLocation.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    
  }

  getValidatorData() {
    return this.state;
  }
  
  getClasses(field) {
    return classnames({
      'col-lg-8': true,
      //'has-error': !this.props.isValid(field)
    });
  }

  renderHelpText(message) {
    return (
     <span className='help-block'>{message}</span>
    );
  }

  valid() {
    if (this.state.location) {
      return this.state.location.label && this.state.location.address && this.state.location.city && this.state.location.zip && this.state.location.state
    } else {
      return this.state.label && this.state.address && this.state.city && this.state.zip && this.state.state
    }
  }

  validDelete() {
    return (typeof this.state.location.id != undefined) ? true : false;
  }


  close() {
    $('.modal-backdrop').hide()
    $('#'+this.props.modalId).modal('hide')
  }

  onChange(field) {
    return event => {
      const value = event.target.value;
      this.props.updateField(field, value);
    };
  }

  onSubmit(event) {
    event.preventDefault();
    const onValidate = error => {
      if (error) {
        //form has errors; do not submit
      } else {
        //this.props.submitForm();
        this.handleSubmit();
      }
    };
    this.props.validate(onValidate);
  }

  handleChange(e) {
    e.preventDefault();
    this.setState({
      [e.target.name]: e.target.value
    })

  }

  removeLocation(e) {
    
    if (this.props.location && this.props.location.id) {
      var data = {
        id: this.state.location.id,
        label: this.state.label,
        address: this.state.address,
        city: this.state.city,
        zip: this.state.zip,
        state: this.state.state,
        country: this.state.country,
        notes: this.state.notes,
        event_id: this.props.event.id
      }
      LocationAction.deleteLocation(data)
    }

    this.close();
  }

  handleSubmit(e) {
    e.preventDefault();
    if (this.props.location && this.props.location.id) {
      var data = {
        id: this.state.location.id,
        label: this.state.label,
        address: this.state.address,
        city: this.state.city,
        zip: this.state.zip,
        state: this.state.state,
        country: this.state.country,
        notes: this.state.notes,
        event_id: this.props.event.id
      }
      LocationAction.editLocation(data)
    } else {
      var data = {
        label: this.state.label,
        address: this.state.address,
        city: this.state.city,
        zip: this.state.zip,
        state: this.state.state,
        country: this.state.country,
        notes: this.state.notes,
        event_id: this.props.event.id
      }
      LocationAction.createLocation(data)
    }

    this.close();
  }

  componentWillReceiveProps(nextProps) {

    this.setState({
      location: nextProps.location,
      event: nextProps.event
    })
  }

  render() {

    return (
      <div
        className='modal in'
        id={this.props.modalId}
        tabIndex="-1"
        role='dialog'
        aria-hidden={true}>
        <div
          className='modal-dialog'
          role='document'>

          <form
            className='form-inline'
            onSubmit={this.handleSubmit}>
            <div className='modal-content'>
              <div className='modal-header'>
                <button type="button" className="close" data-dismiss="modal" onClick={this.close}>&times;</button>
                <h4 className='modal-title'>
                  Location Details
                </h4>
              </div>
              <div className='modal-body'>
                
                <div className='row event-modal-row'>
                  <label className='col-lg-4 control-label'>
                    Location Name
                  </label>

                  <div className={this.getClasses('label')}>
                    <input
                      type='text'
                      className='form-control'
                      placeholder='ex. CN Tower'
                      defaultValue={this.props.location ? this.props.location.label : ""}
                      name='label'
                      onChange={this.handleChange}
                      required
                      minLength="3"
                      >
                    </input>
                    {this.renderHelpText(this.getErrorMessageOf('label'))}
                  </div>
                </div>

                <div className='row event-modal-row'>
                  <label className='col-lg-4 control-label'>
                    Address
                  </label>
                  <div className={this.getClasses('address')}>
                    <input
                      type='text'
                      className='form-control'
                      placeholder='123 Ontario Street'
                      defaultValue={this.props.location ? this.props.location.address : ""}
                      name='address'
                      onChange={this.handleChange}
                      required
                      >
                    </input>
                    {this.renderHelpText(this.getErrorMessageOf('address'))}
                  </div>
                </div>

                

                <div className='row event-modal-row'>
                  <label className='col-lg-4 control-label'>
                    City
                  </label>
                  <div className={this.getClasses('city')}>
                    <input
                      type='text'
                      className='form-control'
                      placeholder='Toronto'
                      defaultValue={this.props.location ? this.props.location.city : ""}
                      name='city'
                      onChange={this.handleChange}
                      required
                      >
                    </input>
                    {this.renderHelpText(this.getErrorMessageOf('city'))}
                  </div>
                </div>

                <div className='row event-modal-row'>
                  <label className='col-lg-4 control-label'>
                    State/Province
                  </label>
                  <div className={this.getClasses('state')}>
                    <input
                      type='text'
                      className='form-control'
                      placeholder='Ontario'
                      defaultValue={this.props.location ? this.props.location.state : "Ontario"}
                      name='state'
                      onChange={this.handleChange}
                      required
                      >
                    </input>
                    {this.renderHelpText(this.getErrorMessageOf('state'))}
                  </div>
                </div>

                <div className='row event-modal-row'>
                  <label className='col-lg-4 control-label'>
                    Postal Code
                  </label>
                  <div className={this.getClasses('postcode')}>
                    <input
                      type='text'
                      className='form-control'
                      placeholder='1T1 1T1'
                      defaultValue={this.props.location ? this.props.location.zip : ""}
                      name='zip'
                      onChange={this.handleChange}
                      required
                      >
                    </input>
                    {this.renderHelpText(this.getErrorMessageOf('postcode'))}
                  </div>
                </div>

                <div className='row event-modal-row'>
                  <label className='col-lg-4 control-label'>
                    Country
                  </label>
                  <div className={this.getClasses('state')}>
                    <input
                      type='text'
                      className='form-control'
                      placeholder='Canada'
                      defaultValue={this.props.location ? this.props.location.country : "Canada"}
                      name='country'
                      onChange={this.handleChange}
                      required
                      >
                    </input>
                    {this.renderHelpText(this.getErrorMessageOf('country'))}
                  </div>
                </div>

                <div className='row event-modal-row'>
                  <label className='col-lg-4 control-label'>
                    Notes
                  </label>
                  <div className={this.getClasses('notes')}>
                    <textarea
                      type='textarea'
                      className='form-control'
                      placeholder='Please enter notes that are important about the location'
                      defaultValue={this.props.location ? this.props.notes : ""}
                      name='notes'
                      onChange={this.handleChange}
                      >
                    </textarea>
                    {this.renderHelpText(this.getErrorMessageOf('notes'))}
                  </div>
                </div>
              </div>

              <div className='modal-footer'>
                <button
                    type='button'
                    className='btn btn-default'
                    id='remove-btn'
                    disabled={!this.validDelete}
                    onClick={this.removeLocation}
                    >
                  <span className="glyphicon glyphicon-trash">
                  </span>
                  Delete Location
                </button>
                <button
                  type='submit'
                  className='btn btn-primary'
                  id='book-btn'
                  disabled={!this.valid}>
                  Done
                </button>
                
              </div>
            </div>
          </form>
        </div>
      </div>
    );
  }
}

export default LocationForm
