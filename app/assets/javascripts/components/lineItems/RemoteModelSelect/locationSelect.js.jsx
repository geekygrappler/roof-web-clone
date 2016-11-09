/*global React $*/

class LocationSelect extends React.Component {
    constructor(props) {
        super(props);
        this.state = this.props.model || { name: "" };
    }

    render() {
        return (
            <input
                className={`location-search-${this.props.lineItemId} location-input`}
                value={this.state.name}
                onChange={this.handleChange.bind(this)}
                onKeyDown={this.handleChange.bind(this)}
                onBlur={this.handleChange.bind(this)}
                />
        );
    }

    componentDidMount() {
        this.fetchRecords();
    }

    handleChange(e) {
        this.setState({ name: e.target.value }, this.handleKeyDown(e));
    }

    handleKeyDown(e) {
        if (e.keyCode === this.props.ENTER_KEY_CODE) {
            let inputs = $(":input").not(":button,:hidden,[readonly]");
            let nextInput = inputs.get(inputs.index(e.target) + 1);
            if (nextInput) {
                nextInput.focus();
            }
        }
        if (this.shouldSubmitRecord(e) && this.recordHasChanged(e)) {
            this.submitRecord(e);
        }
    }

    fetchRecords() {
        return fetch(`/search/locations?document_id=${this.props.documentId}`)
        .then((response) => {
            response.json().then((data) => {
                this.records = data.results;
                $(`.location-search-${this.props.lineItemId}`).typeahead(
                    {
                        highlight: true,
                        minLength: 0,
                        limit: 20
                    },
                    {
                        display: "name",
                        source: (q, cb) => {
                            cb(data.results);
                        }
                    }
                );
            });
        });
    }

    // User has hit tab or enter indicating they want to submit this value.
    shouldSubmitRecord(e) {
        const {ENTER_KEY_CODE, TAB_KEY_CODE} = this.props;
        const {keyCode} = e;
        return (
            keyCode === ENTER_KEY_CODE || keyCode === TAB_KEY_CODE || e.type == "blur"
        );
    }

    // No point submitting if the model name has not changed.
    recordHasChanged(e) {
        if (this.props.model === null) {
            return true;
        } else {
            return e.target.value != this.props.model.name;
        }
    }

    submitRecord(e) {
        if (this.lookupRecord(e)) {
            let newRecord = this.lookupRecord(e);
            this.props.updateLineItem(newRecord);
        } else {
            // We need to create a new record, or get an old record that's not
            // yet associated with the Item.
            fetch("/locations", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(
                    {
                        location: {
                            name: e.target.value,
                            document_id: this.props.documentId
                        }
                    }
                )
            }).then((response) => {
                if (response.ok) {
                    response.json().then((model) => {
                        this.props.updateLineItem(model);
                    });
                }
            });
        }
    }

    // Search for the record in our local records
    lookupRecord(e) {
        let records = this.records || [];
        let recordName = e.target.value;
        return records.filter((record) => record.name === recordName)[0];
    }
}

LocationSelect.PropTypes = {
    documentId: React.PropTypes.number.isRequired,
    lineItemId: React.PropTypes.number.isRequired,
    model: React.PropTypes.object.isRequired
};

LocationSelect.defaultProps = {
    model: {
        name: ""
    },
    ENTER_KEY_CODE: 13,
    TAB_KEY_CODE: 9
};
