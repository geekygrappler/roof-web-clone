class ProfessionalsFileUploadForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = {fields: [{text: 'Upload'}]};
    }

    render() {
        var index = 0;
        return (
            <div>
                <div className="spec-form-inputs text-align-left">
                    {this.state.fields.map((field, index) => {
                        return (
                            <div key={index} className="pro-file-upload">
                                <span>File {index + 1}*:</span>
                                <span className="display-none">
                                    <input type="file" name={`plans[${index}][url]`} onChange={this.updateText.bind(this, field)} />
                                </span>
                                <div className="one-roof-blue-btn pro-file-upload-btn">{field.text}</div>
                                <div className="clr"></div>
                            </div>
                        )
                    })}

                    <div className="one-roof-blue-btn" onClick={this.addField.bind(this)}>Add File</div>
                </div>
            </div>
        )
    }

    addField(e) {
        this.state.fields.push({text: 'Upload'})
        this.forceUpdate()
    }

    updateText(field, e) {
        field.text = e.target.value.split('\\').slice(-1)[0];
        this.forceUpdate()
    }
}
