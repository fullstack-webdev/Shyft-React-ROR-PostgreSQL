import  {Component, PropTypes} from 'react';

import Role from './role';

export default class Roles extends Component {
    static defaultProps  ={
        ...Component.props,
        bookedAmbassadors: null,
        roles: null 
    }

    constructor(props, defaultProps){
        super(props, defaultProps);
        this.state =  {
            roles: this.props.roles,
            booked: false, // this should actually end up using the roles[0].status which is a RoleStatus model
            canBook: -1,
            hover_ambassador: this.props.hover_ambassador
        };

        this.canBook  = this.canBook.bind(this);
    }

   
    canBook () {
        if (this.state.hover_ambassador === null) {
            this.state.canBook = -1;
        } else {    
            this.state.canBook = Math.floor((Math.random() * 10) + 1) % 10;
        }
    }

    render () {
        if (this.props.roles != null && this.props.roles.length > 0) {
            return (
                <div className="row roles">
                    {this.props.roles.map((data, i) => {
                        var isSelected = (this.props.selectedRole != null && data.role.id == this.props.selectedRole.role.id) ? true: false
                        var bookedAmbassador =  (this.props.bookedAmbassadors != null && this.props.bookedAmbassadors[data.role.id]) ? this.props.bookedAmbassadors[data.role.id] : null
                        //only loaded booked ambassador
                        if (bookedAmbassador == null  && data.ambassador != null && data.status != 'empty') {
                            bookedAmbassador = data.ambassador;
                        }

                        return <Role key={data.role.id}
                                     data={data}
                                     ambassadorData = {bookedAmbassador}
                                     handleAddRole={this.props.handleAddRole}
                                     canBook={this.state.canBook == 1}
                                     selected={isSelected}
                                     onToggleRole={this.props.onToggleRole}
                        />
                    })}
                </div>
            );
        } else {
            return (
                <div>You need to add a Role.</div>
            );
        }
    }
}