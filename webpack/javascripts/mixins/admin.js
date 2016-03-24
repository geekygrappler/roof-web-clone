riot.mixin('admin', {
  openAdminForm: function (formTag, e, resource) {
    return riot.mount('r-modal', {
      content: formTag,
      persisted: false,
      api: this.opts.api,
      classes: 'sm-col-11 p2 mt2 mb2',
      contentOpts: {
        resource: this.opts.resource || resource,
        id: e.item && (e.item.id || e.item.record && e.item.record.id),
        api: this.opts.api,
        attributes: []
      }
    })
  }
})

riot.mixin('adminForm', {
  init: function () {
    this.on('mount', () => {
      this.opts.api[this.opts.resource].on('new.fail', this.errorHandler)
      this.opts.api[this.opts.resource].on('show.fail', this.errorHandler)
      this.opts.api[this.opts.resource].on('update.fail', this.errorHandler)
      this.opts.api[this.opts.resource].on('new.success', this.updateRecord)
      this.opts.api[this.opts.resource].on('show.success', this.updateRecord)
      this.opts.api[this.opts.resource].on('update.success', this.update)
      if(this.opts.id) {
        this.opts.api[this.opts.resource].show(this.opts.id)
        history.pushState(null, null, `/app/admin/${this.opts.resource}/${this.opts.id}/edit`)
      } else {
        this.opts.api[this.opts.resource].new()
        history.pushState(null, null, `/app/admin/${this.opts.resource}/new`)
      }
    })

    this.on('unmount', () => {
      this.opts.api[this.opts.resource].off('new.fail', this.errorHandler)
      this.opts.api[this.opts.resource].off('show.fail', this.errorHandler)
      this.opts.api[this.opts.resource].off('update.fail', this.errorHandler)
      this.opts.api[this.opts.resource].off('new.success', this.updateRecord)
      this.opts.api[this.opts.resource].off('show.success', this.updateRecord)
      this.opts.api[this.opts.resource].off('update.success', this.update)
    })

    this.updateRecord = this.updateRecord || (record) => {
      this.update({record: record, attributes: _.keys(record)})
    }

    this.submit = this.submit || (e) => {
      if (e) e.preventDefault()

      let data = this.serializeForm(this.form)

      if (_.isEmpty(data)) {
        $(this.form).animateCss('shake')
        return
      }

      this.update({busy: true, errors: null})

      if (this.opts.id) {
        this.opts.api[this.opts.resource].update(this.opts.id, data)
        .fail(this.errorHandler)
        .then(id => this.update({busy:false}))
      }else{
        this.opts.api[this.opts.resource].create(data)
        .fail(this.errorHandler)
        .then(record => {
          this.update({record: record, busy:false})
          this.opts.id = record.id
          history.pushState(null, null, `/app/admin/${this.opts.resource}/${record.id}/edit`)
        })
      }
    }
  }
})
