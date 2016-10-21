class LineItems extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <div className="row">
                <div className="col-xs-12">
                    {this.renderTable()}
                </div>
            </div>
        );
    }

    renderTable() {
        return (
            <table className="table table-striped line-items-table">
                <thead>
                    <tr>
                        <th className="line-item-action-header">Action</th>
                        <th className="line-item-name-header">Item</th>
                        <th className="line-item-spec-header">Spec.</th>
                        <th className="line-item-notes-header">Notes</th>
                        <th className="line-item-quantity-header">Quant.</th>
                        <th className="line-item-unit-header">Units</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    {this.props.lineItems.map((lineItem) => {
                        return(
                            <LineItem
                                key={`lineItem-${lineItem.id}`}
                                lineItem={lineItem}
                                document={this.props.document}
                                updateLineItem = {this.props.updateLineItem}
                                deleteLineItem = {this.props.deleteLineItem}
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
