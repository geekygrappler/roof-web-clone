import './_tender_template_form.tag'
import './_tender_form.tag'
import './_quote_form.tag'

<r-admin-form>

  <h2 class="center mt0 mb2">{ opts.resource.humanize() }</h2>

  <form name="form" class="sm-col-12 left-align" onsubmit="{ submit }" >

    <div each="{attr, i in attributes}">
      <div if="{attr != 'id'}">
      <label for="{resource.singular()}[{attr}]">{attr.humanize()}</label>
      <textarea if="{_.isObject(record[attr])}" class="block col-12 mb2 field fixed-height">{JSON.stringify(record[attr], null, 2)}</textarea>
      <input  if="{!_.isObject(record[attr])}" class="block col-12 mb2 field"
      type="text" name="{resource.singular()}[{attr}]" value="{record[attr]}"/>
      <span if="{errors[attr]}" class="inline-error">{errors[attr]}</span>
      </div>
    </div>

    <button type="submit" class="block col-12 mb2 btn btn-big btn-primary {busy: busy}">Save</button>

  </form>

  <script>
  this.on('mount', () => {
    this.opts.api[opts.resource].on('new.fail', this.errorHandler)
    this.opts.api[opts.resource].on('show.fail', this.errorHandler)
    this.opts.api[opts.resource].on('update.fail', this.errorHandler)
    this.opts.api[opts.resource].on('new.success', this.updateRecord)
    this.opts.api[opts.resource].on('show.success', this.updateRecord)
    this.opts.api[opts.resource].on('update.success', this.update)
    if(opts.id) {
      this.opts.api[opts.resource].show(opts.id)
      history.pushState(null, null, `/app/admin/${opts.resource}/${opts.id}/edit`)
    } else {
      this.opts.api[opts.resource].new()
      history.pushState(null, null, `/app/admin/${opts.resource}/new`)
    }
  })

  this.on('unmount', () => {
    this.opts.api[opts.resource].off('new.fail', this.errorHandler)
    this.opts.api[opts.resource].off('show.fail', this.errorHandler)
    this.opts.api[opts.resource].off('update.fail', this.errorHandler)
    this.opts.api[opts.resource].off('new.success', this.updateRecord)
    this.opts.api[opts.resource].off('show.success', this.updateRecord)
    this.opts.api[opts.resource].off('update.success', this.update)
  })

  this.updateRecord = (record) => {
    this.update({record: record, attributes: _.keys(record)})
  }

  this.submit = (e) => {
    if (e) e.preventDefault()

    let data = this.serializeForm(this.form)

    if (_.isEmpty(data)) {
      $(this.form).animateCss('shake')
      return
    }

    this.update({busy: true, errors: null})

    if (this.opts.id) {
      this.opts.api[opts.resource].update(opts.id, data)
      .fail(this.errorHandler)
      .then(id => this.update({busy:false}))
    }else{
      this.opts.api[opts.resource].create(data)
      .fail(this.errorHandler)
      .then(record => {
        this.update({record: record, busy:false})
        this.opts.id = record.id
        history.pushState(null, null, `/app/admin/${opts.resource}/${record.id}/edit`)
      })
    }
  }
  </script>

</r-admin-form>

<r-admin-index>

  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>

  <div class="container p2">
    <form submit="{ search }">
      <input type="text" class="block mb2 col-12 field" placeholder="Search { opts.resource }" />
    </form>

    <div class="overflow-auto">
      <a class="btn btn-primary" onclick="{ open }">New</a>
      <table class="table-light overflow-hidden bg-white border rounded">
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
    let tags = this.openForm(`r-admin-${opts.resource.replace(/_/g,'-').singular()}-form`, e)
    if(!tags[0].content._tag) {
      this.openForm(`r-admin-form`, e)
    }
  }
  this.destroy = (e) => {
    if (window.confirm(this.ERRORS.CONFIRM_DELETE)) {
      this.opts.api[opts.resource].delete(e.item.id)
    }
  }
  this.search = () => {
    this.opts.api[opts.resource].index()
  }

  </script>
</r-admin-index>
