/*global React Bloodhound $ localStorage*/

class LineItem extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            lineItem: {
                name: this.props.lineItem.name || "",
                description: this.props.lineItem.description || "",
                quantity: this.props.lineItem.quantity || 1,
                unit: this.props.lineItem.unit || "",
                action_id: this.props.lineItem.action_id,
                rate: this.props.lineItem.rate || 0,
                total: this.props.lineItem.total || 0
            },
        };
    }

    render() {
        return (
            <tr className="line-item-row">
                <td>
                    <ActionSelect
                        onChange={this.handleChange.bind(this, "action_id")}
                        itemName={this.state.lineItem.name}
                        lineItemId={this.props.lineItem.id}
                        fetchDocument={this.props.fetchDocument}
                        />
                </td>
                <td>
                    <textarea
                        type="text"
                        className={`form-control item-input line-item-name-${this.props.lineItem.id}`}
                        value={this.state.lineItem.name}
                        onChange={this.handleChange.bind(this, "name")}
                        onKeyDown={this.handleChange.bind(this, "name")}
                        onBlur={this.handleChange.bind(this, "name")}
                        />
                </td>
                <td>
                    <SpecSelect
                        onChange={this.handleChange.bind(this, "spec_id")}
                        itemName={this.state.lineItem.name}
                        lineItemId={this.state.lineItem.id}
                        />
                </td>
                <td>
                    <textarea
                        type="text"
                        className="form-control item-input line-item-notes"
                        value={this.state.lineItem.description}
                        onChange={this.handleChange.bind(this, "description")}
                        onKeyDown={this.handleChange.bind(this, "description")}
                        onBlur={this.handleChange.bind(this, "description")}
                        placeholder="Add notes"
                        />
                </td>
                <td>
                    <input
                        type="text"
                        className={`form-control line-item-rate-${this.props.lineItem.id}`}
                        value={this.state.lineItem.rate}
                        onChange={this.handleChange.bind(this, "rate")}
                        onKeyDown={this.handleChange.bind(this, "rate")}
                        onBlur={this.handleChange.bind(this, "rate")}
                        />
                </td>
                <td>
                    <input
                        type="text"
                        className="form-control line-item-quantity"
                        value={this.state.lineItem.quantity}
                        onChange={this.handleChange.bind(this, "quantity")}
                        onKeyDown={this.handleChange.bind(this, "quantity")}
                        onBlur={this.handleChange.bind(this, "quantity")}
                        />
                </td>
                <td>
                    <input
                        type="text"
                        className="form-control line-item-unit"
                        value={this.state.lineItem.unit}
                        onChange={this.handleChange.bind(this, "unit")}
                        onKeyDown={this.handleChange.bind(this, "unit")}
                        onBlur={this.handleChange.bind(this, "unit")}
                        />
                </td>
                <td>
                    <input
                        type="text"
                        className="form-control line-item-unit"
                        value={this.state.lineItem.total}
                        onChange={this.handleChange.bind(this, "total")}
                        onKeyDown={this.handleChange.bind(this, "total")}
                        onBlur={this.handleChange.bind(this, "total")}
                        />
                </td>
                <td>
                    <a className="glyphicon glyphicon-trash" onClick={this.props.deleteLineItem.bind(this, this.props.lineItem.id)} />
                </td>
            </tr>
        );
    }

    componentDidMount() {
        this.setupSearchRemotes();
        $(`.line-item-name-${this.props.lineItem.id}`).typeahead({highlight: true}, {
            source: this.searchItems,
            display: "name"
        });
    }

    /*
        All changes need to come through here before going to
        handleKeyDown() otherwise we might be updating our line item
        without up to date attributes
    */
    handleChange(attribute, e) {
        let nextState = this.state.lineItem;
        nextState[attribute] = e.target.value;
        if (attribute == "rate" || attribute == "quantity") {
            this.calculateTotal(nextState);
        }
        if (attribute == "total") {
            this.calculateRate(nextState);
        }
        this.setState({lineItem: nextState}, this.handleKeyDown(attribute, e));
    }

    handleKeyDown(attribute, e) {
        if (e.keyCode === this.props.ENTER_KEY_CODE ||
            e.keyCode === this.props.TAB_KEY_CODE ||
            e.type == "blur" ||
            (e.type == "change" && attribute == "action_id") ||
            (e.type == "change" && attribute == "spec_id")) {
            e.preventDefault();
            this.update(attribute, e);
            if (e.keyCode === this.props.TAB_KEY_CODE || e.keyCode === this.props.ENTER_KEY_CODE) {
                let inputs = $(":input").not(":button,:hidden,[readonly]");
                let nextInput = inputs.get(inputs.index(e.target) + 1);
                if (nextInput) {
                    nextInput.focus();
                }
            }
        }
    }

    update() {
        let lineItemId = this.props.lineItem.id;
        this.props.updateLineItem(lineItemId, this.state.lineItem);
    }

    /*
        Setup Bloodhound search remotes
        This will need to change when some params change on the component, e.g. action_id
    */
    setupSearchRemotes() {
        this.searchItems = new Bloodhound({
            datumTokenizer: Bloodhound.tokenizers.whitespace,
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            remote: {
                url: "/search/items?query=",
                prepare: (query, settings) => {
                    return settings.url += `${query}&action_id=${this.state.lineItem.action_id}`;
                },
                transform: (data) => {
                    return data.results;
                }
            }
        });
    }

    calculateTotal(lineItem) {
        let rate = parseFloat(lineItem.rate.replace("£", ""));
        let quantity = parseFloat(lineItem.quantity);
        lineItem.total = `£${rate * quantity}` || "£0";
    }

    calculateRate(lineItem) {
        let total = parseFloat(lineItem.total.replace("£", ""));
        let quantity = parseFloat(lineItem.quantity);
        lineItem.rate = `£${total / quantity}` || "£0";
    }
}

LineItem.defaultProps = {
    ENTER_KEY_CODE: 13,
    TAB_KEY_CODE: 9
};
