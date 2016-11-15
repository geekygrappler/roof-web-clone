/* global React */

class LineItemList extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <div>
                <div className="row">
                    <div className="col-xs-12">
                        {this.renderTable()}
                    </div>
                </div>
                <div className="row">
                    <div className="col-xs-12">
                        <LineItemForm
                            document = {this.props.document}
                            createLineItem = {this.props.createLineItem}
                            location={this.props.location}
                            stage={this.props.stage}
                            location={this.props.location}
                            />
                    </div>
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
                        <th className="line-item-location-header">Location</th>
                        <th className="line-item-rate-header">Rate</th>
                        <th className="line-item-quantity-header">Quant.</th>
                        <th className="line-item-unit-header">Units</th>
                        <th className="line-item-total-header">Total</th>
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
                                fetchDocument={this.props.fetchDocument}
                                />
                        );
                    })}
                </tbody>
            </table>
        );
    }
}

LineItemList.defaultProps = {
    lineItems: []
};
