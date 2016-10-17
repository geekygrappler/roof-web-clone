class LineItemForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            lineItem: {
                name: "",
                description: "",
                quantity: "",
                section_id: this.props.sectionId,
                unit: ""
            }
        };
        this.savedLineItems = new Bloodhound({
            datumTokenizer: Bloodhound.tokenizers.whitespace,
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            local: JSON.parse(localStorage.getItem("oneRoofLineItems")) || []
        });
    }

    render() {
        return(
            <tr>
                <td>
                    <input className={`line-item-search-${this.props.sectionId} form-control`}
                        onChange={this.handleChange.bind(this, "name")}
                        value={this.state.lineItem.name}
                        onKeyDown={this.handleKeyDown.bind(this, "name")}
                        onBlur={this.handleKeyDown.bind(this, "name")}
                        placeholder="Search for an item..."
                        autoFocus={true}
                        />
                </td>
                <td>
                    <textarea
                        type="text"
                        className="form-control item-input line-item-notes"
                        onChange={this.handleChange.bind(this, "description")}
                        defaultValue={this.state.lineItem.description}
                        onKeyDown={this.handleKeyDown.bind(this, "description")}
                        onBlur={this.handleKeyDown.bind(this, "description")}
                        placeholder="Add notes"
                        />
                </td>
                <td>
                    <input
                        type="text"
                        className="form-control line-item-quantity"
                        onChange={this.handleChange.bind(this, "quantity")}
                        value={this.state.lineItem.quantity}
                        onChange={this.handleChange.bind(this)}
                        onKeyDown={this.handleKeyDown.bind(this, "quantity")}
                        onBlur={this.handleKeyDown.bind(this, "quantity")}
                        />
                </td>
                <td>
                    <input
                        type="text"
                        className="form-control line-item-unit"
                        onChange={this.handleChange.bind(this, "unit")}
                        value={this.state.lineItem.unit}
                        onChange={this.handleChange.bind(this)}
                        onKeyDown={this.handleKeyDown.bind(this, "unit")}
                        onBlur={this.handleKeyDown.bind(this, "unit")}
                        />
                </td>
                <td></td>
            </tr>
        );
    }

    componentDidMount() {
        $(`.line-item-search-${this.props.sectionId}`).typeahead({highlight: true, hint: true, minLength: 1}, {
            source: this.savedLineItems
        });
    }

    handleChange(attribute, e) {
        let nextState = this.state.lineItem;
        nextState[attribute] = e.target.value;
        this.setState({lineItem: nextState});
    }

    handleKeyDown(attribute, e) {
        if (e.keyCode === this.props.ENTER_KEY_CODE || e.keyCode === this.props.TAB_KEY_CODE || e.type == "blur") {
            if (e.target.value.length === 0) {
                return;
            }
            e.preventDefault();

            if (attribute == "name") {
                let lineItem = this.state.lineItem;
                this.saveLineItemLocally(this.state.lineItem.name);
                this.props.createLineItem(lineItem);
                this.setState({
                    lineItem: {
                        name: "",
                        description: "",
                        quantity: "",
                        section_id: this.props.sectionId,
                        unit: ""
                    }
                });
                e.target.value = "";
            }
        } else {
            return;
        }
    }

    saveLineItemLocally(name) {
        let savedLineItems = JSON.parse(localStorage.getItem('oneRoofLineItems')) || [];
        savedLineItems.push(name);
        localStorage.setItem('oneRoofLineItems', JSON.stringify(savedLineItems));
        this.savedLineItems.local = JSON.parse(localStorage.getItem("oneRoofLineItems")) || [];
        this.savedLineItems.initialize(true);
    }
}

LineItemForm.defaultProps = {
    ENTER_KEY_CODE: 13,
    TAB_KEY_CODE: 9
};
