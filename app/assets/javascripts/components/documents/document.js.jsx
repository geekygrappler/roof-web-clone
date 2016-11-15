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

        if (localStorage.getItem("oneRoofSkipDemo") != "true") {
            this.setupTour();
        }
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

    setupTour() {
        let tour;

        let tourSubmitFunc = (e,v,m,f) => {
            if(v === -1){
                $.prompt.prevState();
                return false;
            }
            else if(v === 1){
                $.prompt.nextState();
                return false;
            }
        };

        let tourStates = [
            {
                title: 'Welcome to your Project Tender',
                html: 'You can rename it at any time by clicking on the title.',
                buttons: { Next: 1 },
                focus: 0,
                position: { container: '.title', x: 0, y: 60, width: 300, arrow: 'tc' },
                submit: tourSubmitFunc
            },
            {
                title: 'Sections',
                html: 'This is a list of the sections in your tender.<b/><b/>We\'ve pre-populated this tender with suggested sections, but feel free to edit and delete at will.',
                buttons: { Prev: -1, Next: 1 },
                focus: 1,
                position: { container: '.document-sections-list', x: 500, y: 80, width: 300, arrow: 'tc' },
                submit: tourSubmitFunc
            },
            {
                title: 'All the Sections',
                html: 'You can expand this box to see all the sections',
                buttons: { Prev: -1, Next: 1 },
                focus: 1,
                position: { container: '.section-list-expander', x: -310, y: 0, width: 300, arrow: 'rt' },
                submit: tourSubmitFunc
            },
            {
                title: 'Terms & Drawings',
                html: 'Add terms and drawings for the tender here. These will be viewable by professionals quoting on your tender.',
                buttons: { Prev: -1, Next: 1 },
                focus: 1,
                position: { container: '#my-awesome-dropzone', x: 200, y: -200, width: 300, height: 200, arrow: 'bc' },
                submit: tourSubmitFunc
            },
            {
                title: 'Edit Section title',
                html: 'As with the tender title, you can edit the section\'s title by clicking on it.',
                buttons: { Prev: -1, Next: 1 },
                focus: 1,
                position: { container: '.section-name', x: 200, y: 0, width: 300, arrow: 'lt' },
                submit: tourSubmitFunc
            },
            {
                title: 'Delete Section',
                html: 'If the section isn\'t relevant to your tender delete it here.',
                buttons: { Prev: -1, Next: 1 },
                focus: 1,
                position: { container: '.glyphicon-trash', x: -25, y: 25, width: 300, arrow: 'tr' },
                submit: tourSubmitFunc
            },
            {
                title: 'Line Item',
                html: "Record all the work you'd like a quote on as a line item.",
                buttons: { Prev: -1, Next: 1  },
                focus: 1,
                position: { container: '.item-input', x: 100, y: 0, width: 300, arrow: 'lt' },
                submit: tourSubmitFunc
            },
            {
                title: 'Notes',
                html: "Add any specific notes you associated with this line item to the notes section for professionals to read. Include dimensions, drawing references, specific materials etc.",
                buttons: { Prev: -1, Next: 1  },
                focus: 1,
                position: { container: '.line-item-notes', x: 100, y: 0, width: 300, arrow: 'lt' },
                submit: tourSubmitFunc
            },
            {
                title: 'Quantity',
                html: "If you know the quantity of a line item, i.e. 7m long wall, it will help our professionals quote faster.",
                buttons: { Prev: -1, Next: 1  },
                focus: 1,
                position: { container: '.line-item-quantity', x: -305, y: -10, width: 300, arrow: 'rt' },
                submit: tourSubmitFunc
            },
            {
                title: 'Add line items',
                html: "Use this input to add line items. We'll save your history of line items to make your task quicker",
                buttons: { Prev: -1, Next: 1  },
                focus: 1,
                position: { container: '[class^=line-item-search]', x: 200, y: 0, width: 300, arrow: 'lt' },
                submit: tourSubmitFunc
            },
            {
                title: 'Add a section',
                html: "Use this input to add a section.",
                buttons: { Prev: -1, Done: 2 },
                focus: 1,
                position: { container: "#add-section", x: 280, y: -120, width: 300, arrow: "lb" },
                submit: tourSubmitFunc
            },
        ]
        $.prompt.setDefaults({
            top: "40%",
            opacity: 0.3
        });
        localStorage.setItem('oneRoofSkipDemo', true);
        $.prompt(tourStates);

    }
}
