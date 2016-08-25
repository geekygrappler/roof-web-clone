class Document extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            name: props.data.name
        }
    }

    updateTitle(e) {
        this.setState({name: e.target.value})
    }

    render() {
        return (
            <div className="container">
                <div className="row">
                    <div className="col-sm-12">
                        <h2 className="title">
                            <input value={this.state.name} onChange={this.updateTitle.bind(this)}/>
                        </h2>
                    </div>
                </div>
                {this.props.data.sections.map((section) => {
                    return(
                        <Section
                            key={section.id}
                            data={section}
                            />
                    );
                })}
            </div>
        )
    }
}
