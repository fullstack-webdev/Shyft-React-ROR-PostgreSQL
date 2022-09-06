import {Component, PropTypes} from 'react';
import EventDetailsModalForm from './event_details_modal_form';
import EventStore from '../stores/eventStore';

export default class Event extends Component {
  constructor(props){
    super(props);
    this.state = {
      event: this.props.event
    };

    this._onChange = this._onChange.bind(this);
    this.handleOpen = this.handleOpen.bind(this);

  }

  componentDidMount() {
    this.eventListener = EventStore.addListener(this._onChange)
    
  }

  componentDidUpdate(prevProps, prevState) {
    if(this.state.event.name == ''){
      $('#editModal').modal('show');  
    } else{
      $('#editModal').modal('hide');  
    }
  }
    

  _onChange() {
    
    this.setState({
      event: EventStore.getEvent()
    })
  }

  componentWillUnmount() {
    this.eventListener.remove();
  }

  handleOpen() {
    $('#editModal').toggle();
  }

  render() {
    
    return (
      <div className="event">
        <h2 className="title">
          {this.state.event.name}
          <a className="btn" id="edit-btn" onClick={this.handleOpen}>
            <span className="glyphicon glyphicon-pencil">
            </span>
          </a>
        </h2>

        <div>
          <EventDetailsModalForm
            key={this.state.event.id}
            event={this.state.event}
            />
        </div>

      </div>
    );
  }

}