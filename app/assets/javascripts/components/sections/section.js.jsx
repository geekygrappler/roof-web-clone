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
                                    onBlur={this.update.bind(this, "name")}
                                    />
                            </h2>
                        </div>
                        <div className="col-sm-4 text-right">
                            <a className="glyphicon glyphicon-trash" onClick={this.props.deleteSection.bind(this, this.props.section.id)} />
                        </div>
                    </div>
                    <div className="section-input-wrapper">
                        <div className="row">
                            <div className="col-xs-6">
                                <h4>
                                    Spec of Works:
                                </h4>
                            </div>
                        </div>
                        <LineItems
                            lineItems = {this.props.section.line_items}
                            document = {this.props.document}
                            createLineItem = {this.props.createLineItem}
                            updateLineItem = {this.props.updateLineItem}
                            deleteLineItem={this.props.deleteLineItem}
                            fetchDocument={this.props.fetchDocument}
                            sectionId = {this.props.section.id}
                            />
                    </div>
                </div>
            </div>
        );
    }

    update(attribute, e) {
        if (e.keyCode === this.props.ENTER_KEY_CODE || e.keyCode === this.props.TAB_KEY_CODE || e.type == "blur") {
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
