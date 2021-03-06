class LineItemForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            newLineItem: ""
        };
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
        return(
            <div className="col-md-8">
                <div className="form-group">
                    <span className="glyphicon glyphicon-plus" aria-hidden="true"></span>
                    <input className={`line-item-search-${this.props.sectionId} form-control`}
                        onChange={this.handleChange.bind(this)}
                        value={this.state.newLineItem}
                        onKeyDown={this.handleKeyDown.bind(this)}
                        placeholder="Search for an item..."
                        autoFocus={true}
                        />
                </div>
            </div>
        );
    }

    componentDidMount() {
        $(`.line-item-search-${this.props.sectionId}`).typeahead({highlight: true}, {
            name: "lineItems",
            source: this.masterLineItems,
            display: 'name'
        });
    }

    handleChange(e) {
        this.setState({newLineItem: e.target.value});
    }

    handleKeyDown(e) {
        if (e.keyCode === this.props.ENTER_KEY_CODE || e.keyCode === this.props.TAB_KEY_CODE) {
            if (e.target.value.length === 0) {
                return;
            }
            e.preventDefault();

            let name = e.target.value.trim();

            if (name) {
                let lineItem = {
                    name: name,
                    section_id: this.props.sectionId
                };
                this.props.createLineItem(lineItem);
                this.setState({newLineItem: ""});
                e.target.value = "";
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
