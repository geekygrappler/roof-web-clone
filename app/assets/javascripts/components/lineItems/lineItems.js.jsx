class LineItems extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <table>
                <thead>
                    <tr>
                        <th>Item</th>
                        <th>Specification</th>
                        <th>Location</th>
                        <th>Quantity</th>
                        <th>Est. Rate</th>
                        <th>Price</th>
                    </tr>
                </thead>
                <tbody>
                    <LineItemForm
                        document = {this.props.document}
                        newLineItem = {this.props.newLineItem}
                        sectionId = {this.props.sectionId}
                        />
                </tbody>
            </table>
        );
    }
}
