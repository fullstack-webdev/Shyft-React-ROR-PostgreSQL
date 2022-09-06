import {Component, PropTypes} from 'react';
import EventStore from '../stores/eventStore';
import RoleStore from '../stores/roleStore';
import EventDateStore from '../stores/eventDateStore';
import ShiftStore from '../stores/shiftStore';
import DateUtil from '../utils/dateUtil';

export default class FilterNotification extends Component {
    constructor(props){
        super(props);
        this.state = {
            event_date: null,
            shift: ShiftStore.selectedShift(),
            location: null,
            role: RoleStore.selectedRole()
        };
        this.onChangeSelectedRole = this.onChangeSelectedRole.bind(this);
        this.onChangeSelectedShift = this.onChangeSelectedShift.bind(this);
        this.renderShift = this.renderShift.bind(this);
        this.renderRoleType = this.renderRoleType.bind(this);
        this.renderHourlyRate = this.renderHourlyRate.bind(this);
        this.renderEventDate = this.renderEventDate.bind(this);
    }

    componentDidMount() {
        this.roleListener = RoleStore.addListener(this.onChangeSelectedRole)
        this.shiftListener = ShiftStore.addListener(this.onChangeSelectedShift)
    }

    componentWillUnmount() {
        this.roleListener.remove()
        this.shiftListener.remove()
    }

    onChangeSelectedRole() {
        let selectedRole = RoleStore.selectedRole()
        this.setState({role: selectedRole})
    }

    onChangeSelectedShift() {
        let selectedShift = ShiftStore.selectedShift();
        if(selectedShift)
            this.setState({shift: ShiftStore.selectedShift()})
    }

    renderShift() {
        return (this.state.shift)? (
            <span>
                {DateUtil.renderTime(this.state.shift.start_time)} - {DateUtil.renderTime(this.state.shift.end_time)}
            </span>
        ) : null;
    }

    renderRoleType() {
      return (this.state.role)? this.state.role.role_type.displayname: null;
    }

    renderHourlyRate() {
        return (this.state.role) ? '$'+ this.state.role.role.hourly_rate : null;
    }

    renderEventDate() {
        debugger
        return (this.state.shift) ? DateUtil.renderDateWithTZ(this.state.shift.start_time): null;
    }

    clearFilter() {

    }

    render() {
        return (this.state.role) ? (
            <div className="row container notification">
                <div className="col-sm-12 text-center">
                  <i className="fa fa-car"></i> = Has a car     <i className="fa fa-glass"></i> = Smart Serve Certified      <i className="fa fa-cutlery"></i> = Food Handling Certified <br/>
                  <span>
                      Finding {this.renderRoleType()} available on {this.renderEventDate()} from {this.renderShift()} @ {this.renderHourlyRate()}
                  </span>
                </div>
            </div>
        ) :             <div className="row container notification">
                          <div className="col-sm-12 text-center">
                          <i className="fa fa-car"></i> = Has a car     <i className="fa fa-glass"></i> = Smart Serve Certified      <i className="fa fa-cutlery"></i> = Food Handling Certified <br/>
                          </div>
                        </div>;
    }
}
