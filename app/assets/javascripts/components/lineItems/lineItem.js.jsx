class LineItem extends React.Component {
    render() {
        return (
            <tr className="line-item-row">
                <td>
                    <p>
                        <input
                            type="text"
                            className="form-control"
                            defaultValue={this.props.lineItem.name}
                            onKeyDown={this.handleKeyDown.bind(this, "name")}
                            onBlur={this.update.bind(this, "name")}
                            />
                    </p>
                    <small>
                        <input
                            type="text"
                            className="form-control"
                            defaultValue={this.props.lineItem.description}
                            onKeyDown={this.handleKeyDown.bind(this, "description")}
                            onBlur={this.update.bind(this, "description")}
                            placeholder="Add specification"
                            />
                    </small>
                </td>
                <td>
                    <input type="text" defaultValue={this.props.lineItem.quantity}
                        onKeyDown={this.handleKeyDown.bind(this, "quantity")}
                        onBlur={this.update.bind(this, "quantity")}
                        />
                </td>
                <td>
                    £{this.props.lineItem.rate}
                </td>
                <td>
                    £{this.calculateLineItemTotal()}
                    <a className="glyphicon glyphicon-trash" onClick={this.props.deleteLineItem.bind(this, this.props.lineItem.id)} />
                </td>
            </tr>
        );
    }

    calculateLineItemTotal() {
        return this.props.lineItem.rate * this.props.lineItem.quantity
    }

    handleKeyDown(attribute, e) {
        if (e.keyCode === this.props.ENTER_KEY_CODE || e.keyCode === this.props.TAB_KEY_CODE) {
            e.preventDefault()
            this.update(attribute, e)
            let inputs = $(':input').not(':button,:hidden,[readonly]');
            let nextInput = inputs.get(inputs.index(e.target) + 1);
            if (nextInput) {
                nextInput.focus();
            }
        }
    }

    update(attribute, e) {
        let lineItemId = this.props.lineItem.id;
        let attributes = {};
        attributes[attribute] = e.target.value.trim();
        this.props.updateLineItem(lineItemId, attributes)
    }
}

LineItem.defaultProps = {
    ENTER_KEY_CODE: 13,
    TAB_KEY_CODE: 9
}
