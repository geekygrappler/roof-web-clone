/* global React delete */

class Document extends React.Component {
    constructor(props) {
        super(props);
        this.state = this.props.document;
        this.state.viewGroup = "stages";
        this.state = this.filterViewGroups(this.state);
    }

    render() {
        return (
            <div>
                <div className='fixed-document-header'>
                    <div className="document-header">
                        <div className="container">
                            <div className="row">
                                <div className="col-md-7">
                                    <h1 className="title">
                                        <input value={this.state.name}
                                            onChange={this.updateTitle.bind(this)}
                                            onBlur={this.updateDocument.bind(this)}
                                            />
                                    </h1>
                                </div>{/*
                                    */}
                                <div className="col-md-5 text-right">
                                    <a href={this.props.invite_path}>
                                        <button className="btn btn-warning">Request Quotes</button>
                                    </a>
                                    <div className="clearfix"></div>
                                    <div className="btn-group backup-buttons">
                                        <button onClick={this.downloadBackup.bind(this, 'CSV')} className="btn btn-default backup-button" type="button">
                                            CSV
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="document-sections-list">
                        <div className="container" id="document-sections-menu">
                            <p>A section list</p>
                            <p>
                                View by:
                                <select value={this.state.viewGroup} onChange={this.changeViewGroup.bind(this)}>
                                    <option value="locations">Locations</option>
                                    <option value="stages">Stages</option>
                                </select>
                            </p>
                        </div>
                    </div>
                </div>
                <div className="container document-sections-container">
                    {this.renderGroups()}
                    <div className="row document-add-section">
                        <form className="form-inline" onSubmit={this.addSection.bind(this)}>
                            <div className="form-group">
                                <input type="text"
                                    className="form-control"
                                    id="add-section"
                                    name="name"
                                    placeholder="Enter your section name"
                                    />
                            </div>
                            <button type="submit" className="btn btn-warning">Add Section</button>
                        </form>
                    </div>
                </div>
            </div>
        );
    }

    componentDidMount() {
        window.scrollTo(0, 0);
        $("body").scrollspy({
            target: "#document-sections-menu",
            offset: 260
        });
    }

    componentWillUpdate(nextProps, nextState) {
        nextState = this.filterViewGroups(nextState);
    }

    updateTitle(e) {
        this.setState({name: e.target.value});
    }

    changeViewGroup(e) {
        this.setState({viewGroup: e.target.value});
    }

    renderGroups() {
        let viewGroupType = this.state.viewGroup;
        return this.state[viewGroupType].map((viewGroup) => {
            return (
                <LineItemGroup
                    group={viewGroup}
                    document = {this.props.document}
                    createLineItem = {this.createLineItem.bind(this)}
                    updateLineItem = {this.updateLineItem.bind(this)}
                    deleteLineItem={this.deleteLineItem.bind(this)}
                    fetchDocument={this.fetchDocument.bind(this)}
                    key={`${viewGroupType}-${viewGroup.name}`}
                    viewGroupType={this.state.viewGroup}
                    />
            )
        });
    }

    // This whole function is probably the antithesis of React.
    filterViewGroups(state) {
        let viewGroupType = state.viewGroup;
        let viewGroups = state[viewGroupType];
        // Initialize empty LineItems Array for each view group.
        viewGroups.forEach(group => group.lineItems = []);
        if (viewGroups.findIndex(group => group.name === "Ungrouped") === -1) {
            viewGroups.push({name: "Ungrouped", lineItems: []})
        }
        // Assign each LineItem to a view group
        state.line_items.forEach((lineItem) => {
            let lineItemViewGroup = lineItem[viewGroupType.slice(0, -1)]
            if (lineItemViewGroup) {
                let viewGroupIndex = viewGroups.findIndex(group => group.name == lineItemViewGroup.name);
                // Add LineItem to appropriate view group
                viewGroups[viewGroupIndex].lineItems.push(lineItem);
            } else {
                // Add LineItem to "ungrouped" view group
                viewGroups[viewGroups.length - 1].lineItems.push(lineItem);
            }
        });
        return state;
    }

    /* Currently only update is to name of document */
    updateDocument(e) {
        fetch(`/documents/${this.state.id}`, {
            method: "PATCH",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                document: {
                    name: e.target.value
                }
            })
        });
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
        }).done(() => {
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

    createLineItem(lineItem) {
        // Add line_item to the database
        $.ajax({
            url: "/line_items",
            method: "POST",
            dataType: "json",
            data: { line_item: lineItem }
        }).done((data) => {
            this.fetchDocument();
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

    deleteLineItem(lineItemId) {
        $.ajax({
            url: `/line_items/${lineItemId}`,
            method: "DELETE",
            dataType: "json"
        }).done((data) => {
            this.fetchDocument();
        });
    }

    downloadBackup(type) {
        $.ajax({
            url: `/spec/create_backup/`,
            method: "POST",
            dataType: "json",
            data: {
                type: type,
                id: this.state.id
            }
        }).done((data) => {
            var anchor = document.createElement("a")
            anchor.href = data.url
            anchor.download = ''
            document.body.appendChild(anchor)
            anchor.click()
            document.body.removeChild(anchor)
            delete anchor
        });
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
