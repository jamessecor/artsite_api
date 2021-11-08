import React from "react";

class ContactForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            isSubmitted: false,
            inputs: {
                firstname: props.inputs == null ? "" : props.inputs.firstname,
                lastname: props.inputs == null ? "" : props.inputs.lastname,
                email: props.inputs == null ? "" : props.inputs.email,
                message: props.inputs == null ? "" : props.inputs.message
            }
        }
        this.handleChange = this.handleChange.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
    }

    handleChange(e) {
        let firstname = e.target.name == "firstname" ? e.target.value : this.state.inputs.firstname
        let lastname = e.target.name == "lastname" ? e.target.value : this.state.inputs.lastname
        let email = e.target.name == "email" ? e.target.value : this.state.inputs.email
        let message = e.target.name == "message" ? e.target.value : this.state.inputs.message
        this.setState({
            inputs: {
                firstname: firstname,
                lastname: lastname,
                email: email,
                message: message
            }
        })
    }

    componentWillUnmount() {
        this.props.formWillUnmount(this.state.inputs);
    }

    handleSubmit(e) {
        e.preventDefault();
        let submitButton = e.target;
        submitButton.disabled = true;

        const requestMetadata = {
            method: 'POST',
            body: JSON.stringify(this.state.inputs),
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        };

        fetch('api/new_contact', requestMetadata)
            .then(res => res.json())
            .then(
                (result) => {
                    console.log(result);
                    if (result["status"] == "ok") {
                        this.setState({
                            inputs: {
                                firstname: "",
                                lastname: "",
                                message: "",
                                email: ""
                            }
                        })
                    } else if (result["status"] == "failure") {
                    }
                    this.setState({
                        flashMessage: result["message"],
                        isShowingAlert: true
                    })
                    // Re-enable the submit button
                    submitButton.disabled = false;
                }
            )
    }

    render() {
        if (this.state.isSubmitted) {
            return (
                <div>thanks for your message!</div>
            )
        } else {
            return (
                <form onSubmit={this.handleSubmit}>
                    <label htmlFor="email">Email</label>
                    <input type="email" name="email" value={this.state.inputs.email} onChange={this.handleChange}/>
                    <label htmlFor="firstname">First Name</label>
                    <input type="text" name="firstname" value={this.state.inputs.firstname}
                           onChange={this.handleChange}/>
                    <label htmlFor="lastname">Last Name</label>
                    <input type="text" name="lastname" value={this.state.inputs.lastname} onChange={this.handleChange}/>
                    <label htmlFor="message">Message</label>
                    <textarea rows="3" name="message" value={this.state.inputs.message}
                              onChange={this.handleChange}/>
                    <button className="btn btn-primary" onClick={(e) => this.handleSubmit(e)} type="submit"
                            name="submitContact">Submit
                    </button>
                </form>
            )
        }
    }
}

export default ContactForm;