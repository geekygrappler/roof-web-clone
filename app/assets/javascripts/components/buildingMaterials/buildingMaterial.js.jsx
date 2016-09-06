class BuildingMaterial extends React.Component {

    render() {
        return (
            <tr>
                <td>
                    <p>
                        <input type="text" defaultValue={this.props.buildingMaterial.name}
                            onKeyDown={this.update.bind(this, "name")}
                            />
                    </p>
                </td>
                <td>
                    Location placeholder
                </td>
                <td>
                    supplied placeholder
                </td>
                <td>
                    £{this.props.buildingMaterial.price}
                </td>
            </tr>
        )
    }

    update(attribute, e) {
        if (e.keyCode === this.props.ENTER_KEY_CODE || e.keyCode === this.props.TAB_KEY_CODE) {
            e.preventDefault()

            let inputs = $(':input').not(':button,:hidden,[readonly]');
            let nextInput = inputs.get(inputs.index(e.target) + 1);
            if (nextInput) {
                nextInput.focus();
            }

            let buildingMaterialId = this.props.buildingMaterial.id;
            let attributes = {};
            attributes[attribute] = e.target.value.trim();
            this.props.updateBuildingMaterial(buildingMaterialId, attributes)
        }
    }
}

BuildingMaterial.defaultProps = {
    ENTER_KEY_CODE: 13,
    TAB_KEY_CODE: 9
}
