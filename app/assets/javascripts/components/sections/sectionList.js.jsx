class SectionList extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <ul className="nav navbar btn-group">
                {this.props.sections.map((section) => {
                    return (
                        <li key={section.id} className="btn btn-default navbar-btn">
                            <a href={`#section-${section.id}`} className='hide'></a>
                            {section.name}
                        </li>
                    )
                })}
            </ul>
        );
    }
}
