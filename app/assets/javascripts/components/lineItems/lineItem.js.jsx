class LineItem extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            quantity: this.props.lineItem.quantity
        }
        this.masterLineItems = new Bloodhound({
            datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            remote: {
                url: '/search/line_items?query=%QUERY',
                wildcard: '%QUERY',
                transform: (data) => {
                    return data.results
                }
            }
        });
    }

    render() {
        return (
            <tr className="line-item-row">
                <td>
                    <textarea
                        type="text"
                        className={`form-control item-input line-item-name-${this.props.lineItem.id}`}
                        defaultValue={this.props.lineItem.name}
                        onKeyDown={this.handleKeyDown.bind(this, "name")}
                        onBlur={this.update.bind(this, "name")}
                        />
                </td>
                <td>
                    <textarea
                        type="text"
                        className="form-control item-input line-item-notes"
                        defaultValue={this.props.lineItem.description}
                        onKeyDown={this.handleKeyDown.bind(this, "description")}
                        onBlur={this.update.bind(this, "description")}
                        placeholder="Add notes"
                        />
                </td>
                <td>
                    <input
                        type="text"
                        className="form-control line-item-quantity"
                        value={this.renderQuantity()}
                        onChange={this.handleChange.bind(this)}
                        onKeyDown={this.handleKeyDown.bind(this, "quantity")}
                        onBlur={this.update.bind(this, "quantity")}
                        />
                </td>
                <td>
                    <a className="glyphicon glyphicon-trash" onClick={this.props.deleteLineItem.bind(this, this.props.lineItem.id)} />
                </td>
            </tr>
        );
    }

    componentDidMount() {
        $(`.line-item-name-${this.props.lineItem.id}`).typeahead({highlight: true}, {
            name: "lineItems",
            source: this.masterLineItems,
            display: 'name'
        });
    }

    handleChange(e) {
        let quantity = isNaN(parseInt(e.target.value)) ? 1 : parseInt(e.target.value);
        if (e.target.value == "m\u00b2" || e.target.value == "m") {
            quantity = e.target.value;
        }
        this.setState({quantity: quantity});
    }

    renderQuantity() {
        let quantity = this.state.quantity;
        if (this.props.lineItem.unit) {
            if (this.props.lineItem.unit.abbreviation) {
                quantity += this.props.lineItem.unit.abbreviation;
            }
            if (this.props.lineItem.unit.power) {
                quantity += `\u00b2`;
            }
        }
        // If we're mid edit, don't interfere
        if (this.state.quantity == "m\u00b2" || this.state.quantity == "m") {
            quantity = "m\u00b2";
        }
        return quantity;
    }

    handleKeyDown(attribute, e) {
        if (e.keyCode === this.props.ENTER_KEY_CODE || e.keyCode === this.props.TAB_KEY_CODE) {
            e.preventDefault()
            this.update(attribute, e)
            let inputs = $(':input').not(':button,:hidden,[readonly]');
            let nextInput = inputs.get(inputs.index(e.target) + 1);
            if (nextInput) {
                nextInput.focus();
            }
        }
    }

    update(attribute, e) {
        let lineItemId = this.props.lineItem.id;
        let attributes = {};
        attributes[attribute] = e.target.value.trim();
        this.props.updateLineItem(lineItemId, attributes)
    }
}

LineItem.defaultProps = {
    ENTER_KEY_CODE: 13,
    TAB_KEY_CODE: 9
}
