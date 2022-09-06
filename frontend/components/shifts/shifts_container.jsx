import  {Component, PropTypes} from 'react';
import Shifts from './shifts';
import update from 'react-addons-update';

export default class ShiftsContainer extends Component {
  constructor(props){
    super(props);
    this.state = {
      shifts: this.props.shifts,
      event_date: this.props.event_date,
      hover_ambassador: this.props.hover_ambassador
    };

    this.onShiftAdded = this.onShiftAdded.bind(this);
    this.onDeleteShift = this.onDeleteShift.bind(this);
    this.onUpdateShift = this.onUpdateShift.bind(this);
    this.handleAddShift  = this.handleAddShift.bind(this);
    this.renderAddShiftButton = this.renderAddShiftButton.bind(this);
    this.renderShifts  = this.renderShifts.bind(this);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({shifts: nextProps.shifts})
  }

  onShiftAdded(data) {
    
    var shifts = update(this.state.shifts, {$push: [data.shift]})
    this.setState({shifts: shifts})
    this.render()
  }

  onDeleteShift(data) {
    var index = _.findIndex(this.state.shifts, function(o){return o.id == data.id})
    var shifts = update(this.state.shifts, {$splice:[[index, 1]]})
    this.setState({shifts:shifts})
    
  }

  onUpdateShift(shift, newData) { 
    var index = _.findIndex(this.state.shifts, function(o){return o.id == shift.id})
    var shifts = update(this.state.shifts, { $splice: [[index, 1, newData]]})
    this.setState({shifts: shifts})
  }

  handleAddShift() {

    this.props.handleAddShift(this.props.event_date, this.onShiftAdded)
  }

  renderAddShiftButton() {
    return (
        <button id="shift-button" onClick={this.handleAddShift}>+ Add Shift</button>
    );
  }

  renderShifts() {
    return <Shifts
        shifts={this.state.shifts}
        event = {this.props.event}
        hover_ambassador = {this.state.hover_ambassador}
        handleRemoveShift = {this.onDeleteShift}
    />
  }

  render() {
    return (
      <div className="shiftsContainer" data-event-id={this.props.event_date.id}>
        {this.renderShifts()}
        <div className="row">
          {this.renderAddShiftButton()}
        </div>
      </div>
    )
  }
}