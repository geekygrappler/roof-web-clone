/*global React Bloodhound $ accounting*/

class LineItem extends React.Component {
    constructor(props) {
        super(props);
        this.state = props.lineItem;
    }

    render() {
        return (
            <tr className="line-item-row">
                <td>
                    <RemoteModelSelect
                        itemName={this.state.name}
                        lineItemId={this.props.lineItem.id}
                        modelName="item_action"
                        model={this.state.item_action}
                        updateLineItem={this.updateRelatedModel.bind(this, "item_action")}
                        />
                </td>
                <td>
                    <textarea
                        type="text"
                        className={`form-control item-input line-item-name-${this.props.lineItem.id}`}
                        value={this.state.name}
                        onChange={this.handleChange.bind(this, "name")}
                        onKeyDown={this.handleChange.bind(this, "name")}
                        onBlur={this.handleChange.bind(this, "name")}
                        />
                </td>
                <td>
                    <RemoteModelSelect
                        itemName={this.state.name}
                        lineItemId={this.props.lineItem.id}
                        modelName="item_spec"
                        model={this.state.item_spec}
                        updateLineItem={this.updateRelatedModel.bind(this, "item_spec")}
                        />
                </td>
                <td>
                    <LocationSelect
                        documentId={this.props.document.id}
                        lineItemId={this.props.lineItem.id}
                        model={this.state.location}
                        updateLineItem={this.updateRelatedModel.bind(this, "location")}
                        />
                </td>
                <td>
                    <input
                        type="text"
                        className={`form-control line-item-rate-${this.props.id}`}
                        value={this.state.rate}
                        onChange={this.handleChange.bind(this, "rate")}
                        onKeyDown={this.handleChange.bind(this, "rate")}
                        onBlur={this.handleChange.bind(this, "rate")}
                        />
                </td>
                <td>
                    <input
                        type="text"
                        className="form-control line-item-quantity"
                        value={this.state.quantity}
                        onChange={this.handleChange.bind(this, "quantity")}
                        onKeyDown={this.handleChange.bind(this, "quantity")}
                        onBlur={this.handleChange.bind(this, "quantity")}
                        />
                </td>
                <td>
                    <input
                        type="text"
                        className="form-control line-item-unit"
                        value={this.state.unit}
                        onChange={this.handleChange.bind(this, "unit")}
                        onKeyDown={this.handleChange.bind(this, "unit")}
                        onBlur={this.handleChange.bind(this, "unit")}
                        />
                </td>
                <td>
                    <input
                        type="text"
                        className="form-control line-item-unit"
                        value={this.state.total}
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
        let nextState = this.state;
        nextState[attribute] = e.target.value;
        if (attribute == "rate" || attribute == "quantity") {
            this.calculateTotal(nextState);
        }
        if (attribute == "total") {
            this.calculateRate(nextState);
        }
        this.setState(nextState, this.handleKeyDown(attribute, e));
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
        this.props.updateLineItem(lineItemId, this.state);
    }

    updateRelatedModel(modelName, model) {
        let nextState = this.state;
        nextState[modelName] = model;
        this.setState(nextState, this.update());
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
                    return settings.url += `${query}&item_action_id=${this.state.item_action.id}`;
                },
                transform: (data) => {
                    return data.results;
                }
            }
        });
    }

    calculateTotal(lineItem) {
        let rate = accounting.unformat(lineItem.rate);
        let quantity = accounting.unformat(lineItem.quantity);
        let total = rate * quantity;
        lineItem.total = accounting.formatMoney(total, "£");
    }

    calculateRate(lineItem) {
        let total = accounting.unformat(lineItem.total);
        let quantity = accounting.unformat(lineItem.quantity);
        let rate = total / quantity;
        lineItem.rate = accounting.formatMoney(rate, "£");
    }
}

LineItem.defaultProps = {
    ENTER_KEY_CODE: 13,
    TAB_KEY_CODE: 9
};
