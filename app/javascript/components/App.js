import React from 'react'
import Navigation from "./Navigation";

class App extends React.Component {
    constructor(props) {
        super(props);
        this.state = {isLoggedIn: props.isLoggedIn}
    }

    render() {
        return (
            <div>
                <Navigation filter={2020} isLoggedIn={this.state.isLoggedIn} />
            </div>
        )

    }
}

export default App;