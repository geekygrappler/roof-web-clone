class LineItem extends React.Component {
    render() {
        return (
            <tr>
                <td>
                    <input type="text" defaultValue={this.props.lineItem.name} />
                </td>
                <td>
                    {this.props.lineItem.description}
                </td>
                <td>
                    Location placeholder
                </td>
                <td>
                    <input type="text" defaultValue={this.props.lineItem.quantity} onBlur={this.update.bind(this, "quantity")} />
                </td>
                <td>
                    £{this.props.lineItem.rate}
                </td>
                <td>
                    £{this.calculateLineItemTotal()}
                </td>
            </tr>
        );
    }

    calculateLineItemTotal() {
        return this.props.lineItem.rate * this.props.lineItem.quantity
    }

    update(attribute, e) {
        let lineItemId = this.props.lineItem.id;
        let attributes = {};
        attributes[attribute] = e.target.value;
        this.props.updateLineItem(lineItemId, attributes)
    }
}
