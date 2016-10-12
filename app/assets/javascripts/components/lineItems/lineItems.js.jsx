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
                        <th className="line-item-notes-header">Notes</th>
                        <th className="line-item-quantity-header">Quantity</th>
                        <th></th>
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
