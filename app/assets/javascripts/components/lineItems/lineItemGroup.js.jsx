/* global React */

/*
 * A group being either a "Stage" or a "Location"
 */

class LineItemGroup extends React.Component {
    constructor(props) {
        super(props);
        this.state = this.props.group;
    }

    render() {
        return (
            <div className="row section" id={`group-${this.props.group.name}`}>
                <div className="col-sm-12">
                    <div className="row">
                        <div className="col-sm-8">
                            <h2>
                                {this.state.name}
                            </h2>
                        </div>
                        <div className="col-sm-4 text-right">
                            <a className="glyphicon glyphicon-trash" />
                        </div>
                    </div>
                    <div className="section-input-wrapper">
                        <LineItemList
                            lineItems = {this.props.group.lineItems}
                            document = {this.props.document}
                            createLineItem = {this.props.createLineItem}
                            updateLineItem = {this.props.updateLineItem}
                            deleteLineItem={this.props.deleteLineItem}
                            fetchDocument={this.props.fetchDocument}
                            stage={this.props.viewGroupType == "stages" ? this.props.group : null}
                            location={this.props.viewGroupType == "locations" ? this.props.group : null}
                            />
                    </div>
                </div>
            </div>
        );
    }
}
