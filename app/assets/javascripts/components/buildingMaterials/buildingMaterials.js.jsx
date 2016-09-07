class BuildingMaterials extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <table className="table table-striped">
                <thead>
                    <tr>
                        <th>Item</th>
                        <th>Supplied by Contractor</th>
                        <th>Price</th>
                    </tr>
                </thead>
                <tbody>
                    {this.props.buildingMaterials.map((buildingMaterial) => {
                        return (
                            <BuildingMaterial
                                key={`buildingMaterial-${buildingMaterial.id}`}
                                buildingMaterial={buildingMaterial}
                                updateBuildingMaterial={this.props.updateBuildingMaterial}
                                />
                        )
                    })}
                    <BuildingMaterialForm
                        document={this.props.document}
                        sectionId={this.props.sectionId}
                        createBuildingMaterial={this.props.createBuildingMaterial}
                        />
                </tbody>
            </table>
        )
    }
}

BuildingMaterials.defaultProps = {
    buildingMaterials: []
}
