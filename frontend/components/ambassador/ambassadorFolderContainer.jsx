import  {Component, PropTypes} from 'react';

import  AmbassadorStore from '../../stores/ambassadorStore.jsx';
import  AmbassadorReview from './ambassador_review.jsx';
import  AmbassadorBio from './ambassador_bio.jsx';

export default class AmbassadorFolderContainer extends Component {

  constructor(props){
    super(props);
    this.tabs = [
      "About",
      "Reviews",
/*      "Availability",
      "Bio"*/
    ];

    this.state  ={
      activeTabId: 0,
      ambassador: this.props.ambassador,
      reviews:this.props.reviews
    };

    this.toggleTab = this.toggleTab.bind(this);
    this.tabProfileHandler = this.tabProfileHandler.bind(this);

  }

  toggleTab(e) {
    e.preventDefault();
    var clickedTabName = e.target.innerHTML;
    var clickedTabId = this.tabs.indexOf(clickedTabName);
    if (clickedTabId !== this.state.activeTabId) {
      this.setState({
        activeTabId: clickedTabId,
      });
    }
  }

  tabProfileHandler() {

    if (this.state.activeTabId === 0) {
      return (
          <div className="tabContent">
            <p className="about">
              {this.state.ambassador.about}
            </p>
          </div>
      )
    } else if (this.state.activeTabId === 1) {
      return (
        <AmbassadorReview ambassador={this.state.ambassador} reviews={this.state.reviews} />
      )
    } 
  }

  render() {
    var activeTabId = this.state.activeTabId;

    return (
      <div className="user-profile-index-outer-container">
        <div className="user-profile-outer-container">
          <ul
            className="user-profile-categories"
            onClick={this.toggleTab}>
            <li
              className={activeTabId === 0 ? "active" : "inactive-tab"}
              id="tabs">
              {this.tabs[0]}
            </li>
            <li className={activeTabId === 1 ? "active" : "inactive-tab"}
              id="tabs">
              {this.tabs[1]}
            </li>
          </ul>
        </div>

        <div className="profile-item-and-detail active-background" >
          {this.tabProfileHandler()}
        </div>
      </div>
    );
  }

}