class LineItem extends React.Component {
    render() {
        return (
            <tr>
                <td>
                    <input type="text" defaultValue={this.props.lineItem.name} />
                </td>
            </tr>
        );
    }
}
