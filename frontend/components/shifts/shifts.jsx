import {Component, PropTypes} from 'react';
import Shift from './shift';

export default class Shifts extends Component {
  constructor(props){
    super(props);
    this.state = {
      shifts: this.props.shifts,
      hover_ambassador: this.props.hover_ambassador
    };

    this.handleRemoveShift = this.handleRemoveShift.bind(this);
  }
 
  componentWillReceiveProps(nextProps) {
    
    this.setState({shifts: nextProps.shifts})
  }

  handleRemoveShift(e) {
    
    this.props.handleRemoveShift(e)
  }

  render() {
    if (this.state.shifts.length > 0) {
      return (
        <div className="row shifts">
            {this.state.shifts.map((data) => {
              return <Shift
                  key={data.id}
                  event_date_shift={data}
                  event = {this.props.event}
                  hover_ambassador={this.state.hover_ambassador}
                  handleAddShift={this.props.handleAddShift}
                  handleRemoveShift = {this.handleRemoveShift}
              />
            })}
        </div>
      );
    } else {
      return (
          <div>You need to add a Shift.</div>
      );
    }
  }
}