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
            <tr>
                <td>
                    <input className={`line-item-search-${this.props.sectionId}`}
                        onChange={this.handleChange.bind(this)}
                        value={this.state.newLineItem}
                        onKeyDown={this.handleKeyDown.bind(this)}
                        placeholder="Search for an item..."
                        autoFocus={true}
                        />
                </td>
            </tr>
        );
    }

    componentDidMount() {
        var typea = $(`.line-item-search-${this.props.sectionId}`);
        typea.typeahead(null, {
            name: "lineItems",
            source: this.masterLineItems,
            display: 'text',
            templates: {
                empty: [
                    '<div class="empty-message">', 'No Results..', '</div>'
                ].join('\n'),
                suggestion: function(suggestions) {
                    return '<div>' + suggestions.text + '</div>'
                }
            },

        }).bind('typeahead:select', function(obj, data, name) {
            typea.typeahead('val', data.text.replace(/<b>/g, '').replace(/<\/b>/g, ''))
        });
    }

    handleChange(e) {
        this.setState({newLineItem: e.target.value});
    }

    handleKeyDown(e) {
        if (e.keyCode === this.props.ENTER_KEY_CODE || e.keyCode === this.props.TAB_KEY_CODE) {
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
