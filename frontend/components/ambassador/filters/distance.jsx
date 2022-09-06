import  {Component, PropTypes} from 'react';

export default class DistanceFilter extends Component {

  loadDistanceRange() {
    $("#search-index-distance-range").slider({
      // range: true,
      min: 0,
      max: 100,
      values: [50],
      slide(event,ui) {
        var left = (ui.values[0]/5).toFixed(2) + "%";
        var width = ((ui.values[1] - ui.values[0])/5).toFixed(2) + "%";
        // $("#min-max-range").css({left: left, width: width})
        $("#search-index-amount-distance").val("0 - "+ui.values + "km");
      },

      stop(event, ui) {
        
      }
    });
    $("#search-index-amount-distance").val("0"+" - "+$("#search-index-distance-range").slider("values",0) + "km");
  }

  componentDidMount() {
    this.loadDistanceRange();
  }

  render() {
    return (
      <div className="col">
        <div>
          <p1 className="filter-section-title">
            Distance:
          </p1>
        </div>
        <div>
          <div>
            <div className="distance-range-container distance-row">
              <div className="distance-range-title-container">
                <label>Distance Slider</label><br/>
              </div>

              <div className="distance-range-container-right">
                <div className="search-index-amount-distance">
                  <input type="text" id="search-index-amount-distance" readOnly="true" styles={{border:'0', color:'#f6931f', fontWeight:'bold', background: "transparent"}} />
                </div><br/>
                <div className="distance-range-slider-container">
                  <div id="search-index-distance-range" className="ui-slider ui-slider-horizontal ui-widget ui-widget-content ui-corner-all">
                    <span
                      className="ui-slider-handle ui-state-default ui-corner-all"
                      tabIndex="0"
                      styles={{left: '15%'}}>
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

    );
  }

}