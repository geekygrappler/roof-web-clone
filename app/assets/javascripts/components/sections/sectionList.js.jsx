class SectionList extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            collapsed: true
        }
    }

    render() {
        return (
            <div className="row">
                <div className="col-xs-11">
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
                </div>
                {this.renderSectionListExpander()}
            </div>
        );
    }

    properOffset(e) {
        let anchor = e.currentTarget.getElementsByTagName('a')[0];
        anchor.click();
        scrollBy(0, -this.state.headerSize);
    }

    componentDidMount() {
        $("body").css('padding-top', this.calcHeaderSize())
        this.setState({
            headerSize: this.calcHeaderSize(),
            collapsed: true
        })
    }

    renderSectionListExpander() {
        if (this.state.collapsed) {
            return (
                <div className="col-xs-1">
                    <button className="btn btn-warning section-list-expander" onClick={this.expandSectionList.bind(this)}>
                        <span className="glyphicon glyphicon-triangle-bottom" />
                    </button>
                </div>
            );
        } else {
            return (
                <div className="col-xs-1">
                    <button className="btn btn-warning section-list-expander" onClick={this.collapseSectionList.bind(this)}>
                        <span className="glyphicon glyphicon-triangle-top" />
                    </button>
                </div>
            );
        }
    }

    expandSectionList() {
        let sectionList = $(".document-sections-list");
        let expandedHeight = sectionList.find(".row").height();
        sectionList.height(expandedHeight);
        $("body").css('padding-top', this.calcHeaderSize())
        this.setState({
            headerSize: this.calcHeaderSize(),
            collapsed: false
        })
    }

    collapseSectionList() {
        let sectionList = $(".document-sections-list");
        sectionList.height("50px");
        $("body").css('padding-top', this.calcHeaderSize())
        this.setState({
            headerSize: this.calcHeaderSize(),
            collapsed: true
        })
    }

    calcHeaderSize () {
        return $(".document-header").outerHeight() + $(".document-sections-list").outerHeight();
    }

}
