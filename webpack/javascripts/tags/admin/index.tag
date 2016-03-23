import './_admin_form.tag'
import './_tender_template_form.tag'
import './_tender_form.tag'
import './_quote_form.tag'
import './_payment_form.tag'
import './_account_form.tag'
import './_lead_form.tag'
import './_project_form.tag'

<r-admin-index>

  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>

  <div class="container p2">
    <form onsubmit="{ search }">
      <input type="text" name="query" class="block mb2 col-12 field" placeholder="Search { opts.resource }" />
    </form>

    <div class="overflow-auto">
      <a class="btn btn-primary" onclick="{ open }">New</a>
      <table class="table-light bg-white">
        <thead class="bg-darken-1">
          <tr>
              <th each="{ attr, i in headers }">{ attr.humanize() }</th>
              <th></th>
          </tr>
        </thead>
        <tbody>
          <tr each="{ record, i in records }">
            <td each="{ attr, value in record }">{ value }</td>
            <td>
              <button class="btn btn-small" onclick="{ open }">
                <i class="fa fa-pencil"></i>
              </button>
              <button class="btn btn-small" onclick="{ destroy }">
                <i class="fa fa-trash"></i>
              </button>
            </td>
          </tr>
        <tbody>
      </table>
    </div>
  </div>
  <script>
  this.mixin('admin')
  this.headers = []
  this.records = []
  this.on('mount', () => {
    this.opts.api[opts.resource].on('index.fail', this.errorHandler)
    this.opts.api[opts.resource].on('index.success', this.updateRecords)
    this.opts.api[opts.resource].on('delete.success', this.removeRecord)
    this.opts.api[opts.resource].index()
  })

  this.on('unmount', () => {
    this.opts.api[opts.resource].off('index.fail', this.errorHandler)
    this.opts.api[opts.resource].off('index.success', this.updateRecords)
    this.opts.api[opts.resource].off('delete.success', this.removeRecord)
  })

  this.updateRecords = (records) => {
    this.update({records: records, headers: _.keys(records[0]) })
  }
  this.removeRecord = (id) => {
    let _id = _.findIndex(this.records, r => r.id === id )
    if (_id > -1) {
      this.records.splice(_id, 1)
      this.update()
    }
  }
  this.open = (e) => {
    let tags = this.openAdminForm(`r-admin-${opts.resource.replace(/_/g,'-').singular()}-form`, e)
    if(!tags[0].content._tag) {
      this.openAdminForm(`r-admin-form`, e)
    }
  }
  this.destroy = (e) => {
    if (window.confirm(this.ERRORS.CONFIRM_DELETE)) {
      this.opts.api[opts.resource].delete(e.item.record.id)
    }
  }
  this.search = (e) => {
    e.preventDefault()
    this.opts.api[opts.resource].index({query: this.query.value})
  }

  </script>
</r-admin-index>
