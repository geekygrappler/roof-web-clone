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
                            <div className="col-md-7">
                                <h1 className="title">
                                    <input value={this.state.name} onChange={this.updateTitle.bind(this)}/>
                                </h1>
                            </div>
                            <div className="col-md-5 text-right">
                                <a href={this.props.invite_path}>
                                    <button className="btn btn-warning">Request Quotes</button>
                                </a>
                                <h3 className="heading-total">
                                    Estimated Total: {this.state.total_cost}
                                </h3>
                            </div>
                        </div>
                    </div>
                </div>
                <div className="document-sections-list">
                    <div className="container" id="document-sections-menu">
                        <ul>
                            <SectionList
                                sections={this.state.sections}
                            />
                        </ul>
                    </div>
                </div>
                <div className="container document-section-containers">
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
        )
    }

    componentDidMount() {
        window.scrollTo(0, 0)
        $("body").scrollspy({
            target: "#document-sections-menu"
        })
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
}
