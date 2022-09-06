import  {Component, PropTypes} from 'react';

export default class AmbassadorBio extends Component {
    handleBooking(e) {
        e.preventDefault();
    }

    componentDidMount() {
        
    }

    render() {

        return (
            <div class="panel panel-default">
                <div className="panel-body">
                    {this.props.ambassador.response_time == 1 ? <p><b>Avg. Response:</b> Less Than 60 mins</p> : <p><b>Avg. Response:</b> {this.props.ambassador.response_time} Hours</p> }
                    <p><b>Acceptance:</b> { this.props.ambassador.acceptance_rate == null ? '100%' : this.props.ambassador.acceptance_rate} </p>
                </div>
            </div>
        );
    }
}