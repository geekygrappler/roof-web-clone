class LineItemForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            newLineItem: ""
        };
    }

    render() {
        return(
            <tr>
                <td>
                    <input type="text"
                        onChange={this.handleChange.bind(this)}
                        onKeyDown={this.handleKeyDown.bind(this)}
                        value={this.state.newLineItem}
                        placeholder="Search for an item..."
                        autoFocus={true}
                        />
                </td>
            </tr>
        );
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
                    name: name
                };
                this.props.createLineItem(lineItem, this.props.sectionId);
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
