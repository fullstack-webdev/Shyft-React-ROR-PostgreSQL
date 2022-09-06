import  {Component, PropTypes} from 'react';

export default class RoleFilter extends Component {

  render() {
    return (
      <div className="col">
        <div>
          <p1 className="filter-section-title">
            Role:
          </p1>
        </div>

        <div className="center">
          <div className="ambassador-role-container col">
            <div>
              <p1 className="left">
                <strong>All</strong>
              </p1>
            </div>
            <div>
              <p1 className="left">
                Promo Model
              </p1>
            </div>
            <div>
              <p1 className="left">
                Brand Ambassador
              </p1>
            </div>
            <div>
              <p1 className="left">
                Sampler
              </p1>
            </div>
          </div>
        </div>
      </div>
    );
  }

}