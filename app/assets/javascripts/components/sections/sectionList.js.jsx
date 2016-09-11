class SectionList extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            headerSize: 240
        }
    }

    render() {
        return (
            <ul className="nav navbar btn-group">
                {this.props.sections.map((section) => {
                    return (
                        <li key={section.id} className="btn btn-default navbar-btn sections-list-li" onClick={this.properOffset.bind(this)}>
                            <a href={`#section-${section.id}`} className='hide'></a>
                            {section.name}
                        </li>
                    )
                })}
            </ul>
        );
    }

    properOffset(e) {
        let anchor = e.currentTarget.getElementsByTagName('a')[0];
        anchor.click();
        scrollBy(0, -this.state.headerSize);
    }

}
