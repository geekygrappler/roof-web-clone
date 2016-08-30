class Document extends React.Component {
    constructor(props) {
        super(props);
        this.state = this.props.data;
    }

    updateTitle(e) {
        this.setState({name: e.target.value});
    }

    // swapDocument(newAttributes) {
    //     let currentState = this.state;
    //     this.setState(currentState);
    // }

    updateSection(sectionId, attributes) {
        let sections = this.state.sections;
        let section = sections.find((section) => {
            return section.id === sectionId;
        });
        let newSection = Object.assign(section, attributes);
        fetch(`/sections/${sectionId}`, {
            method: "PATCH",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({
                section: newSection
            })
        }).then((response) => {
            if (response.ok) {
                this.setState(this.state);
            } else {
                console.log("Response not OK");
            }
        });
    }

    createLineItem(lineItem, sectionId) {
        console.log("Hi");
        lineItem["section_id"] = sectionId
        // Add line_item to the database
        fetch("/line_items", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({
                "line_item": lineItem
            })
        }).then((response) => {
            if (response.ok) {
                // If we have successfully added a line_item, lets get the document again
                // with updated sections, line_items and totals
                fetch(`/documents/${this.state.id}`, {
                    method: "GET",
                    headers: {
                        "Content-Type": "application/json",
                    }
                }).then((response) => {
                    if (response.ok) {
                        response.json().then((document) => {
                            this.setState(document);
                        });
                    } else {
                        console.log("Saved Line_item, but failed to fetch document");
                    }
                });
            }
        });
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
                                updateSection={this.updateSection.bind(this)}
                                createLineItem={this.createLineItem.bind(this)}
                                />
                        );
                    })}
                </div>
            </div>
        )
    }
}
