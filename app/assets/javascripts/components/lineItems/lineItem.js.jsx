class LineItem extends React.Component {
    render() {
        return (
            <tr>
                <td>
                    <p>
                        <input type="text"
                            defaultValue={this.props.lineItem.name}
                            onKeyDown={this.update.bind(this, "name")}
                            />
                    </p>
                    <small>
                        <input type="text"
                            defaultValue={this.props.lineItem.description}
                            onKeyDown={this.update.bind(this, "description")}
                            placeholder="Add specification"
                            />
                        </small>
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
        if (e.keyCode === this.props.ENTER_KEY_CODE || e.keyCode === this.props.TAB_KEY_CODE) {
            e.preventDefault()

            let inputs = $(':input').not(':button,:hidden,[readonly]');
            let nextInput = inputs.get(inputs.index(e.target) + 1);
            if (nextInput) {
                nextInput.focus();
            }

            let lineItemId = this.props.lineItem.id;
            let attributes = {};
            attributes[attribute] = e.target.value.trim();
            this.props.updateLineItem(lineItemId, attributes)
        }
    }
}

LineItem.defaultProps = {
    ENTER_KEY_CODE: 13,
    TAB_KEY_CODE: 9
}
