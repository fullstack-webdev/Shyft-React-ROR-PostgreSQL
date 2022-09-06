import  {Component, PropTypes} from 'react';

import  RoleFilter from './filters/role';
import  PriceFilter from './filters/price';
import  DistanceFilter from './filters/distance';
import  CertFilter from './filters/cert';
import  LanguageFilter from './filters/language';

export default class AmbassadorFilterContainer extends Component {
  renderRoleFilter() {
    return <RoleFilter/>
  }

  renderPriceFilter() {
    return <PriceFilter/>
  }

  renderDistanceFilter() {
    return <DistanceFilter/>
  }

  renderCertFilter() {
    return <CertFilter/>
  }

  renderLanguageFilter() {
    return <LanguageFilter/>
  }

  render() {
    return (
      <div className="ambassador-filter-container col">
        <div>
          <p1>Filters</p1>
          <hr className="filter-hr"></hr>
        </div>

        {this.renderRoleFilter()}
        {this.renderPriceFilter()}
        {this.renderDistanceFilter()}
        {this.renderCertFilter()}
        {this.renderLanguageFilter()}



      </div>
    );
  }

}