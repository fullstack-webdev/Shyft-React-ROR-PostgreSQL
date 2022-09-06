import  {Component, PropTypes} from 'react';
import FilterActions from '../../../actions/filterActions';

export default class PriceFilter extends Component {

  loadPriceRange() {
    $("#search-index-price-range").slider({
      range: true,
      min: 0,
      max: 30,
      values: [10,25],
      slide(event,ui) {
        var left = (ui.values[0]/5).toFixed(2) + "%";
        var width = ((ui.values[1] - ui.values[0])/5).toFixed(2) + "%";
        // $("#min-max-range").css({left: left, width: width})
        $("#search-index-amount").val("$"+ui.values[0]+"-$"+ui.values[1]);
      },

      stop(event, ui) {
        FilterActions.updatePriceRange({
          min: ui.values[0],
          max: ui.values[1]
        })
      }
    });
    $("#search-index-amount").val("$"+$("#search-index-price-range").slider("values",0)+"-$"+$("#search-index-price-range").slider("values",1));
  }

  componentDidMount() {
    this.loadPriceRange();
  }

  render() {
    $("#search-index-price-range").css('z-index', 0);
    return (
      <div className="col">
        <div>
          <p1 className="filter-section-title">
            Price:
          </p1>
        </div>

        <div>
          <div className="price-range-container price-row">
          <div className="price-range-title-container">
            <label>Price Range</label><br/>
          </div>

          <div className="price-range-container-right">
            <div className="search-index-amount">
              <input type="text" id="search-index-amount" readOnly="true" styles={{border:'0', color:'#f6931f', fontWeight:'bold', background: "transparent"}} />
            </div><br/>
            <div className="price-range-slider-container">
              <div id="search-index-price-range" className="ui-slider ui-slider-horizontal ui-widget ui-widget-content ui-corner-all">
                <span
                  className="ui-slider-handle ui-state-default ui-corner-all"
                  tabIndex="0"
                  styles={{left: '15%'}}>
                </span>
                <span className="ui-slider-handle ui-state-default ui-corner-all" tabIndex="0" style={{left: '60%'}}>
                </span>
              </div>
            </div>
            <div>
              <br/>
              <a>Sort High to Low</a><br/>
              <a>Sort Low to High</a>
            </div>
          </div>
        </div>
        </div>
      </div>
    );
  }

}