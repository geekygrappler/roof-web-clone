class Document extends React.Component {
    constructor(props) {
        super(props);
        this.state = this.props.document;
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
                                    */}<div className="col-md-5 text-right">
                                    <a href={this.props.invite_path}>
                                        <button className="btn btn-warning">Request Quotes</button>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="document-sections-list">
                        <div className="container" id="document-sections-menu">
                            <SectionList
                                sections={this.state.sections}
                                />
                        </div>
                    </div>
                </div>
                <div className="container document-sections-container">
                    <div className="row section" id="section-drawings">
                        <div className="col-sm-12">
                            <h2>Terms & Drawings</h2>
                            <p>Upload drawings and your companies terms and conditions for tenders.</p>
                            <h5>Upload Documents</h5>
                            <form id="my-awesome-dropzone" action="/spec/upload_document" className="dropzone">
                                <input type="hidden" name="authenticity_token" value={jQuery('[name="csrf-token"]').attr('content')} />
                                <input type="hidden" name="document_id" value={this.state.id} />
                            </form>
                        </div>
                    </div>
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
                                deleteLineItem={this.deleteLineItem.bind(this)}
                                createBuildingMaterial={this.createBuildingMaterial.bind(this)}
                                updateBuildingMaterial={this.updateBuildingMaterial.bind(this)}
                                deleteBuildingMaterial={this.deleteBuildingMaterial.bind(this)}
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
        );
    }

    componentDidMount() {
        window.scrollTo(0, 0);
        $("body").scrollspy({
            target: "#document-sections-menu",
            offset: 260
        });

        this.setupTour();
    }

    updateTitle(e) {
        this.setState({name: e.target.value});
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
            dataTyep: "json",
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

    createBuildingMaterial(buildingMaterial) {
        $.ajax({
            url: "/building_materials",
            method: "POST",
            dataType: "json",
            data: {
                building_material: buildingMaterial
            }
        }).done((data) => {
            this.fetchDocument();
        });
    }

    updateBuildingMaterial(buildingMaterialId, attributes) {
        $.ajax({
            url: `/building_materials/${buildingMaterialId}`,
            method: "PATCH",
            dataType: "json",
            data: {
                building_material: attributes
            }
        }).done((data) => {
            this.fetchDocument();
        });
    }

    deleteBuildingMaterial(buildingMaterialId) {
        $.ajax({
            url: `/building_materials/${buildingMaterialId}`,
            method: "DELETE",
            dataType: "json"
        }).done((data) => {
            this.fetchDocument();
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
                html: "Record all the work you'd like a quote on as a line item.</br> </br>You can edit the suggested line items by clicking on them. We'll also display items from our database while you're editing.",
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
                html: "Use this input to add line items. It's a free text search of our database, or if you don't find the specific task you're looking for, simply add it and we'll get you a quote.",
                buttons: { Prev: -1, Done: 2  },
                focus: 1,
                position: { container: '[class^=line-item-search]', x: 200, y: 0, width: 300, arrow: 'lt' },
                submit: tourSubmitFunc
            },
        ]
        $.prompt.setDefaults({
            top: "30%",
            opacity: 0.2
        });
        $.prompt(tourStates);
    }
}
