import  {Component, PropTypes} from 'react';
import { FormGroup, FormControl, ControlLabel } from 'react-bootstrap';

/*var FormGroup = ReactBootstrap.FormGroup;
var FormControl = ReactBootstrap.FormControl;
var ControlLabel = ReactBootstrap.ControlLabel;*/

import FormSelect from '../common/form_select';
import AmbassadorStore from '../../stores/ambassadorStore';
import RoleStore from '../../stores/roleStore';
import RoleAction from '../../actions/roleAction';
import RoleUtil from '../../utils/roleUtil';
import classnames from 'classnames';

export default class RolesPopup extends Component {
    constructor(props){
        super(props);
        this.state = {
            role: { displayname: '', id: 0 },
            quantity: 1,
            rate: null,
            roles: [],  
            quantities: [
                {label: '1', value: 1},
                {label: '2', value: 2},
                {label: '3', value: 3},
                {label: '4', value: 4},
                {label: '5', value: 5},
            ],
            roleTypes: RoleStore.roleTypes(),
            showPopup: this.props.showPopup,
            invalidNumber: false
        };
        this._onChange = this._onChange.bind(this);
        this.updateRoleTypes = this.updateRoleTypes.bind(this);
        this.handleCancelAddRole = this.handleCancelAddRole.bind(this);
        this.addRole = this.addRole.bind(this);
        this.onQuantitySelected = this.onQuantitySelected.bind(this);
        this.onRoleSelected = this.onRoleSelected.bind(this);
        this.handleRateChange = this.handleRateChange.bind(this);
        this.renderValidationErrorMessage = this.renderValidationErrorMessage.bind(this);
    }
    

    componentDidMount() {
      
      this.roleListener = RoleStore.addListener(this._onChange)
      if (this.state.roleTypes.length == 0) {
        RoleAction.getRoleTypes()
      } else {
        this.updateRoleTypes()
      }
    }

    componentWillReceiveProps(newProps){
      this.setState({
          showPopup: newProps.showPopup
      });
      this.render();
    }

    _onChange() {
      this.updateRoleTypes()
    }

    updateRoleTypes() {
      var types = RoleStore.roleTypes()
      var newRoles = []

      for (var i = 0; i < types.length; i++) {
        newRoles.push({
          label: types[i].displayname,
          value: types[i].type_of,
          index: i
        })
      }

      this.setState({
        roleTypes: types,
        roles: newRoles,
        role: types[0]
      })
    }

    componentWillUnmount() {
        this.roleListener.remove();
    }

    handleCancelAddRole() {
        RoleAction.removeRolePopup()
    }
    
    addRole(e) {
        
        var data = {
            count: this.state.quantity,
            roleType:{
                displayName: this.state.role.displayName,
                id: this.state.role.id
            },
            rate: this.state.rate,
            shift_id: RoleStore.getAddRoleShift()
        };

        //this.props.handleAddRole(e, data);
        var roleData = {'event_role': {'role': data.roleType.displayname, 'role_type_id': data.roleType.id, 'hourly_rate': data.rate }, 'shift_id':data.shift_id}
        // Submit form via jQuery/AJAX
        for (var i = 0; i<data.count; i++) {
            RoleUtil.createRole(roleData, RoleAction.addRole)
        }
        RoleAction.removeRolePopup()
    }

    onQuantitySelected(e) {
        
        var newQuantity = this.state.quantities.filter(function(el){
            return el.label == e
        })[0];

        this.setState({
            quantity: newQuantity.value
        });
    }

    onRoleSelected(e) {
        
        var selectedRole = this.state.roles.filter(function(el){
            return el.value == e
        })[0];

        var newRole = this.state.roleTypes[selectedRole.index]

        this.setState({
            role: newRole
        });

    }

    handleRateChange(e){
         if (!isNaN(parseFloat(e.target.value )) && isFinite(e.target.value ) && parseInt(e.target.value)<=1000 && parseInt(e.target.value)>=13) {
            this.setState({invalidNumber: false})
            this.setState({ rate: e.target.value });
        } else {
            this.setState({rate: e.target.value})
            this.setState({invalidNumber: true})
        }
    }
    
    getClasses(field){
        return classnames({
            'invalid-number': field == 'rate' && this.state.invalidNumber
        })
    }

    renderValidationErrorMessage(field)
    {
        if (field == 'rate' && this.state.invalidNumber){
            return <span className="error">Invalid rate. Should be greater than 13</span>
        } else {
            return null;
        }
    }

    render() {
        return (
            <div id="rolePopupModalForm" className="modal in" role="dialog" aria-hidden={true}>
                <div className="modal-dialog">
                    <div className="modal-content">
                        <div className="modal-header">
                            <button type="button" className="close" data-dismiss="modal" onClick={this.handleCancelAddRole}>&times;</button>
                            <h4 className= 'modal-title event-title'>
                              Add Role
                            </h4>
                        </div>

                        <div className="modal-body">
                            <div className= 'row event-modal-row'>
                                <label className= 'col-lg-4 control-label'>
                                 Number of Roles
                                </label>
                               <div className="col-lg-8 select">
                                    <FormSelect name='quantity'
                                        includeBlank= {false}
                                        options={this.state.quantities}
                                        onChange={this.onQuantitySelected}
                                        value={this.state.quantity} />

                                </div>
                            </div>
                            
                            <div className= 'row event-modal-row'>
                                <label className= 'col-lg-4 control-label'>
                                 Role Type
                                </label>
                               <div className="col-lg-8 select">
                                    <FormSelect name='role'
                                        value={this.state.role.type_of}
                                        includeBlank={false}
                                        onChange={this.onRoleSelected}
                                        options={this.state.roles} />
                                </div>
                            </div>

                            <div className= 'row event-modal-row'>
                                <label className= 'col-lg-4 control-label'>
                                 Hourly Rate
                                </label>
                               <div className="col-lg-8 select">
                                    <FormControl
                                        type="text"
                                        value={this.state.rate}
                                        className={this.getClasses('rate')}
                                        placeholder="Enter rate"
                                        onChange={this.handleRateChange}
                                    />
                                    {this.renderValidationErrorMessage('rate')}
                                </div>
                            </div>

                            <div className= 'modal-footer'>
                                <button type= 'submit'
                                id= 'book-btn'
                                className= 'btn btn-primary'
                                disabled={this.state.invalidNumber}
                                onClick={this.addRole}
                                >
                                  Add
                                </button>
                              </div>
                        </div>
                    </div>
                </div>
            </div>
            );
    }
}