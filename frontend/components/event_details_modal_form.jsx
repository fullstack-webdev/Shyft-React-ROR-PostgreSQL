import  {Component, PropTypes} from 'react';
import EventAction from '../actions/eventAction';
import linkState from 'react-link-state';
import Superform from 'react-superform';
export default class EventDetailsModalForm extends Superform {

  constructor(props){
    super(props);
    this.state = {
      event: this.props.event,
      name: this.props.event.name,
      eventDetails: this.props.event.event_details
    };

    this.valid = this.valid.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleEdit = this.handleEdit.bind(this);
    this.handleNewEvent = this.handleNewEvent.bind(this);
  }

  valid() {
    this.state.event.name && this.state.event.event_details;
  }

  close() {
    $('#editModal').toggle();
  }

  handleSubmit(e) {
    e.preventDefault()
    if (this.state.event.id) {
      this.handleEdit();
    } else {
      this.handleNewEvent();
    }
  }

  handleEdit() {

    let data = {
      id: this.state.event.id,
      name: this.state.name,
      event_details: this.state.eventDetails
    }

    EventAction.editEvent(data);
    this.close()
  }

  handleNewEvent() {

    let data = {
      name: this.state.name,
      event_details: this.state.eventDetails
    }
    EventAction.createNewEvent(data);
    this.close()
  }

  render() {
    
    return (
      <div className="modal in" id="editModal"  tabIndex="-1" role="dialog" aria-hidden="true">
        <div className="modal-dialog" role="document">
          <form className="form-inline" onSubmit={this.handleSubmit}>
            <div className= 'modal-content'>
              <div className= 'modal-header'>
              <button type="button" className="close" data-dismiss="modal" onClick={this.close}>&times;</button>
                <h4 className= 'modal-title event-title'>
                  Event Details
                </h4>
              </div>
              <div className= 'modal-body'>

                <div className= 'row event-modal-row'>
                  <label className= 'col-lg-4 control-label'>
                    Event Title
                  </label>
                  <div className= 'col-lg-8'>
                    <input type= 'text'
                      className= 'form-control'
                      size= '24x20'
                      placeholder= 'Event Name'
                      defaultValue={this.state.event.name}
                      valueLink={linkState(this, 'name')}
                      required
                      minLength="1"
                      name= 'name'>
                    </input>
                  </div>
                </div>

                <div className= 'row event-modal-row'>
                  <label className= 'col-lg-4 control-label'>
                    Event Details
                  </label>
                  <div className= 'col-lg-8'>
                    <textarea type= 'text'
                    className= 'form-control'
                    placeholder= 'Describe youre event here'
                    name= 'event_details'
                    valueLink={linkState(this, 'eventDetails')}
                    defaultValue={this.state.event.event_details}>
                    </textarea>
                  </div>
                </div>
              </div>

              <div className= 'modal-footer'>
                <button type= 'submit'
                id='book-btn'
                className= 'btn btn-primary'
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