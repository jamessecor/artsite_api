import React from 'react'
import Cv from "./Cv"
import Artworks from "./Artworks"
import ContactForm from "./ContactForm"

class Navigation extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            currentPage: 'home',
            isLoggedIn: props.isLoggedIn,
            filter: props.filter === undefined ? "" : props.filter,
            searchTerm: props.searchTerm === undefined ? "" : props.searchTerm,
            artworks: [],
            isArtworkDropdownOpen: false,
            contactFormInputs: null
        }

        this.handleClick = this.handleClick.bind(this)
        this.currentPageContent = this.currentPageContent.bind(this)
        this.handleSearchChange = this.handleSearchChange.bind(this)
        this.handleSearchSubmit = this.handleSearchSubmit.bind(this)
        this.fetchArtworks = this.fetchArtworks.bind(this)
        this.toggleArtworkDropdown = this.toggleArtworkDropdown.bind(this)

        this.formWillUnmount = this.formWillUnmount.bind(this);
    }

    componentDidMount() {
        this.fetchArtworks();
    }

    formWillUnmount(formInputs) {
        this.setState({contactFormInputs: formInputs});
    }


    currentPageContent() {
        switch (this.state.currentPage) {
            case "home":
                return <Artworks artworks={this.state.artworks} isLoggedIn={this.state.isLoggedIn}/>
            case "artwork":
                return <Artworks artworks={this.state.artworks} isLoggedIn={this.state.isLoggedIn}/>
            case "search":
                return <Artworks artworks={this.state.artworks} isLoggedIn={this.state.isLoggedIn}/>
            case "cv":
                return <Cv isLoggedIn={this.state.isLoggedIn}/>
            case "contact":
                return <ContactForm formWillUnmount={this.formWillUnmount} inputs={this.state.contactFormInputs} />
            default:
                return <Artworks artworks={this.state.artworks} isLoggedIn={this.state.isLoggedIn}/>
        }
    }

    handleClick(e) {
        e.preventDefault()
        this.setState({
            currentPage: e.target.dataset.pageId,
            filter: e.target.dataset.filter === undefined ? "" : e.target.dataset.filter,
            searchTerm: "",
            isArtworkDropdownOpen: false
        }, () => this.fetchArtworks())
    }

    handleSearchSubmit(e) {
        e.preventDefault();
        this.setState({
            currentPage: "search"
        }, () => this.fetchArtworks())
    }

    handleSearchChange(e) {
        e.preventDefault();
        this.setState({
            searchTerm: e.target.value
        })
    }

    toggleArtworkDropdown(e) {
        e.preventDefault();
        this.setState({
            isArtworkDropdownOpen: !this.state.isArtworkDropdownOpen
        })
    }

    fetchArtworks() {
        let params = [];
        if (this.state.searchTerm !== undefined) {
            params.push(`search=${this.state.searchTerm}`);
        }
        if (this.state.filter !== undefined) {
            params.push(`year_filter=${this.state.filter}`);
        }
        fetch(`/artworks?${params.join('&')}`,
            {
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                }
            }
        )
            .then(res => res.json())
            .then(
                (result) => {
                    if (result.length !== 0) {
                        this.setState({
                            artworks: result
                        });
                    }
                }
            )
    }

    render() {
        const currentYear = new Date().getFullYear();
        const firstArtworkYear = 2012;
        return (
            <div>
                <nav className="navbar navbar-expand-lg py-3 navbar-light">
                    <div className="container-fluid">
                        <a data-page-id="home" className="navbar-brand" href="" onClick={this.handleClick}>James
                            Secor</a>
                        <button className="navbar-toggler" type="button" data-bs-toggle="collapse"
                                data-bs-target="#navbarNavDropdown" aria-controls="navbarNavDropdown"
                                aria-expanded="false"
                                aria-label="Toggle navigation">
                            <span className="navbar-toggler-icon"></span>
                        </button>
                        <div className="collapse navbar-collapse" id="navbarNavDropdown">
                            <ul className="navbar-nav">
                                <li className="nav-item dropdown">
                                    <a className={this.state.currentPage == "artwork" ? "nav-link dropdown-toggle active" : "nav-link dropdown-toggle"}
                                       href="#" id="artworkDropdownMenuLink"
                                       onClick={this.toggleArtworkDropdown}
                                       role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                        artwork
                                    </a>
                                    <ul className={`dropdown-menu ${this.state.isArtworkDropdownOpen ? 'show' : ''}`}
                                        aria-labelledby="artworkDropdownMenuLink">
                                        {[...Array(currentYear - firstArtworkYear + 1).keys()].map((i) => {
                                            return (
                                                <li key={currentYear - i}><a data-page-id="artwork"
                                                                             data-filter={currentYear - i}
                                                                             onClick={this.handleClick}
                                                                             className="dropdown-item"
                                                                             href="#">{currentYear - i}</a></li>
                                            );
                                        })}
                                    </ul>
                                </li>
                                <li className="nav-item">
                                    <a href="" data-page-id="cv"
                                       className={this.state.currentPage == "cv" ? "nav-link active" : "nav-link"}
                                       onClick={this.handleClick}>cv</a>
                                </li>
                                <li className="nav-item">
                                    <a href="" data-page-id="contact"
                                       className={this.state.currentPage == "contact" ? "nav-link active" : "nav-link"}
                                       onClick={this.handleClick}>contact</a>
                                </li>
                            </ul>
                            <ul className="nav navbar-nav navbar-right ms-auto d-flex align-items-center">
                                <li className="nav-item">
                                    James Secor &copy; 2021
                                </li>
                                <li className="nav-item">
                                    <a href="https://www.instagram.com/jamessecor/" className="nav-link instagram-icon">
                                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
                                             fill="currentColor"
                                             className="bi bi-instagram" viewBox="0 0 16 16">
                                            <path
                                                d="M8 0C5.829 0 5.556.01 4.703.048 3.85.088 3.269.222 2.76.42a3.917 3.917 0 0 0-1.417.923A3.927 3.927 0 0 0 .42 2.76C.222 3.268.087 3.85.048 4.7.01 5.555 0 5.827 0 8.001c0 2.172.01 2.444.048 3.297.04.852.174 1.433.372 1.942.205.526.478.972.923 1.417.444.445.89.719 1.416.923.51.198 1.09.333 1.942.372C5.555 15.99 5.827 16 8 16s2.444-.01 3.298-.048c.851-.04 1.434-.174 1.943-.372a3.916 3.916 0 0 0 1.416-.923c.445-.445.718-.891.923-1.417.197-.509.332-1.09.372-1.942C15.99 10.445 16 10.173 16 8s-.01-2.445-.048-3.299c-.04-.851-.175-1.433-.372-1.941a3.926 3.926 0 0 0-.923-1.417A3.911 3.911 0 0 0 13.24.42c-.51-.198-1.092-.333-1.943-.372C10.443.01 10.172 0 7.998 0h.003zm-.717 1.442h.718c2.136 0 2.389.007 3.232.046.78.035 1.204.166 1.486.275.373.145.64.319.92.599.28.28.453.546.598.92.11.281.24.705.275 1.485.039.843.047 1.096.047 3.231s-.008 2.389-.047 3.232c-.035.78-.166 1.203-.275 1.485a2.47 2.47 0 0 1-.599.919c-.28.28-.546.453-.92.598-.28.11-.704.24-1.485.276-.843.038-1.096.047-3.232.047s-2.39-.009-3.233-.047c-.78-.036-1.203-.166-1.485-.276a2.478 2.478 0 0 1-.92-.598 2.48 2.48 0 0 1-.6-.92c-.109-.281-.24-.705-.275-1.485-.038-.843-.046-1.096-.046-3.233 0-2.136.008-2.388.046-3.231.036-.78.166-1.204.276-1.486.145-.373.319-.64.599-.92.28-.28.546-.453.92-.598.282-.11.705-.24 1.485-.276.738-.034 1.024-.044 2.515-.045v.002zm4.988 1.328a.96.96 0 1 0 0 1.92.96.96 0 0 0 0-1.92zm-4.27 1.122a4.109 4.109 0 1 0 0 8.217 4.109 4.109 0 0 0 0-8.217zm0 1.441a2.667 2.667 0 1 1 0 5.334 2.667 2.667 0 0 1 0-5.334z"></path>
                                        </svg>
                                    </a>
                                </li>
                                <li className="nav-item">
                                    <a className={this.props.isLoggedIn ? "nav-link" : "nav-link d-none"} rel="nofollow"
                                       data-method="delete"
                                       href="/users/sign_out">Logout</a>
                                </li>
                                <li>
                                    <form onSubmit={this.handleSearchSubmit} className="d-flex">
                                        <input onChange={this.handleSearchChange} className="form-control me-2"
                                               type="search" placeholder="Search"
                                               aria-label="Search"/>
                                        <button className="btn btn-outline-success" type="submit">Search</button>
                                    </form>
                                </li>
                            </ul>
                        </div>
                    </div>
                </nav>
                {this.currentPageContent()}
            </div>
        )
    }


}

export default Navigation
