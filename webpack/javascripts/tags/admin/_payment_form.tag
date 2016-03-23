<r-admin-payment-form>

  <h2 class="center mt0 mb2">{ opts.resource.humanize() }</h2>

  <form name="form" class="sm-col-12 left-align" onsubmit="{ submit }" >


    <div each="{attr, i in ['fee', 'amount']}">
      <label for="{resource.singular()}[{attr}]">{attr.humanize()}</label>

      <input  class="block col-12 mb2 field"
      type="text" name="{attr}" value="{parseInt(record[attr]) * 0.01}"/>
      <span if="{errors[attr]}" class="inline-error">{errors[attr]}</span>
    </div>

    <div each="{attr, i in ['due_date', 'description']}">
      <label for="{resource.singular()}[{attr}]">{attr.humanize()}</label>

      <input  class="block col-12 mb2 field"
      type="text" name="{attr}" value="{record[attr]}"/>
      <span if="{errors[attr]}" class="inline-error">{errors[attr]}</span>
    </div>

    <div class="right-align">
    <button type="submit" class="mb2 btn btn-big btn-primary {busy: busy}">Save</button>
    <a if="{record.id && !record.approved_at}" onclick="{approve}" class="mb2 btn btn-big bg-green white {busy: busy}">Approve</a>
    <a if="{record.id && record.paid_at && !record.refunded_at}" onclick="{refund}" class="mb2 btn btn-big bg-red white {busy: busy}">Refund</a>
    </div>

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

  this.approve = (e) => {
    e.preventDefault()

    let data = this.serializeForm(this.form)

    this.update({busy: true, errors: null})
    this.opts.api[opts.resource].approve(opts.id, data)
    .fail(this.errorHandler)
    .then(this.updateReset)

  }

  this.refund = (e) => {
    e.preventDefault()


    this.update({busy: true, errors: null})
    this.opts.api[opts.resource].refund(opts.id)
    .fail(this.errorHandler)
    .then(this.updateReset)

  }
  </script>

</r-admin-payment-form>
