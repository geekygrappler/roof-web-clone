/*global React Bloodhound $ */

class ActionSelect extends React.Component {
    constructor() {
        super();
        this.state = {
            options: [],
            actionName: ""
        };
    }

    render() {
        if (this.state.options.length > 0) {
            return(
                <select>{this.state.options}</select>
            );
        } else {
            return(
                <input className={`action-search-${this.props.lineItemId} action-input`}
                    placeholder="Add action"
                    value={this.state.actionName}
                    onChange={this.handleChange.bind(this)}
                    onKeyDown={this.handleChange.bind(this)}
                    onBlur={this.handleChange.bind(this)}
                    />
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
        if (data.results.length == 0) {
            this.setupSearchRemote();
        } else {
            data.results.map((action) => {
                optionsArray.push(<option key={action.id} value={action.id}>{action.name}</option>);
            });
            this.setState({options: optionsArray});
        }
    }

    setupSearchRemote() {
        fetch("/actions")
        .then((response) => {
            if (response.ok) {
                response.json().then((data) => {
                    let actionsList = new Bloodhound({
                        datumTokenizer: Bloodhound.tokenizers.whitespace,
                        queryTokenizer: Bloodhound.tokenizers.whitespace,
                        local: data.actions
                    });
                    $(`.action-search-${this.props.lineItemId}`).typeahead(
                        {
                            highlight: true,
                            hint: true,
                            minLength: 1
                        },
                        {
                            source: actionsList,
                            display: "name"
                        }
                    );
                });
            }
        });
    }

    handleChange(e) {
        this.setState({actionName: e.target.value}, this.createNewAction(e));
    }

    createNewAction(e) {
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
            fetch("/actions", {
                method: "POST",
                headers: new Headers({
                    "Content-Type": "application/json"
                }),
                body: JSON.stringify({
                    xaction: {
                        name: this.state.actionName,
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

ActionSelect.defaultProps = {
    ENTER_KEY_CODE: 13,
    TAB_KEY_CODE: 9
};
