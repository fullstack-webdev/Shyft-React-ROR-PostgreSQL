import  {Component, PropTypes} from 'react';
import {FormGroup, FormControl, ControlLabel} from 'react-bootstrap';
import AmbassadorStore from '../../stores/ambassadorStore';
import AmbassadorAction from '../../actions/ambassadorAction';
import RoleStore from '../../stores/roleStore';
import RolesPopup from './rolesPopup';
import Roles from './roles';
import RoleUtil from '../../utils/roleUtil';
import RoleAction from '../../actions/roleAction';
import ShiftAction from '../../actions/shiftAction';
import update from 'react-addons-update';

export default class RolesContainer extends Component {
  constructor(props){
    super(props);
    this.state = {
      roles: [],
      selectedRole: RoleStore.selectedRole(),
      hover_ambassador: AmbassadorStore.getHoverAmbassador(),
      bookedAmbassadors: AmbassadorStore.getBookedAmbassadors()
    };
    this.onChangeAmbassador = this.onChangeAmbassador.bind(this);
    this.onChangeSelectedRole = this.onChangeSelectedRole.bind(this);
    this.handleAddRolePopup = this.handleAddRolePopup.bind(this);
    this.onRoleAdded = this.onRoleAdded.bind(this);
    this.onDeleteRole = this.onDeleteRole.bind(this);
    this.deleteSelectedRole = this.deleteSelectedRole.bind(this);
    this.replaceSelectedRole = this.replaceSelectedRole.bind(this);
    this.handleToggleRole = this.handleToggleRole.bind(this);
    this.renderAddRoleButton = this.renderAddRoleButton.bind(this);
    this.renderDeleteReplaceRole = this.renderDeleteReplaceRole.bind(this);
    this.renderRoles = this.renderRoles.bind(this);

  }

  componentDidMount () {
    
    this.ambassadorListener = AmbassadorStore.addListener(this.onChangeAmbassador);
    //this.roleListener = RoleStore.addListener(this.onChangeSelectedRole);
  }

  componentWillReceiveProps (nextProps) {
    
    this.setState({
      roles: nextProps.roles,
      selectedRole: RoleStore.selectedRole(),
      hover_ambassador: AmbassadorStore.getHoverAmbassador(),
      bookedAmbassadors: AmbassadorStore.getBookedAmbassadors()
    })
  }

  componentWillUnmount () {
    
    this.ambassadorListener.remove();
    //this.roleListener.remove();
  }

  getShiftsData (dateId) {

  }

  onChangeAmbassador (ambassador){
    
    var bookedAmbassadors = AmbassadorStore.getBookedAmbassadors();
    if(bookedAmbassadors != null){
      this.setState({bookedAmbassadors: bookedAmbassadors});  
    }
  }

  onChangeSelectedRole () {
    this.setState({selectedRole: RoleStore.selectedRole()})

    //check if role Added
    var addedRoleData = RoleStore.getAddedRoleData()
    if(addedRoleData != null &&  addedRoleData.shift_id == this.props.shift.id){
      roles = update(this.state.roles, {$push: [addedRoleData.role]})
      this.setState({roles: roles})
      RoleAction.clearAddedRole()
    }

  }

  handleAddRolePopup () {
    RoleAction.addRolePopup(this.props.shift.id)
  }

  onRoleAdded (data) {
    
    var roles = update(this.state.roles, {$push: [data]})
    this.setState({roles: roles})
  }

  onDeleteRole (role, data) {
    var index = _.findIndex(this.state.roles, function(o){return o.role.id == role.role.id})
    var roles = update(this.state.roles, {$splice:[[index, 1]]})
    this.setState({roles: roles})
  }

  deleteSelectedRole () {
    if (this.state.selectedRole != null){
      var selectedRole = this.state.selectedRole
      RoleUtil.deleteRole(this.state.selectedRole.role, (data)=>{
        var index = _.findIndex(this.state.roles, function(o){return o.role.id == selectedRole.role.id})
        var roles = update(this.state.roles, {$splice:[[index, 1]]})
        RoleAction.selectRole(null)
        this.setState({
          roles: roles,
          selectedRole: null
        })
      })
    }
  }

  replaceSelectedRole () {
    
    if (this.state.selectedRole != null){
      AmbassadorAction.removeAmbassadorForRole(this.state.selectedRole, (data) => {
      })
    }
  }

  handleToggleRole (role, newData, bookedAmbassador) {
    if (!newData.selected) {
      RoleAction.selectRole({role: null, shift: this.props.shift, ambassador: null})
      ShiftAction.selectShift(null)
    } else {
      if(bookedAmbassador == null){
        RoleAction.selectRole({role: role, shift: this.props.shift, ambassador: null})
        ShiftAction.selectShift(this.props.shift)  
      } else {
        RoleAction.selectRole({role: role, shift: this.props.shift, ambassador: bookedAmbassador})
        ShiftAction.selectShift(this.props.shift)
        //we're not filtering ambssadors to find rightfit, we only show selectd ambassador
        //ATTENTION! role.ambassador should match original ambassador container data format
        AmbassadorAction.filterOutAmbassador(role.ambassador, role)
      }
      
      
    }
    
  }

  renderAddRoleButton () {
    return (
        <button id="role-button" onClick={this.handleAddRolePopup}>
          <i className="fa fa-plus shift-plus" aria-hidden="true"></i>
        </button>
    );
  }

  renderDeleteReplaceRole () {
    var selectedRole = RoleStore.selectedRole()

    var hasSelectedRole = false
    if(typeof this.state.roles === undefined  || !this.state.roles || !selectedRole)
      hasSelectedRole = false
    else
       hasSelectedRole =(this.state.roles.filter(data => {
          return data.role.id == selectedRole.role.id
        })).length > 0
    // check if role has booked an ambassador
    var hasAmbassador = false
    if(hasSelectedRole){
      hasAmbassador = this.state.bookedAmbassadors && this.state.bookedAmbassadors[selectedRole.role.id] 
    }

    //check if not pending role
    var isPending = (selectedRole!= null && selectedRole.status == 'pending')
    return (hasSelectedRole && hasAmbassador && !isPending) ? (
        <a className="delete-role" onClick={this.replaceSelectedRole}>Replace</a>
    ) : ( (hasSelectedRole && !isPending) ? (<a className="delete-role" onClick={this.deleteSelectedRole}>Delete</a>) : null);
  }

  renderRoles () {
    return (<Roles roles={this.state.roles}
                  hover_ambassador={this.state.hover_ambassador}
                  bookedAmbassadors={this.state.bookedAmbassadors}
                  selectedRole = {this.state.selectedRole}
                  onToggleRole = {this.handleToggleRole}
    />)
  }

  render () {
    return (
      <div className="rolesContainer" data-shift-id={this.props.shift.id}>
        {this.renderRoles()}
        <div className="add-role">
          {this.renderAddRoleButton()}
          {this.renderDeleteReplaceRole()}
        </div>
      </div>
    )
  }
}