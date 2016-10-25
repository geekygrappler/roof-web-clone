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
        this.searchItems = new Bloodhound({
            datumTokenizer: Bloodhound.tokenizers.whitespace,
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            remote: {
                url: `/search/items?query=`,
                prepare: (query, settings) => {
                    return settings.url += `${query}`;
                },
                transform: (data) => {
                    return data.results
                }
            }
        });
    }

    render() {
        return(
            <tr>
                <td colSpan="3">
                    <input className={`line-item-search-${this.props.sectionId} form-control`}
                        onChange={this.handleChange.bind(this, "name")}
                        onKeyDown={this.handleChange.bind(this, "name")}
                        value={this.state.lineItem.name}
                        onBlur={this.handleChange.bind(this, "name")}
                        placeholder="Search for an item..."
                        autoFocus={true}
                        />
                </td>
                <td>
                </td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
        );
    }

    componentDidMount() {
        $(`.line-item-search-${this.props.sectionId}`).typeahead({highlight: true, hint: true, minLength: 1}, {
            source: this.searchItems,
            display: "name"
        });
    }

    handleChange(attribute, e) {
        let nextState = this.state.lineItem;
        nextState[attribute] = e.target.value;
        this.setState({lineItem: nextState}, this.handleKeyDown(attribute, e));
    }

    handleKeyDown(attribute, e) {
        if (e.keyCode === this.props.ENTER_KEY_CODE || e.keyCode === this.props.TAB_KEY_CODE || e.type == "blur") {
            if (e.target.value.length === 0) {
                return;
            }
            e.preventDefault();

            if (attribute == "name") {
                let lineItem = this.state.lineItem;
                this.props.createLineItem(lineItem);
                let nextState = lineItem;
                lineItem[attribute] = "";
                this.setState({lineItem: nextState});
            }
        } else {
            return;
        }
    }
}

LineItemForm.defaultProps = {
    ENTER_KEY_CODE: 13,
    TAB_KEY_CODE: 9
};
