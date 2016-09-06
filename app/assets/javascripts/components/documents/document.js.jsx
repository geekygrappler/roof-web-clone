class Document extends React.Component {
    constructor(props) {
        super(props);
        this.state = this.props.document;
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
                                    Estimated Total: £{this.state.total_cost}
                                </h2>
                                <button className="btn btn-warning btn-lg">Request Quotes</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="document-sections-list">
                    <div className="container">
                        <SectionList
                            sections={this.state.sections}
                            />
                    </div>
                </div>
                <div className="container">
                    {this.state.sections.map((section) => {
                        return(
                            <Section
                                key={section.id}
                                section={section}
                                document={this.props.document}
                                updateSection={this.updateSection.bind(this)}
                                deleteSection={this.deleteSection.bind(this)}
                                createLineItem={this.createLineItem.bind(this)}
                                updateLineItem={this.updateLineItem.bind(this)}
                                />
                        );
                    })}
                    <div className="row document-add-section">
                        <form className="form-inline" onSubmit={this.addSection.bind(this)}>
                            <div className="form-group">
                                <input type="text"
                                    className="form-control"
                                    name="name"
                                    placeholder="Enter your section name"
                                    />
                            </div>
                            <button type="submit" className="btn btn-warning">Add Section</button>
                        </form>
                    </div>
                </div>
            </div>
        )
    }

    updateTitle(e) {
        this.setState({name: e.target.value});
    }

    addSection(e) {
        e.preventDefault();
        let data = {
            section: {
                name: e.target.name.value,
                document_id: this.props.document.id
            }
        };
        e.target.name.value = "";
        $.ajax({
            url: "/sections",
            method: "POST",
            dataType: "json",
            data: data
        }).done((data) => {
            this.fetchDocument();
        });
    }

    updateSection(sectionId, attributes) {
        let sections = this.state.sections;
        let section = sections.find((section) => {
            return section.id === sectionId;
        });
        let newSection = Object.assign(section, attributes);
        fetch(`/sections/${sectionId}`, {
            method: "PATCH",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                section: newSection
            })
        }).then((response) => {
            if (response.ok) {
                this.fetchDocument();
            }
        });
    }

    deleteSection(sectionId) {
        $.ajax({
            url: `/sections/${sectionId}`,
            method: "DELETE",
            dataType: "json"
        }).done((data) => {
            this.fetchDocument();
        });
    }

    createLineItem(lineItem, sectionId) {
        lineItem["section_id"] = sectionId;
        // Add line_item to the database
        fetch("/line_items", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                "line_item": lineItem
            })
        }).then((response) => {
            if (response.ok) {
                // If we have successfully added a line_item, lets get the document again
                // with updated sections, line_items and totals
                this.fetchDocument();
            }
        });
    }

    updateLineItem(lineItemId, attributes) {
        fetch(`/line_items/${lineItemId}`, {
            method: "PATCH",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                line_item: attributes
            })
        }).then((response) => {
            if (response.ok) {
                this.fetchDocument();
            }
        })
    }

    fetchDocument() {
        return fetch(`/documents/${this.state.id}`, {
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
}
