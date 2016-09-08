class BuildingMaterial extends React.Component {

    render() {
        return (
            <tr className="building-material-row">
                <td>
                    <p>
                        <input
                            type="text"
                            className="form-control item-input"
                            defaultValue={this.props.buildingMaterial.name}
                            onKeyDown={this.handleKeyDown.bind(this, "name")}
                            onBlur={this.update.bind(this, "name")}
                            />
                    </p>
                </td>
                <td>
                    <select className="form-control"
                        defaultValue={this.props.buildingMaterial.supplied || ""}
                        onChange={this.update.bind(this, "supplied")}>
                        <option value="" disabled>Who will supply this material?</option>
                        <option value="true">Client</option>
                        <option value="false">Contractor</option>
                    </select>
                </td>
                <td>
                    {this.renderMaterialCost()}
                    <a className="glyphicon glyphicon-trash" onClick={this.props.deleteBuildingMaterial.bind(this, this.props.buildingMaterial.id)} />
                </td>
            </tr>
        )
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
        let buildingMaterialId = this.props.buildingMaterial.id;
        let attributes = {};
        attributes[attribute] = e.target.value.trim();
        this.props.updateBuildingMaterial(buildingMaterialId, attributes)
    }

renderMaterialCost() {
        if (this.props.buildingMaterial.supplied) {
            return (
                <div className="col-xs-9 price-input">
                    <div className="form-inline">
                        <div className="form-group">
                            <label htmlFor={`buildng-materail-${this.props.buildingMaterial.id}`}>£</label>
                            <input
                                type="text"
                                id={`buildng-materail-${this.props.buildingMaterial.id}`}
                                className="form-control"
                                defaultValue={this.props.buildingMaterial.price}
                                placeholder="0"
                                onKeyDown={this.handleKeyDown.bind(this, "price")}
                                onBlur={this.update.bind(this, "price")}
                                />
                        </div>
                    </div>
                </div>
            );
        } else {
            return (
                <span>
                    To be quoted
                </span>
            )
        }
    }
}

BuildingMaterial.defaultProps = {
    ENTER_KEY_CODE: 13,
    TAB_KEY_CODE: 9
}
