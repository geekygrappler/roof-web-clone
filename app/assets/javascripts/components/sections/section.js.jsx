class Section extends React.Component {
    constructor(props) {
        super(props);
        this.state = {name: this.props.section.name, notes: this.props.section.notes}
    }

    editTitle(e) {
        this.setState({name: e.target.value});
    }

    updateTitle(e) {
        let newSection = this.props.section;
        newSection.name = e.target.value;
        debugger;
        this.props.swapDocument(newSection);
    }

    render() {
        return (
            <div className="row section">
                <div className="col-sm-12">
                    <h2>
                        <input type="text" value={this.state.name} onChange={this.editTitle.bind(this)} onBlur={this.updateTitle.bind(this)} />
                    </h2>
                    <textarea />
                    <h3>
                        Labour
                    </h3>
                    <LineItems
                        lineItems = {this.props.section.lineItems}
                        document = {this.props.document}
                        swapDocument = {this.props.swapDocument}
                        />
                    <h3>
                        Materials
                    </h3>
                </div>
            </div>
        );
    }
}
