import  {Component, PropTypes} from 'react';

import AmbassadorAction from '../../actions/ambassadorAction';
import AmbassadorStore from '../../stores/ambassadorStore';
import classNames from 'classnames';
export default class Role extends Component {
  static defaultProps = {
    ...Component.defaultProps,
    selected: false,
    data: null
  }

  constructor(props, defaultProps){
    super(props, defaultProps);

    this.state = {
      booked: this.props.booked,
      canBook: this.props.canBook
    };

    this.toggleSelect = this.toggleSelect.bind(this);
    //this.bookAmbassador  = this.bookAmbassador.bind(this);

  }

  componentDidMount() {
    //this.bookListener = AmbassadorStore.addListener(this.bookAmbassador)
  }

  componentWillUnmount() {
    //this.bookListener.remove()
  }

  componentWillReceiveProps (nextProps){

    this.setState({
        booked: nextProps.booked,
        canBook: nextProps.canBook,
        selected: nextProps.selected,
    })
  }

  toggleSelect() {

    var newSelected = !this.props.selected

    //if we already booked an ambassador we only show that card
    if(this.props.ambassadorData != null){
      this.props.onToggleRole(this.props.data, {selected: newSelected}, this.props.ambassadorData)
    }else{
      this.props.onToggleRole(this.props.data, {selected: newSelected}, null)
    }
  }

  /*bookAmbassador(){

    if(this.props.selected){
    }

  }*/

  render() {
    var divStyle = {}
    /*TODO we need to return ambassador profile image in props.ambassador*/
    if(this.props.data.ambassador != null &&  this.props.data.status != 'expired' ){
        var urlImage = (this.props.data.ambassador.images != null && this.props.data.ambassador.images.length > 0) ? this.props.data.ambassador.images[0].url : null;
        var imgUrl = ( urlImage != null ) ? urlImage : '/assets/shyft-d-profile.png';
        var divStyle = {
            backgroundImage: 'url(' + imgUrl + ')',
            backgroundSize: 'contain'
        };
    }

    var roleType = 'A'

    if(this.props.data != null && this.props.ambassadorData == null) {
      roleType = (<span className="role-abbr">{this.props.data.role_type.abbrv}</span>)
    } else {
        roleType = (this.props.ambassadorData == null) ? (<span className="role-abbr">A</span>) : null;
    }

    //role circle class based on role status
    var circleClasses = classNames({
      'circle': true,
      'bookable': this.state.canBook,
      'selected': (this.props.selected && this.props.data.status == 'empty') || (this.props.data.status == 'short-list' && this.props.selected),
      'pending': this.props.data.status == 'pending',
      'accepted': this.props.data.status == 'confirmed'
    })

    return(
      <div className="col-sm-1 unselectable">
        <div className={circleClasses}
            style={divStyle}
            onClick={this.toggleSelect}>
            {roleType}
        </div>
      </div>
    );
  }
}
