/* global React */

class Rate extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <form className="form-inline">
                <div className="form-group">
                    <label htmlFor="exampleInputName2">Name</label>
                    <input type="text" className="form-control" id="exampleInputName2" placeholder="Jane Doe" />
                </div>
                <div className="form-group">
                    <label htmlFor="exampleInputEmail2">Email</label>
                    <input type="email" className="form-control" id="exampleInputEmail2" placeholder="jane.doe@example.com" />
                </div>
                <button type="submit" className="btn btn-default">Send invitation</button>
            </form>
        );
    }

}
