import CodeMirror from 'codemirror/lib/codemirror'
import 'codemirror/mode/htmlmixed/htmlmixed'

riot.mixin('admin', {
  openAdminForm: function (formTag, options, resource) {
    // return riot.mount('r-modal', {
    //   content: formTag,
    //   persisted: false,
    //   api: this.opts.api,
    //   classes: 'sm-col-11 p2 mt2 mb2',
    //   contentOpts: {
    //     resource: this.opts.resource || resource,
    //     id: e.item && (e.item.id || e.item.record && e.item.record.id),
    //     api: this.opts.api,
    //     attributes: []
    //   }
    // })

    return riot.mount($('[name=content]')[0], formTag, {
      classes: 'sm-col-11 p2 mt2 mb2',
      resource: this.opts.resource || resource,
      id: options.item && (options.item.id || options.item.record && options.item.record.id),
      api: this.opts.api,
      tab: options.tab,
      project_id: options.project_id
    })
  },
  renderAdminIndex: function (ns, resource, options) {
    options.ns = ns

    resource = `${ns}${resource}`
    options.resource = resource

    var tags = riot.mount(this.content, `r-admin-${resource.replace(/_|\//g,'-').singular()}-index`, options)
    if(!tags[0]) {
      riot.mount(this.content, `r-admin-index`, options)
    }
  },
  renderAdminForm: function  (ns, resource, options) {
    options.ns = ns
    if(!resource.includes(ns)) resource = `${ns}${resource}`
    options.resource = resource

    let tags = this.openAdminForm(`r-admin-${resource.replace(/_|\//g,'-').singular()}-form`, options, resource)
    // if(!tags[0].content._tag) {
    if(!tags[0]){
      tags = this.openAdminForm(`r-admin-form`, options, resource)
    }
    //tags[0].on('unmount', () => {
      // window.onpopstate()
    //  history.pushState(null, null, `/app/admin/${resource}`)
    //})
  }
})
riot.mixin('adminIndex', {
  init: function () {
    this.headers = []
    this.records = []
    this.showDisclosures = false

    this.on('mount', () => {
      this.opts.api[this.opts.resource].on('index.fail', this.errorHandler)
      this.opts.api[this.opts.resource].on('index.success', this.updateRecords)
      this.opts.api[this.opts.resource].on('delete.success', this.removeRecord)
      this.opts.api[this.opts.resource].index({page: this.opts.page, query: this.opts.query, order: this.opts.order})
    })

    this.on('unmount', () => {
      this.opts.api[this.opts.resource].off('index.fail', this.errorHandler)
      this.opts.api[this.opts.resource].off('index.success', this.updateRecords)
      this.opts.api[this.opts.resource].off('delete.success', this.removeRecord)
    })
    this.sort = (e) => {
      var dir = this.opts.order ? (this.opts.order[1] == 'asc' ? 'desc' : 'asc') : 'asc'
      this.opts.order = [e.item.attr, dir]
      if(this.opts.query) {
        riot.route(`/admin/${this.opts.resource}/search/${this.opts.query}/page/1/order/${this.opts.order}`)
      } else {
        riot.route(`/admin/${this.opts.resource}/page/1/order/${this.opts.order}`)
      }
    }
    this.prevPage = (e) => {
      var url = ''
      e.preventDefault()
      this.opts.page = Math.max(this.opts.page - 1, 1)
      // this.opts.api[opts.resource].index({page: this.currentPage})
      if(this.opts.query) {
        url = `/admin/${this.opts.resource}/search/${this.opts.query}/page/${this.opts.page}`
      } else {
        url = `/admin/${this.opts.resource}/page/${this.opts.page}`
      }
      if (this.opts.order) {
        url += `/order/${this.opts.order}`
      }
      riot.route(url)
    }
    this.nextPage = (e) => {
      var url = ''
      e.preventDefault()
      // this.currentPage = Math.min(this.currentPage + 1, 0)
      // this.opts.api[opts.resource].index({page: ++this.currentPage})
      if(this.opts.query) {
        url = `/admin/${this.opts.resource}/search/${this.opts.query}/page/${++this.opts.page}`
      } else {
        url = `/admin/${this.opts.resource}/page/${++this.opts.page}`
      }
      if (this.opts.order) {
        url += `/order/${this.opts.order}`
      }
      riot.route(url)
    }
    this.gotoPage = (e) => {
      var url = ''
      if(this.opts.query) {
        url = `/admin/${this.opts.resource}/search/${this.opts.query}/page/${e.target.value}`
      } else {
        url = `/admin/${this.opts.resource}/page/${e.target.value}`
      }
      if (this.opts.order) {
        url += `/order/${this.opts.order}`
      }
      riot.route(url)
    }

    this.updateRecords = this.updateRecords || (records) => {
      this.update({headers: _.keys(records[0]), records: records})
    }

    this.removeRecord = this.removeRecord || (id) => {
      let _id = _.findIndex(this.records, r => r.id === id )
      if (_id > -1) {
        this.records.splice(_id, 1)
        this.update()
      }
    }
    this.open = (e) => {
      // let tags = this.openAdminForm(`r-admin-${this.opts.resource.replace(/_|\//g,'-').singular()}-form`, e)
      // if(!tags[0].content._tag) {
      //   this.openAdminForm(`r-admin-form`, e)
      // }
      //this.renderAdminForm(this.opts.ns, this.opts.resource, e)
      var id = e.item && (e.item.id || e.item.record && e.item.record.id)
      riot.route(`/admin/${this.opts.resource}/${id ? id + '/edit' : 'new'}`)
    }

    this.updateRecord = this.updateRecord || (record) => {
      this.update({record: record, attributes: _.keys(record)})
    }

    this.toggleSearchable = (e) => {
      var record = e.item.record
      var strToBol = record.searchable == 'true' ? true : false
      record.searchable = !strToBol
      $.ajax({
        url: "/api/tender_templates/" + record.id + '/toggle_searchable',
        data: {tender_template: {data: {searchable: true}}},
        dataType: 'JSON',
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        method: 'PATCH',
        success: function(result) {
        }
      })
    }
    this.destroy = (e) => {
      if (window.confirm(this.ERRORS.CONFIRM_DELETE)) {
        this.opts.api[this.opts.resource].delete(e.item.record.id)
      }
    }
    this.search = (e) => {
      e.preventDefault()
      // this.opts.api[opts.resource].index({query: this.query.value, page: (this.currentPage = 1)})
      riot.route(`/admin/${this.opts.resource}/search/${this.query.value}/page/1`)
    }
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
      // this.opts.api[this.opts.resource].on('update.success', this.update)
      if(this.opts.id) {
        this.opts.api[this.opts.resource].show(this.opts.id)
        //history.pushState(null, null, `/app/admin/${this.opts.resource}/${this.opts.id}/edit`)
      } else {
        this.opts.api[this.opts.resource].new()
        //history.pushState(null, null, `/app/admin/${this.opts.resource}/new`)
      }
      // window.onpopstate =  () => {
      //   this.closeModal()
      //   return true
      // }
    })

    this.on('unmount', () => {
      this.opts.api[this.opts.resource].off('new.fail', this.errorHandler)
      this.opts.api[this.opts.resource].off('show.fail', this.errorHandler)
      this.opts.api[this.opts.resource].off('update.fail', this.errorHandler)
      this.opts.api[this.opts.resource].off('new.success', this.updateRecord)
      this.opts.api[this.opts.resource].off('show.success', this.updateRecord)
      // this.opts.api[this.opts.resource].off('update.success', this.update)
      //window.onpopstate =  null
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
        .then(id => {
          this.update({busy:false})
          //this.closeModal()
        })
      }else{
        this.opts.api[this.opts.resource].create(data)
        .fail(this.errorHandler)
        .then(record => {
          this.update({record: record, busy:false})
          this.opts.id = record.id
          history.pushState(null, null, `/app/admin/${this.opts.resource}/${record.id}/edit`)
          //this.closeModal()
        })
      }
    }
  }
})


riot.mixin('codeMirror', {
  init: function () {

    this.on('mount',  () => {
      let $textarea = $('textarea.code', this.root)
      this.codeFieldName = $textarea.attr('name')
      this.codeMirror = CodeMirror.fromTextArea($textarea[0], {
        lineNumbers: true,
        mode: 'htmlmixed'
      })

      this.codeMirror.on('change', (cm) => {
        this.record[this.codeFieldName] = cm.getDoc().getValue()
        $textarea.val(this.record[this.codeFieldName])
      })
    })

    this.on('update', () => {
      if (this.record && this.record[this.codeFieldName]) {
        this.codeMirror.setValue(this.record[this.codeFieldName])
      }
    })
    this.on('updated', () => {
      this.codeMirror.refresh()
    })
  }
})
