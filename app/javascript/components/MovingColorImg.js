import React from 'react';

class MovingColorImg extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            intervalId: null,
            rotationAmount: Math.random() * 360,
            isRotating: true
        };
        this.setInterval = this.setInterval.bind(this);
        this.clearInterval = this.clearInterval.bind(this);
        this.toggleInterval = this.toggleInterval.bind(this);
    }

    componentDidMount() {
        this.setInterval();
    }

    componentWillUnmount() {
        this.clearInterval();
    }

    toggleInterval() {
        console.log(this.state);
        if (this.state.isRotating) {
            this.clearInterval();
        } else {
            this.setInterval();
        }
    }

    clearInterval() {
        if (this.state.intervalId !== null) {
            clearInterval(this.state.intervalId);
            this.setState({
                isRotating: false,
                rotationAmount: 0
            });
        }
    }

    setInterval() {
        this.setState({
            isRotating: true,
            intervalId: setInterval(() => {
                let newRotationAmount = this.state.rotationAmount + 3;
                if (this.state.rotationAmount > 360) {
                    newRotationAmount = 0;
                }
                this.setState({
                    rotationAmount: newRotationAmount
                });
            })
        });
    }

    render() {
        return (
            <img onClick={this.toggleInterval} className="w-100"
                 style={{filter: 'hue-rotate(' + this.state.rotationAmount + 'deg)'}} src={this.props.src}/>
        )
    }
}

export default MovingColorImg;