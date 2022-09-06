import  {Component, PropTypes} from 'react';

import AmbassadorBookBox from './ambassador_booking_box';
import AmbassadorFolderContainer from './ambassadorFolderContainer';
import AmbassadorAction from '../../actions/ambassadorAction';
import AmbassadorStore from '../../stores/ambassadorStore';
import RoleStore from '../../stores/roleStore';

export default class AmbassadorRow extends Component {
  constructor(props){
    super(props);

    this.renderBookBox = this.renderBookBox.bind(this);
    this.showAvailableShifts = this.showAvailableShifts.bind(this);
    this.hideAvailableShifts = this.hideAvailableShifts.bind(this);
    this.bookAmbassador = this.bookAmbassador.bind(this);
    this.renderProfileImage = this.renderProfileImage.bind(this);
  }

  renderBookBox() {
    return <AmbassadorBookBox ambassador={this.props.ambassador}/>
  }

  showAvailableShifts() {
    return false;
    AmbassadorAction.canBookAmbassador(this.props.ambassador);
  }

  hideAvailableShifts() {
    return false;
    AmbassadorAction.canBookAmbassador(this.props.ambassador);
  }

  bookAmbassador() {

    var selectedRole = RoleStore.selectedRole();
    if(selectedRole != null){
      AmbassadorAction.bookAmbassadorForRole(this.props.data, selectedRole)
    }

  }

  renderProfileImage() {

    var urlImage = this.props.data.images.length > 0 ? this.props.data.images[0].url : null;
    if(!urlImage) {
      urlImage = '/assets/shyft-d-profile.png';
    }

    return (
        <div className="col-sm-4">
          <a href={"/ambassadors/"+this.props.data.ambassador.id} target="_blank"><img className="img-circle" src={urlImage} width="45" height="45"></img></a>
        </div>
    );
  }


  renderBookButton(){
    return (this.props.bookable) ? (
      <div className="book-container">
            <div className="col-sm-3 user-book" id="book-button-container">
              <button type="button" className="user-book" id="book-button" onMouseEnter={this.showAvailableShifts} onMouseLeave={this.hideAvailableShifts} onClick={this.bookAmbassador}>Book</button>
            </div>
          </div>
      ) : null
  }

  renderProperties() {
    if (this.props.data.properties != null && this.props.data.properties.length > 0) {
        return (
            <div className="row">
                {this.props.data.properties.map((data, i) => {
                  if (data.name == 'car') {
                    return <i className="fa fa-car"></i>
                  }

                  if (data.name == 'smart-serve') {
                    return <i className="fa fa-glass"></i>
                  }

                  if (data.name == 'food-handling-certificate') {
                    return <i className="fa fa-cutlery"></i>
                  }

                  return ''
                })}
            </div>
        );
    } else {
        return (
            null
        );
    }
  }

  render() {

    return (
      <div className="ambassador-preview">
        <div className="row">
          {this.renderProfileImage()}
          <div className="col-sm-5 username">
            <h3>{this.props.ambassador.full_name} ({this.props.data.shifts.length} Shifts)</h3>   {this.renderProperties()}
            <div className="overall-rating row">
              <strong className="title">Rating: </strong><i className="fa fa-star fa-2x"></i><i className="fa fa-star fa-2x"></i><i className="fa fa-star fa-2x"></i><i className="fa fa-star fa-2x"></i><i className="fa fa-star fa-2x"></i>
            </div>
          </div>
          {this.renderBookButton()}

        </div>
        <div className="row text-center glyphicon-arrow">
          <a className="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href={"#collapse" + this.props.ambassador.id} aria-expanded="false" aria-controls={"#collapse" + this.props.ambassador.id}>
            <i className="fa fa-chevron-circle-down fa-2x" id="accordion" aria-hidden="true" id="accordion" role="tablist" aria-multiselectable="true"></i>
          </a>
        </div>
        <div className="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
           <div id={"collapse" + this.props.ambassador.id} className="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
             <div className="panel-body">
               <AmbassadorFolderContainer ambassador={this.props.ambassador} reviews={this.props.data.reviews}  />
             </div>
           </div>
        </div>
      </div>
    );
  }
}
