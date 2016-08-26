class Section extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            notes: this.props.data.notes
        };
    }

    updateNotes(e) {
        this.setState({ notes: e.target.value});
    }

    render() {
        return (
            <div className="row section">
                <div className="col-sm-12">
                    <h2>
                        {this.props.data.name}
                    </h2>
                    <textarea onChange={this.updateNotes.bind(this)} value={this.state.notes}>
                    </textarea>
                    <h3>
                        Labour
                    </h3>
                    <LineItems
                        lineItems = {this.props.data.lineItems}
                        addLineItem = {this.props.addLineItem}
                        />
                    <h3>
                        Materials
                    </h3>
                </div>
            </div>
        );
    }
}
