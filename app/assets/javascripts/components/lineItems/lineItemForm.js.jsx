class LineItemForm extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return(
            <tr>
                <td>
                    <input type="text" onBlur={this.addLineItem.bind(this)} placeholder="Search for an item..." />
                </td>
            </tr>
        )
    }

    addLineItem(e) {
        // Add line item to db as promise
        // take return value and then swap project with it
        debugger;
        this.props.swapDocument()
    }

}
