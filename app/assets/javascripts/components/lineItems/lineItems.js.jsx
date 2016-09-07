class LineItems extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <table className="table table-striped line-items-table">
                <thead>
                    <tr>
                        <th className="line-item-name-header">Item</th>
                        <th>Quantity</th>
                        <th>Est. Rate</th>
                        <th>Price</th>
                    </tr>
                </thead>
                <tbody>
                    {this.props.lineItems.map((lineItem) => {
                        return(
                            <LineItem
                                key={`lineItem-${lineItem.id}`}
                                lineItem={lineItem}
                                updateLineItem = {this.props.updateLineItem}
                                />
                        );
                    })}
                    <LineItemForm
                        document = {this.props.document}
                        createLineItem = {this.props.createLineItem}
                        sectionId = {this.props.sectionId}
                        />
                </tbody>
            </table>
        );
    }
}

LineItems.defaultProps = {
    lineItems: []
};
