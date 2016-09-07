class BuildingMaterialForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            newBuildingMaterial: ""
        };
        this.masterBuildingMaterials = new Bloodhound({
            datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            local: [
                "Bricks", "Mortar", "Cement", "Chinese Chintz"
            ]
        })
    }

    render() {
        return(
            <div>
                <span className="glyphicon glyphicon-plus" aria-hidden="true"></span>
                <input className={`building-material-search-${this.props.sectionId} form-control`}
                    onChange={this.handleChange.bind(this)}
                    value={this.state.newBuildingMaterial}
                    onKeyDown={this.handleKeyDown.bind(this)}
                    placeholder="Add a building material"
                    autoFocus={true}
                    />
            </div>
        );
    }

    componentDidMount() {
        $(`.building-material-search-${this.props.sectionId}`).typeahead({highlight: true}, {
            name: "buildingMaterials",
            source: this.masterBuildingMaterials
        });
    }

    handleChange(e) {
        this.setState({newBuildingMaterial: e.target.value});
    }

    handleKeyDown(e) {
        if (e.keyCode === this.props.ENTER_KEY_CODE || e.keyCode === this.props.TAB_KEY_CODE) {
            if (e.target.value.length === 0) {
                return;
            }
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
