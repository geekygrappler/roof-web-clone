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
                                <input type="text" defaultValue={this.props.section.name} onBlur={this.update.bind(this, "name")} />
                            </h2>
                        </div>
                        <div className="col-sm-4 text-right">
                            <h2>
                                £{this.calculateTotal()}
                            </h2>
                        </div>
                    </div>
                    <textarea defaultValue={this.props.section.notes} onBlur={this.update.bind(this, "notes")} />
                    <h3>
                        Labour
                    </h3>
                    <LineItems
                        lineItems = {this.props.section.line_items}
                        document = {this.props.document}
                        createLineItem = {this.props.createLineItem}
                        updateLineItem = {this.props.updateLineItem}
                        sectionId = {this.props.section.id}
                        />
                    <h3>
                        Materials
                    </h3>
                </div>
            </div>
        );
    }

    update(attribute, e) {
        let sectionId = this.props.section.id;
        let attributes = {};
        attributes[attribute] = e.target.value;
        this.props.updateSection(sectionId, attributes);
    }

    calculateTotal() {
        return this.props.section.line_items.reduce((previousTotal, lineItem) => {
            return previousTotal + (lineItem.rate * lineItem.quantity);
        }, 0);
    }
}
