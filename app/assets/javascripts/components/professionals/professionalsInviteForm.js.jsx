class ProfessionalsInviteForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = {fields: [{}]};
    }

    render() {
        var index = 0;
        return (
            <div>
                <div className="spec-form-inputs text-align-left">
                    {this.state.fields.map((fields, index) => {
                        return (
                            <div key={index}>
                                <span>Professional {index + 1}*:</span>
                                <span><input name={`document[invites][${index}][name]`} placeholder="E.g. Joe Bloggs"/></span>
                                <span><input name={`document[invites][${index}][email]`} placeholder="E.g. john@example.com"/></span>
                                <span><input name={`document[invites][${index}][telephone]`} placeholder="E.g. 07712345678"/></span>
                            </div>
                        )
                    })}

                    <div className="one-roof-blue-btn" onClick={this.addField.bind(this)}>Add Professional</div>
                </div>
            </div>
        )
    }

    addField(e) {
        this.state.fields.push({})
        this.forceUpdate()
    }
}
