import React from 'react';

class MovingColorImg extends React.Component {
    constructor(props) {
        super(props);
        this.state = {rotationAmount: 0};
        this.clearInterval = this.clearInterval.bind(this);
    }

    componentDidMount() {
        this.intervalId = setInterval(() => {
            let newRotationAmount = this.state.rotationAmount + 3;
            if(this.state.rotationAmount > 360) {
                newRotationAmount = 0;
            }
            this.setState({
                rotationAmount: newRotationAmount
            }), 1000
        })
    }

    componentWillUnmount() {
        this.clearInterval();
    }

    clearInterval() {
        clearInterval(this.intervalId);
    }

    render() {
        return(
            <img onMouseOver={this.clearInterval} className="w-100" style={{filter: 'hue-rotate(' + this.state.rotationAmount + 'deg)'}} src={this.props.src} />
        )
    }
}

export default MovingColorImg;