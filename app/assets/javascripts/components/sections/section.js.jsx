class Section extends React.Component {
    constructor(props) {
        super(props);
    }

    update(attribute, e) {
        let sectionId = this.props.section.id;
        let attributes = {};
        attributes[attribute] = e.target.value;
        this.props.updateSection(sectionId, attributes);
    }

    render() {
        return (
            <div className="row section">
                <div className="col-sm-12">
                    <h2>
                        <input type="text" defaultValue={this.props.section.name} onBlur={this.update.bind(this, "name")} />
                    </h2>
                    <textarea defaultValue={this.props.section.notes} onBlur={this.update.bind(this, "notes")} />
                    <h3>
                        Labour
                    </h3>
                    <LineItems
                        lineItems = {this.props.section.line_items}
                        document = {this.props.document}
                        createLineItem = {this.props.createLineItem}
                        sectionId = {this.props.section.id}
                        />
                    <h3>
                        Materials
                    </h3>
                </div>
            </div>
        );
    }
}
