/*global React*/

class LineItem extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            lineItem: {
                name: this.props.lineItem.name || "",
                description: this.props.lineItem.description || "",
                quantity: this.props.lineItem.quantity || 1,
                unit: this.props.lineItem.unit || "",
                action_id: this.props.lineItem.action_id || 1,
            },
        };
        this.savedLineItems = new Bloodhound({
            datumTokenizer: Bloodhound.tokenizers.whitespace,
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            local: JSON.parse(localStorage.getItem("oneRoofLineItems")) || []
        });
    }

    render() {
        return (
            <tr className="line-item-row">
                <td>
                    <select onChange={this.handleChange.bind(this, "action_id")} value={this.state.lineItem.action_id} className={`line-item-action-${this.props.lineItem.id}`}>
                        <option value="1">Install</option>
                        <option value="2">Remove</option>
                    </select>
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
                        />
                </td>
                <td>
                    <textarea
                        type="text"
                        className="form-control item-input line-item-notes"
                        value={this.state.lineItem.description}
                        onChange={this.handleChange.bind(this, "description")}
                        onKeyDown={this.handleKeyDown.bind(this, "description")}
                        onBlur={this.update.bind(this, "description")}
                        placeholder="Add notes"
                        />
                </td>
                <td>
                    <input
                        type="text"
                        className="form-control line-item-quantity"
                        value={this.state.lineItem.quantity}
                        onChange={this.handleChange.bind(this, "quantity")}
                        onKeyDown={this.handleKeyDown.bind(this, "quantity")}
                        onBlur={this.update.bind(this, "quantity")}
                        />
                </td>
                <td>
                    <input
                        type="text"
                        className="form-control line-item-unit"
                        value={this.state.lineItem.unit}
                        onChange={this.handleChange.bind(this, "unit")}
                        onKeyDown={this.handleKeyDown.bind(this, "unit")}
                        onBlur={this.update.bind(this, "unit")}
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
        this.setState({lineItem: nextState}, this.handleKeyDown(attribute, e));
    }

    handleKeyDown(attribute, e) {
        if (e.keyCode === this.props.ENTER_KEY_CODE ||
            e.keyCode === this.props.TAB_KEY_CODE ||
            e.type == "blur" ||
            (e.type == "change" && attribute == "action_id")) {
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

        this.props.updateLineItem(lineItemId, this.state.lineItem);
        this.saveLineItemLocally(this.state.lineItem.name);
    }

    saveLineItemLocally(name) {
        let savedLineItems = JSON.parse(localStorage.getItem('oneRoofLineItems')) || [];
        savedLineItems.push(name);
        localStorage.setItem('oneRoofLineItems', JSON.stringify(savedLineItems));
        this.savedLineItems.local = JSON.parse(localStorage.getItem("oneRoofLineItems")) || [];
        this.savedLineItems.initialize(true);
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
                url: `/search/items?query=`,
                prepare: (query, settings) => {
                    return settings.url += `${query}&action_id=${this.state.lineItem.action_id}`;
                },
                transform: (data) => {
                    return data.results
                }
            }
        });
    }

    renderSpecSelect() {
        return fetch(`/search/specs?item_name=${this.state.lineItem.name}`)
        .then((response) => {
            if (response.ok) {
                response.json().then((data) => {
                    if (data.results.length > 0) {
                        return (
                            <select onChange={this.handleChange.bind(this, "spec_id")} value={this.state.lineItem.spec_id}>
                                {data.results.map((spec) => {
                                    return (
                                        <option key={spec.id} value={spec.id}>{spec.name}</option>
                                    )
                                })}
                            </select>
                        );
                    } else {
                        return null;
                    }
                });
            }
        });
    }
}

LineItem.defaultProps = {
    ENTER_KEY_CODE: 13,
    TAB_KEY_CODE: 9
}
