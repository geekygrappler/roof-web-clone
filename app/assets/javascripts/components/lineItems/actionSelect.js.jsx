/*global React */

class ActionSelect extends React.Component {
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
                <span>N/A</span>
            );
        }
    }

    componentDidMount() {
        this.fetchActions();
    }

    componentWillReceiveProps(nextProps) {
        if (this.props.itemName != nextProps.itemName) {
            this.fetchActions();
        }
    }

    fetchActions() {
        fetch(`/search/actions?item_name=${this.props.itemName}`)
        .then((response) => {
            if (response.ok) {
                response.json().then((data) => {
                    this.actionSuccessHandler(data);
                });
            }
        });
    }

    actionSuccessHandler(data) {
        let optionsArray = [];
        data.results.map((action) => {
            optionsArray.push(<option key={action.id} value={action.id}>{action.name}</option>);
        });
        this.setState({options: optionsArray});
    }
}
