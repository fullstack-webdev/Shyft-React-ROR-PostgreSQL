import  {Component, PropTypes} from 'react';

export default class DateDropdown extends Component {
    constructor(props){
        super(props);
        this.state = {
            hours:'Hours',
            minutes:'Minutes', 
            ampm:'AM'
        };
        this.hideOnDocumentClick = this.hideOnDocumentClick.bind(this);
        this.hide = this.hide.bind(this);
        this.parentsHaveClassName = this.parentsHaveClassName.bind(this);
        this.handleOpenHours = this.handleOpenHours.bind(this);
        this.handleOpenMinutes = this.handleOpenMinutes.bind(this);
        this.handleSelectHours = this.handleSelectHours.bind(this);
        this.handleSelectMinutes = this.handleSelectMinutes.bind(this);
        this.handleAmPm = this.handleAmPm.bind(this);
        this.handleUpHour = this.handleUpHour.bind(this);
        this.handleDownHour = this.handleDownHour.bind(this);
        this.handleUpMinute = this.handleUpMinute.bind(this);
        this.handleDownMinute = this.handleDownMinute.bind(this);
        this.handleAMPM = this.handleAMPM.bind(this);
        this.isEmpty = this.isEmpty.bind(this);
    }
    componentDidMount() {
        this.setState({
                hours:'Hours',
                minutes:'Minutes', 
                ampm:'AM'
                });  
    }
    
    componentWillMount() {
        document.addEventListener("click", this.hideOnDocumentClick);
    }

    componentWillUnmount() {
        document.removeEventListener("click", this.hideOnDocumentClick);
    }

    isEmpty() {
        return this.state.hours === 'Hours' && this.state.minutes === 'Minutes'
    }

    hideOnDocumentClick(e) {
        return;
        if (event.target.matches('.dropbtn')) {
            var dropdowns = document.getElementsByClassName(this.props.id + "dropdown-content");
            var i;
            for (i = 0; i < dropdowns.length; i++) {
                var openDropdown = dropdowns[i];
                if (openDropdown.classList.contains('show')) {
                    openDropdown.classList.remove('show');
                }
            }
        }
        if (!this.parentsHaveClassName(e.target, this.props.id + "hoursDropdown")) this.hide();
    }

    hide() {
        document.getElementById(this.props.id + "hoursDropdown").classList.toggle("show");
    }

    parentsHaveClassName(element, className) {
        var parent = element;
        while (parent) {
            if (parent.className && parent.className.indexOf(className) > -1) return true;

            parent = parent.parentNode;
        }

        return false;
    }

    handleOpenHours() {
        document.getElementById(this.props.id + 'hoursDropdown').classList.toggle("show");
    }

    handleOpenMinutes() {
        document.getElementById(this.props.id + "minutesDropdown").classList.toggle("show");
    }

    handleSelectHours(data, e) {

        this.setState({hours: data, minutes:this.state.minutes, ampm:this.state.ampm})
        document.getElementById(this.props.id + 'hoursDropdown').classList.toggle("show");

        if (data === 'Hours' || this.state.minutes === 'Minutes') {
            return;
        }
        this.props.valueChanged({hours: data, minutes:this.state.minutes, ampm:this.state.ampm})
    }

    handleSelectMinutes(data, e) {
        this.setState({minutes: data, hours:this.state.hours, ampm:this.state.ampm})
        document.getElementById(this.props.id + "minutesDropdown").classList.toggle("show");

        if (data === 'Minutes' || this.state.hours === 'Hours') {
            return;
        }
        this.props.valueChanged({minutes: data, hours:this.state.hours, ampm:this.state.ampm})
    }

    handleAmPm() {
        var newValue = this.state.ampm == "AM" ? "PM" : "AM";
        this.setState({ampm:newValue, minutes: this.state.minutes, hours:this.state.hours});

        if (this.state.minutes === 'Minutes' || this.state.hours === 'Hours') {
            return;
        }
        this.props.valueChanged({ampm:newValue, minutes: this.state.minutes, hours:this.state.hours})
    }

    handleUpHour(e) {
        if (this.state.hours === 'Hours' || this.state.hours === '12') {

            this.setState({
                hours: "1"
            }, function(){
                this.props.valueChanged(this.state)
            })
        } else {

            this.setState({
                hours: parseInt(this.state.hours) + 1 + ""
            }, function(){
                this.props.valueChanged(this.state)
            })
        }
    }

    handleDownHour() {
        if (this.state.hours === 'Hours') {

            this.setState({
                hours: "1"
            }, function(){
                this.props.valueChanged(this.state)
            })
        } else if (this.state.hours === '1') {

            this.setState({
                hours: "12"
            }, function(){
                this.props.valueChanged(this.state)
            })
        } else {

            this.setState({
                hours: parseInt(this.state.hours) - 1 + ""
            }, function(){
                this.props.valueChanged(this.state)
            })
        }
        
    }

    handleUpMinute(e) {

        if (this.state.minutes === 'Minutes' || this.state.minutes === '45') {

            this.setState({
                minutes: "00"
            }, function(){
                this.props.valueChanged(this.state)
            })
        } else {
            this.setState({
                minutes: parseInt(this.state.minutes) + 15 + ""
            }, function(){
                this.props.valueChanged(this.state)
            })
        }
    }

    handleDownMinute() {
        if (this.state.minutes === 'Minutes') {

            this.setState({
                minutes: "00"
            }, function(){
                this.props.valueChanged(this.state)
            })
        } else if (this.state.minutes === '00') {
            this.setState({
                minutes: "45"
            }, function(){
                this.props.valueChanged(this.state)
            })
        } else if (this.state.minutes === "15") {
            this.setState({
                minutes: "00"
            }, function(){
                this.props.valueChanged(this.state)
            })
        } else {
            this.setState({
                minutes: parseInt(this.state.minutes) - 15 + ""
            }, function(){
                this.props.valueChanged(this.state)
            })
        }
    }

    handleAMPM() {
        if (this.state.ampm === "AM") {
            this.setState({
                ampm: "PM"
            }, function(){
                this.props.valueChanged(this.state)
            })
        } else {
            this.setState({
                ampm: "AM"
            }, function(){
                this.props.valueChanged(this.state)
            })
        }

    }

    render() {
        return(
            <div className="dropdown center">
                <div className="col ">
                    <i className={"fa fa-caret-up arrow up fa-2x"} id="hours" onClick={this.handleUpHour} />
                    <button className="dropbtn" id="hours-dropbtn" onClick={this.handleOpenHours}> {this.state.hours} </button>
                    <i className={"fa fa-caret-down arrow down fa-2x"} id="hours" onClick={this.handleDownHour} />
                    <div id={this.props.id + "hoursDropdown"} className="dropdown-content">
                        <button onClick={this.handleSelectHours.bind(null, "12")}>12</button>
                        <button onClick={this.handleSelectHours.bind(null, "1")}>1</button>
                        <button onClick={this.handleSelectHours.bind(null, "2")}>2</button>
                        <button onClick={this.handleSelectHours.bind(null, "3")}>3</button>
                        <button onClick={this.handleSelectHours.bind(null, "4")}>4</button>
                        <button onClick={this.handleSelectHours.bind(null, "5")}>5</button>
                        <button onClick={this.handleSelectHours.bind(null, "6")}>6</button>
                        <button onClick={this.handleSelectHours.bind(null, "7")}>7</button>
                        <button onClick={this.handleSelectHours.bind(null, "8")}>8</button>
                        <button onClick={this.handleSelectHours.bind(null, "9")}>9</button>
                        <button onClick={this.handleSelectHours.bind(null, "10")}>10</button>
                        <button onClick={this.handleSelectHours.bind(null, "11")}>11</button>
                    </div>
                </div>
                <div className="col center">:</div>
                <div className="col">
                    <i className={"fa fa-caret-up arrow up fa-2x"} id="minutes" onClick={this.handleUpMinute} />
                    <button className="dropbtn" id="minutes-dropbtn" onClick={this.handleOpenMinutes}> {this.state.minutes} </button>
                    <i className={"fa fa-caret-down arrow down fa-2x"} id="minutes" onClick={this.handleDownMinute} />
                    <div id={this.props.id + "minutesDropdown"} className="dropdown-content">
                        <button onClick={this.handleSelectMinutes.bind(null, "00")}>00</button>
                        <button onClick={this.handleSelectMinutes.bind(null, "15")}>15</button>
                        <button onClick={this.handleSelectMinutes.bind(null, "30")}>30</button>
                        <button onClick={this.handleSelectMinutes.bind(null, "45")}>45</button>
                    </div>
                </div>
                <div className="col">
                    <i className={"fa fa-caret-up arrow up fa-2x"} onClick={this.handleAMPM} />
                    <button className="button" id="ampm" onClick={this.handleAmPm}> {this.state.ampm} </button>
                    <i className={"fa fa-caret-down arrow down fa-2x"} onClick={this.handleAMPM} />
                </div>
            </div>
        );
    }
}