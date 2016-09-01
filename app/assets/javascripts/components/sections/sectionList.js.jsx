class SectionList extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <div className="btn-group">
                {this.props.sections.map((section) => {
                    return (
                        <button key={section.id} className="btn btn-default">{section.name}</button>
                    )
                })}
            </div>
        );
    }
}
