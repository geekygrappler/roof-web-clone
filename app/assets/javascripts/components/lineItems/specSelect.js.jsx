/*global React*/

class SpecSelect extends React.Component {
    constructor() {
        super();
        this.state = {
            options: [],
            specName: ""
        };
    }

    render() {
        if (this.state.options.length > 0) {
            return(
                <select>{this.state.options}</select>
            );
        } else {
            return(
                <input className={`spec-search-${this.props.lineItemId} action-input`}
                    placeholder="Add spec"
                    value={this.state.specName}
                    onChange={this.handleChange.bind(this)}
                    onKeyDown={this.handleChange.bind(this)}
                    onBlur={this.handleChange.bind(this)}
                    />
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
        if (data.results.length == 0) {
            return;
        } else {
            data.results.map((spec) => {
                optionsArray.push(<option key={spec.id} value={spec.id}>{spec.name}</option>);
            });
            this.setState({options: optionsArray});
        }
    }

    handleChange(e) {
        this.setState({specName: e.target.value}, this.createNewspec(e));
    }

    createNewspec(e) {
        if ((e.keyCode === this.props.ENTER_KEY_CODE ||
            e.keyCode === this.props.TAB_KEY_CODE ||
            e.type == "blur") && e.target.value.length > 0) {
            e.preventDefault();
            if (e.keyCode === this.props.TAB_KEY_CODE || e.keyCode === this.props.ENTER_KEY_CODE) {
                let inputs = $(":input").not(":button,:hidden,[readonly]");
                let nextInput = inputs.get(inputs.index(e.target) + 1);
                if (nextInput) {
                    nextInput.focus();
                }
            }
            fetch("/specs", {
                method: "POST",
                headers: new Headers({
                    "Content-Type": "application/json"
                }),
                body: JSON.stringify({
                    spec: {
                        name: this.state.specName,
                        item_name: this.props.itemName
                    }
                })
            }).then(() => {
                // this doesn't work because we're not changing item name and
                // not checking to see if we have any new specs in the database
                this.forceUpdate();
            });
        }
    }
}

SpecSelect.defaultProps = {
    ENTER_KEY_CODE: 13,
    TAB_KEY_CODE: 9
};
