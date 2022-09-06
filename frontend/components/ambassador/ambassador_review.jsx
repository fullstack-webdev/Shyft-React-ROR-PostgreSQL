import  {Component, PropTypes} from 'react';

export default class AmbassadorReviews extends Component {
    handleBooking(e) {
        e.preventDefault();
        //ajax to book "this" user into a specific shift
    }

    componentDidMount() {
        
    }

    render() {
        var reviews = (this.props.reviews != null) ?
            this.props.reviews.map(function(review){
                return(
                    <li id="review.id" key="review.id">
                        <div className="complete row">
                            <div className="col-xs-3 text-center">
                                <div className="image">
                                    <div className="overall-rating row">
                                        <strong className="rating-label"></strong>
                                        {
                                            Array.apply(0, Array(review.star)).map(function (x, i) {
                                                return (<i key={i} className="fa fa-star fa-1x"></i>);
                                            })
                                        }
                                    </div>
                                </div>
                            </div>
                            <div className="col-xs-9">
                                <div className="write-up">
                                    <blockquote>
                                        {review.content}
                                        <footer>{review.name}</footer>
                                    </blockquote>
                                </div>
                            </div>
                        </div>
                    </li>
                )
            }) : (<p>No reviews yet</p>);
        return (
            <div className="tabContent">
                <div className="reviews">
                    {reviews}
                </div>
            </div>
        );
    }
}