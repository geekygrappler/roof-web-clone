class BuildingMaterialForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            newBuildingMaterial: ""
        };
    }

    render() {
        return(
            <tr>
                <td>
                    <input className={`building-material-search-${this.props.sectionId}`}
                        onChange={this.handleChange.bind(this)}
                        value={this.state.newBuildingMaterial}
                        onKeyDown={this.handleKeyDown.bind(this)}
                        placeholder="Add a building material"
                        autoFocus={true}
                        />
                </td>
            </tr>
        );
    }

    handleChange(e) {
        this.setState({newBuildingMaterial: e.target.value});
    }

    handleKeyDown(e) {
        if (e.keyCode === this.props.ENTER_KEY_CODE || e.keyCode === this.props.TAB_KEY_CODE) {
            e.preventDefault();

            let name = e.target.value.trim();

            if (name) {
                let buildingMaterial = {
                    name: name,
                    section_id: this.props.sectionId
                };
                this.props.createBuildingMaterial(buildingMaterial);
                this.setState({newBuildingMaterial: ""});
                e.target.value = "";
            }
        } else {
            return;
        }
    }
}

BuildingMaterialForm.defaultProps = {
    ENTER_KEY_CODE: 13,
    TAB_KEY_CODE: 9
};
