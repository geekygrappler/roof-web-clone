class Section extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <div className="row section">
                <div className="col-sm-12">
                    <div className="row">
                        <div className="col-sm-8">
                            <h2>
                                <input
                                    type="text"
                                    className="section-name"
                                    defaultValue={this.props.section.name}
                                    onKeyDown={this.update.bind(this, "name")}
                                    />
                            </h2>
                        </div>
                        <div className="col-sm-4 text-right">
                            <h2>
                                £{this.calculateTotal()}
                            </h2>
                            <button className="btn btn-danger" onClick={this.delete.bind(this)}>Delete</button>
                        </div>
                    </div>
                    <div className="row">
                        <div className="col-xs-12">
                            <textarea
                                className="section-notes form-control"
                                defaultValue={this.props.section.notes}
                                placeholder={`Add ${this.props.section.name} notes`}
                                onKeyDown={this.update.bind(this, "notes")} />
                        </div>
                    </div>
                    <h3>
                        Labour
                    </h3>
                    <LineItems
                        lineItems = {this.props.section.line_items}
                        document = {this.props.document}
                        createLineItem = {this.props.createLineItem}
                        updateLineItem = {this.props.updateLineItem}
                        deleteLineItem={this.props.deleteLineItem}
                        sectionId = {this.props.section.id}
                        />
                    <h3>
                        Materials
                    </h3>
                    <small>Add any special materials for the project</small>
                    <BuildingMaterials
                        buildingMaterials={this.props.section.building_materials}
                        document={this.props.document}
                        sectionId={this.props.section.id}
                        createBuildingMaterial={this.props.createBuildingMaterial}
                        updateBuildingMaterial={this.props.updateBuildingMaterial}
                        deleteBuildingMaterial={this.props.deleteBuildingMaterial}
                        />
                </div>
            </div>
        );
    }

    update(attribute, e) {
        if (e.keyCode === this.props.ENTER_KEY_CODE || e.keyCode === this.props.TAB_KEY_CODE) {
            e.preventDefault();
            let inputs = $(':input').not(':button,:hidden,[readonly]');
            let nextInput = inputs.get(inputs.index(e.target) + 1);
            if (nextInput) {
                nextInput.focus();
            }

            let sectionId = this.props.section.id;
            let attributes = {};
            attributes[attribute] = e.target.value;
            this.props.updateSection(sectionId, attributes);
        }
    }

    delete() {
        this.props.deleteSection(this.props.section.id);
    }

    calculateTotal() {
        return this.props.section.line_items.reduce((previousTotal, lineItem) => {
            return previousTotal + (lineItem.rate * lineItem.quantity);
        }, 0);
    }
}

Section.defaultProps = {
    ENTER_KEY_CODE: 13,
    TAB_KEY_CODE: 9
};
