import from '../../mixins/tender.js'

<r-quotes-form>

  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>

  <div class="container p2 {readonly: isReadonly()}">
    <h1><a class="btn btn-small h6 btn-outline orange" href="/app/projects/{record.project_id}"><i class="fa fa-chevron-left"></i> Back to Project</a>
      { opts.id ? getTitle() : 'New Quote' }
    </h1>

    <div if="{currentAccount.isAdministrator}">
    <label for="project_id">Professional</label>
    <input type="hidden" name="professional_id" value="{record.professional_id}">
    <r-typeahead-input resource="professionals" api="{ opts.api }" id="{record.professional_id}" filters="{professionalFilters()}" datum_tokenizer="{['full_name']}"></r-typeahead-input>
    <span if="{errors.professional_id}" class="inline-error">{errors.professional_id}</span>

    <label for="tender_id">Tender</label>
    <input type="hidden" name="tender_id" value="{record.tender_id}">
    <r-typeahead-input resource="tenders" api="{ opts.api }" id="{record.tender_id}" filters="{tenderFilters()}" datum_tokenizer="{['id', 'total_amount']}"></r-typeahead-input>
    <span if="{errors.tender_id}" class="inline-error">{errors.project}</span>
    </div>

    <r-tender-section each="{ section , i in record.document.sections }" ></r-tender-section>

    <form if="{ !opts.readonly && record.document }" onsubmit="{ addSection }" class="mt3 py3 clearfix mxn1 border-top">
      <div class="col col-8 px1">
        <input type="text" name="sectionName" placeholder="Section name" class="block col-12 field" />
      </div>
      <div class="col col-4 px1">
        <button type="submit" class="block col-12 btn btn-primary"><i class="fa fa-puzzle-piece"></i> Add Section</button>
      </div>
    </form>

    <div class="py3">
    <h4 class="right-align m0"><label><input type="checkbox" onchange="{toggleVat}" checked="{record.document.include_vat}" class="mr1">VAT {tenderVat()}</label></h4>
    <h3 class="right-align m0">Total{ record.document.include_vat ? '(Inc. VAT)' : ''}: { tenderTotal() }</h3>
    </div>

    <form name="form" onsubmit="{ submit }" class="right-align">

      <div if="{errors}" id="error_explanation" class="left-align">
        <ul>
          <li each="{field, messsages in errors}"> <strong>{field.humanize()}</strong> {messsages} </li>
        </ul>
      </div>


      <button if="{opts.id && !currentAccount.isProfessional && record.submitted_at}"
      class="btn btn-primary btn-big {busy: busy}" onclick="{acceptQuote}" disabled="{record.accepted_at}">
      {record.accepted_at ? 'Accepted' : 'Accept'} <span if="{record.accepted_at}">{fromNow(record.accepted_at)}</span>
      </button>

      <virtual if="{!opts.readonly && !currentAccount.isCustomer}">
        <button type="submit" class="btn btn-primary btn-big {busy: busy}">Save</button>
        <a if="{opts.id}" class="btn bg-green white btn-big {busy: busy}" onclick="{submitQuote}">Submit</a>
      </virtual>
    </form>
  </div>
  <script>

    this.getTitle = () => {
      // (opts.readonly ? 'Showing' : 'Editing') + ' Quote ' + opts.id
      if(this.title) {
        return this.title
      } else {
        this.opts.api.projects.show(this.record.project_id).then((project) => {
          var byOrFor = this.currentAccount.isCustomer ?
            ' by ' + (this.record.professional.profile.first_name + ' ' + this.record.professional.profile.last_name) :
            ' for ' + (project.customers[0].profile.first_name + ' ' + project.customers[0].profile.last_name)
          this.title = ' Quote' + byOrFor
          this.update()
          return this.title
        })
      }
    }

    this.headers = {
      task: {name: 6, quantity: 1, price: 1, total_cost: 2, actions: 2},
      material: {name: 5, quantity: 1, price: 1, total_cost: 2, supplied: 1, actions: 2}
    }

    this.isReadonly = () => {
      console.log('isReadonly', this.opts.readonly)
      return this.opts.readonly
    }

    if(opts.readonly){
      delete this.headers.task.actions
      this.headers.task.name = 8
      delete this.headers.material.actions
      this.headers.material.name = 7
    }

    if (opts.id) {
      this.on('mount', () => {
        opts.api.quotes.on('show.fail', this.errorHandler)
        opts.api.quotes.on('show.success', this.updateQuote)
        opts.api.quotes.show(opts.id)
      })
      this.on('unmount', () => {
        opts.api.quotes.off('show.fail', this.errorHandler)
        opts.api.quotes.off('show.success', this.updateQuote)
      })
    } else {
      this.record = {project_id: this.opts.project_id, document: {sections: []}}
      if (this.currentAccount.isProfessional) this.record.professional_id = this.currentAccount.user_id
    }

    this.submit = (e) => {
      if (e) e.preventDefault()

      this.update({busy: true, errors: null})

      _.map(this.record.document.sections, (sec) => {
        if (_.isEmpty(sec.materials)) {
          sec.materials = null
          delete sec.materials
        }
        if (_.isEmpty(sec.tasks)) {
          sec.tasks = null
          delete sec.tasks
        }
        return sec
      })

      if (this.opts.id) {
        this.opts.api.quotes.update(opts.id, this.record)
        .fail(this.errorHandler)
        .then(id => this.update({busy:false}))
      }else{
        this.opts.api.quotes.create(this.record)
        .fail(this.errorHandler)
        .then(record => {
          this.update({busy:false})
          this.opts.id = record.id
          window.location.href = `/app/projects/${record.project_id}/quotes/${record.id}`
        })
      }
    }

    this.updateQuote = (record) => {
      if(!this.currentAccount.isAdministrator) {
        this.opts.readonly = !!record.accepted_at
      }
      this.update({record: record})
    }

    this.submitQuote = (e) => {
      if (this.opts.id) {
        if (e) e.preventDefault()
        this.update({busy: true})
        this.opts.api.quotes.submit(this.opts.id)
        .fail(this.errorHandler)
        .then(id => this.update({busy:false}))
      }
    }

    this.acceptQuote = (e) => {
      if (this.opts.id) {
        if (e) e.preventDefault()
        this.update({busy: true})
        this.opts.api.quotes.accept(this.opts.id)
        .fail(this.errorHandler)
        .then(id => this.update({busy:false}))
      }
    }

    this.tags['r-typeahead-input'][0].on('itemselected', (item) => {
      this.record.professional_id = item.id
      this.update()
    })
    this.tags['r-typeahead-input'][1].on('itemselected', (item) => {
      this.record.tender_id = item.id
      this.update()
    })
    this.professionalFilters = () => {
      return [{name: 'project_id', value: this.record.project_id}]
    }
    this.tenderFilters = () => {
      return [{name: 'project_id', value: this.record.project_id}]
    }

    this.mixin('tenderMixin')

  </script>
</r-quotes-form>
