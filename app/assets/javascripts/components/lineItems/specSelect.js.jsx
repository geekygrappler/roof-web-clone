/*global React*/

class SpecSelect extends React.Component {
    constructor() {
        super();
        this.state = {
            options: []
        };
    }

    render() {
        if (this.state.options.length > 0) {
            return(
                <select>{this.state.options}</select>
            );
        } else {
            return(
                <span>Use Notes Section </span>
            );
        }
    }

    componentDidMount() {
        this.fetchSpecs();
    }

    componentWillReceiveProps(nextProps) {
        if (this.props.itemName != nextProps.itemName) {
            this.fetchSpecs();
        }
    }

    fetchSpecs() {
        fetch(`/search/specs?item_name=${this.props.itemName}`)
        .then((response) => {
            if (response.ok) {
                response.json().then((data) => {
                    this.specSuccessHandler(data);
                });
            }
        });
    }

    specSuccessHandler(data) {
        let optionsArray = [];
        data.results.map((spec) => {
            optionsArray.push(<option key={spec.id} value={spec.id}>{spec.name}</option>);
        });
        this.setState({options: optionsArray});
    }
}
