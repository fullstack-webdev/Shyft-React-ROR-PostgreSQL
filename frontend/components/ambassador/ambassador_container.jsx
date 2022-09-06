import {Component, PropTypes} from 'react';
import AmbassadorFilterContainer  from './ambassador_filter_container';
import AmbassadorRow from './ambassador_row';
import AmbassadorStore from '../../stores/ambassadorStore';
import AmbassadorAction from '../../actions/ambassadorAction';
import FilterStore from '../../stores/filterStore';
import LocationStore from '../../stores/locationStore';
import RoleStore from '../../stores/roleStore';
import ShiftStore from '../../stores/shiftStore';

export default class AmbassadorsContainer extends Component {
  constructor(props){
    super(props);
    this.state = {
      data: AmbassadorStore.getAmbassadors(),
      filters: FilterStore.getFilters(),
      // will have to change to filterParams later
      location: LocationStore.getLocation()
    };

    this._filterChange = this._filterChange.bind(this);
    this._onAmbassadorChange = this._onAmbassadorChange.bind(this);
    this._onSelectedRoleChange = this._onSelectedRoleChange.bind(this);
    this.renderAmbassadors = this.renderAmbassadors.bind(this);
  }

  componentDidMount() {

    this.ambassadorListener = AmbassadorStore.addListener(this._onAmbassadorChange)
    AmbassadorAction.fetchFilteredAmbassadors(this.state.filters, this.state.location.id);

    this.filterListener = FilterStore.addListener(this._filterChange)
    this.roleListener = RoleStore.addListener(this._onSelectedRoleChange)
    //this.shiftListenere = ShiftStore.addListener(this._onSelectedShiftChange)
  }

  componentWillUnmount() {
      this.ambassadorListener.remove()
      this.filterListener.remove()
      this.roleListener.remove()
      //this.shiftListener.remove()
  }

  _filterChange() {
    this.setState({
      filters: FilterStore.getFilters(),
      location: LocationStore.getLocation()
    })


    AmbassadorAction.fetchFilteredAmbassadors(this.state.filters, LocationStore.getLocation().id);
  }

  _onAmbassadorChange() {
    this.setState({
      data: AmbassadorStore.getAmbassadors()
    })

  }

  _onSelectedRoleChange() {

    var selectedRole= RoleStore.selectedRole()
    if(selectedRole != null){
      //fetch by role
      AmbassadorAction.fetchFilterAmbassadorsByRole(selectedRole.role)
    } else {
      //renew list
      AmbassadorAction.fetchFilteredAmbassadors(this.state.filters, LocationStore.getLocation().id)
    }
  }

  renderAmbassadorFilter() {

    return <AmbassadorFilterContainer/>
  }



  renderAmbassadors() {
    
    var selectedRole= RoleStore.selectedRole()
    return (this.state.data.length >0) ? this.state.data.map((data) => {
        return <AmbassadorRow key={data.ambassador.id} ambassador={data.ambassador} data={data} bookable={(selectedRole != null && selectedRole.ambassador == null)} />
    }) : ( (selectedRole != null) ? <h4>Currently there is no one available for this time for those specifications. Please check back later or try changing the rate.</h4> : null);
  }

  render() {

    return (
      <div>
        <div className="row rows">
          <div className="filter-box">
            {/*this.renderAmbassadorFilter() */}
          </div>
          <div className="ambassador-list col-sm-12">
            {this.renderAmbassadors()}
          </div>
        </div>
      </div>
    );
  }
}
