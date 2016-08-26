class LineItemForm extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return(
            <tr>
                <td>
                    <input type="text" onBlur={this.props.addLineItem} placeholder="Search for an item..." />
                </td>
            </tr>
        )
    }

}
