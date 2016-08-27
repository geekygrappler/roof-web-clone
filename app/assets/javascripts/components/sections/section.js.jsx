class Section extends React.Component {
    constructor(props) {
        super(props);
    }


    updateTitle(e) {
        let sectionId = this.props.section.id;
        let newTitle = e.target.value;
        debugger;
        this.props.updateSectionTitle(sectionId, newTitle);
    }

    render() {
        return (
            <div className="row section">
                <div className="col-sm-12">
                    <h2>
                        <input type="text" defaultValue={this.props.section.name} onBlur={this.updateTitle.bind(this)} />
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
