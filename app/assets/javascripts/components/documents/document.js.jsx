class Document extends React.Component {
    constructor(props) {
        super(props);
        this.state = this.props.data
    }

    updateTitle(e) {
        this.setState({name: e.target.value})
    }

    swapDocument(newAttributes) {
        let currentState = this.state;
        debugger;
        this.setState(currentState);
    }

    render() {
        return (
            <div>
                <div className="document-header">
                    <div className="container">
                        <div className="row">
                            <div className="col-md-6 ">
                                <h1 className="title">
                                    <input value={this.state.name} onChange={this.updateTitle.bind(this)}/>
                                </h1>
                            </div>
                            <div className="col-md-6  text-right">
                                <h2 className="heading-total">
                                    Estimated Total: £2,342
                                </h2>
                                <button className="btn btn-warning btn-lg">Request Quotes</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="document-sections-list">
                    <div className="container">
                        <SectionList
                            sections={this.props.data.sections}
                            />
                    </div>
                </div>
                <div className="container">
                    {this.props.data.sections.map((section) => {
                        return(
                            <Section
                                key={section.id}
                                section={section}
                                document={this.props.data}
                                swapDocument={this.swapDocument.bind(this)}
                                />
                        );
                    })}
                    {this.props.data.sections.map((section) => {
                        return(
                            <Section
                                key={section.id + 100}
                                section={section}
                                document={this.props.data}
                                swapDocument={this.swapDocument.bind(this)}
                                />
                        );
                    })}
                </div>
            </div>
        )
    }
}
