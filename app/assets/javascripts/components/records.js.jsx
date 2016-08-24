class Records extends React.Component {
    constructor(props) {
        super(props);
        this.state = {records: props.data}
    }

    render() {
        return (
            <div className="records">
                <h2 className="title"> Records </h2>
            </div>
        )
    }
}
