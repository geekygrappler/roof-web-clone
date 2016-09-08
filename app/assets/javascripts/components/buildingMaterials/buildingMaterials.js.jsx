class BuildingMaterials extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        let table = null;
        if (this.props.buildingMaterials.length > 0) {
            table = this.renderTable();
        }
        return (
            <div className="row">
                <div className="col-xs-12">
                    {table}
                    <BuildingMaterialForm
                        document={this.props.document}
                        sectionId={this.props.sectionId}
                        createBuildingMaterial={this.props.createBuildingMaterial}
                        />
                </div>
            </div>
        )
    }

    renderTable() {
        return (
            <table className="table table-striped building-materials-table">
                <thead>
                    <tr>
                        <th className="building-material-name-header">Item</th>
                        <th className="building-material-supplied-header">Supplied by Contractor</th>
                        <th className="building-material-price-header">Price</th>
                    </tr>
                </thead>
                <tbody>
                    {this.props.buildingMaterials.map((buildingMaterial) => {
                        return (
                            <BuildingMaterial
                                key={`buildingMaterial-${buildingMaterial.id}`}
                                buildingMaterial={buildingMaterial}
                                updateBuildingMaterial={this.props.updateBuildingMaterial}
                                deleteBuildingMaterial={this.props.deleteBuildingMaterial}
                                />
                        )
                    })}
                </tbody>
            </table>
        );
    }
}

BuildingMaterials.defaultProps = {
    buildingMaterials: []
}
