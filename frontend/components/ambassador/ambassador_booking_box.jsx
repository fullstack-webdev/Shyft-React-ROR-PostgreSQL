import  {Component, PropTypes} from 'react';

export default class AmbassadorBookBox extends Component {
  handleBooking(e) {
    e.preventDefault();
    //ajax to book "this" user into a specific shift
  }

  componentDidMount() {
    
  }

  render() {
    
    return (
      <div>
        <button data-id= {this.props.ambassador.id} onClick={this.handleBooking}>Book UserID</button>
      </div>
    );
  }
}