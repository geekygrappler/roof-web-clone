class Section extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <div className="row section" id={`section-${this.props.section.id}`}>
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
                            <a className="glyphicon glyphicon-trash" onClick={this.props.deleteSection.bind(this, this.props.section.id)} />
                            <h2 className="section-total">
                                Section Total: {this.props.section.total_cost}
                            </h2>
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
                    <div className="row">
                        <div className="col-xs-6">
                            <h3>
                                Labour
                            </h3>
                        </div>
                        <div className="col-xs-6 text-right">
                            <h3>{this.props.section.total_cost_line_items}</h3>
                        </div>
                    </div>
                    <small>Add tasks that you need a contractor to quote on.</small>
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
                    <div className="row">
                        <div className="col-xs-4 col-xs-push-8 text-right">
                            <span className="section-total">
                                Section Total: {this.props.section.total_cost}
                            </span>
                        </div>
                    </div>
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
