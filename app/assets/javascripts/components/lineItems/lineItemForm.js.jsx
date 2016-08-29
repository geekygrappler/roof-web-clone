class LineItemForm extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return(
            <tr>
                <td>
                    <input type="text" onBlur={this.addLineItem.bind(this, this.props.sectionId)} placeholder="Search for an item..." />
                </td>
            </tr>
        );
    }

    addLineItem(sectionId, e) {
        // Add line item to db as promise
        // take return value and then swap project with it
        let lineItem = {
            name: e.target.value
        };
        this.props.newLineItem(lineItem);
    }

}
