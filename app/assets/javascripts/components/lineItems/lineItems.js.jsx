class LineItems extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        let table = null;
        if (this.props.lineItems.length > 0) {
            table = this.renderTable();
        }

        return (
            <div className="row">
                <div className="col-xs-12">
                    {table}
                    <LineItemForm
                        document = {this.props.document}
                        createLineItem = {this.props.createLineItem}
                        sectionId = {this.props.sectionId}
                        />
                </div>
            </div>
        );
    }

    renderTable() {
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
                                deleteLineItem = {this.props.deleteLineItem}
                                />
                        );
                    })}
                </tbody>
            </table>
        );
    }
}

LineItems.defaultProps = {
    lineItems: []
};
