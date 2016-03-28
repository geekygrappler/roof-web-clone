import './_admin_form.tag'
import './_tender_template_form.tag'
import './_tender_form.tag'
import './_quote_form.tag'
import './_payment_form.tag'
import './_account_form.tag'
import './_customer_form.tag'
import './_professional_form.tag'
import './_administrator_form.tag'
import './_lead_form.tag'
import './_project_form.tag'
import './_content_page_form.tag'
import './_content_template_form.tag'

//import rowTmp from './_index_row_tmp.js'

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
      <table id="streamtable" class="table-light bg-white">
        <thead class="bg-darken-1">
          <tr>
              <th each="{ attr, i in headers }">{ attr.humanize() }</th>
              <th></th>
          </tr>
        </thead>
        <tbody>
        <tbody>
      </table>
    </div>
    <div id="pagination"></div>
  </div>
  <script>
  this.mixin('admin')
  this.headers = []
  this.records = []
  this.showDisclosures = false
  this.currentPage = 1


  this.on('mount', () => {
    this.opts.api[opts.resource].on('index.fail', this.errorHandler)
    this.opts.api[opts.resource].on('index.success', this.updateRecords)
    this.opts.api[opts.resource].on('delete.success', this.removeRecord)
    this.opts.api[opts.resource].index({page: this.currentPage, limit: 1})
  })

  this.on('unmount', () => {
    this.opts.api[opts.resource].off('index.fail', this.errorHandler)
    this.opts.api[opts.resource].off('index.success', this.updateRecords)
    this.opts.api[opts.resource].off('delete.success', this.removeRecord)
  })

  // this.prevPage = (e) => {
  //   e.preventDefault()
  //   this.currentPage = Math.max(this.currentPage - 1, 1)
  //   this.opts.api[opts.resource].index({page: this.currentPage})
  // }
  // this.nextPage = (e) => {
  //   e.preventDefault()
  //   // this.currentPage = Math.min(this.currentPage + 1, 0)
  //   this.opts.api[opts.resource].index({page: ++this.currentPage})
  // }

  this.updateRecords = (records) => {
    this.update({headers: _.keys(records[0])})


    this.st = this.st || StreamTable('#streamtable', {
      view: (record, index) => {
        return rowTmp({headers: this.headers, record, index})
      },
      data_url: `/api/${opts.resource}`,
      stream_after: 2,
      fetch_data_limit: 50,
      pagination: {container: '#pagination'},
      callbacks: {
        pagination: () => {
          $('[data-disclosure]', this.root).disclosure(false)
        }
      }
    }, records);
  }

  this.removeRecord = (id) => {
    let _id = _.findIndex(this.records, r => r.id === id )
    if (_id > -1) {
      this.records.splice(_id, 1)
      this.update()
    }
  }
  this.open = (e) => {
    let tags = this.openAdminForm(`r-admin-${opts.resource.replace(/_|\//g,'-').singular()}-form`, e)
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
    this.opts.api[opts.resource].index({query: this.query.value, page: (this.currentPage = 1)})
  }

  </script>
</r-admin-index>
