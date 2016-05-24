import from '../../mixins/tender.js'

<r-admin-quote-form>

  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>

  <div class="container p2">

    <h2 class="center mt0 mb2">{opts.id ? 'Editing' : 'Creating'} { opts.resource.singular().humanize() }</h2>

    <label for="project">Project</label>
    <input type="hidden" name="project_id" value="{record.project_id}">
    <r-typeahead-input resource="projects" api="{ opts.api }" id="{record.project_id}" datum_tokenizer="{['name', 'account_email']}"></r-typeahead-input>
    <span if="{errors.project}" class="inline-error">{errors.project}</span>

    <label for="project_id">Professional</label>
    <input type="hidden" name="professional_id" value="{record.professional_id}">
    <r-typeahead-input resource="professionals" api="{ opts.api }" id="{record.professional_id}" filters="{professionalFilters()}" datum_tokenizer="{['full_name']}"></r-typeahead-input>
    <span if="{errors.professional_id}" class="inline-error">{errors.professional_id}</span>

    <label for="tender_id">Tender</label>
    
    <input type="hidden" name="tender_id" value="{record.tender_id}">
    <r-typeahead-input resource="tenders" api="{ opts.api }" id="{record.tender_id}" filters="{tenderFilters()}" datum_tokenizer="{['id', 'total_amount']}"></r-typeahead-input>
    <span if="{errors.tender_id}" class="inline-error">{errors.project}</span>

    <r-tender-filters record="{record}"></r-tender-filters>
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
    <h3 class="right-align m0">Total{ record.document.include_vat ? '(Inc. VAT)' : ''}: { tenderTotal }</h3>
    </div>

    <form name="form" onsubmit="{ submit }" class="right-align">

      <div if="{errors}" id="error_explanation" class="left-align">
        <ul>
          <li each="{field, messsages in errors}"> <strong>{field.humanize()}</strong> {messsages} </li>
        </ul>
      </div>

      <button type="submit" class="btn btn-primary btn-big {busy: busy}">Save</button>

      <a if="{record.id}" class="btn bg-green white btn-big {busy: busy}" onclick="{submitQuote}">Submit</a>
      <button if="{record.id}"
      class="btn bg-red btn-big {busy: busy}" onclick="{acceptQuote}" disabled="{record.accepted_at}">
      {record.accepted_at ? 'Accepted' : 'Accept'} <span if="{record.accepted_at}">{fromNow(record.accepted_at)}</span>
      </button>

    </form>
  </div>
  <script>
  this.type = 'Quote'
    this.headers = {
      task: {name: 6, quantity: 1, price: 1, total_cost: 2, actions: 2},
      material: {name: 5, quantity: 1, price: 1, total_cost: 2, supplied: 1, actions: 2}
    }

    this.on('mount', () => {
      this.opts.api[opts.resource].on('show.fail', this.errorHandler)
      this.opts.api[opts.resource].on('show.success', this.updateRecord)
    })
    this.on('unmount', () => {
      this.opts.api[opts.resource].off('show.fail', this.errorHandler)
      this.opts.api[opts.resource].off('show.success', this.updateRecord)
    })

    this.record = {project_id: this.opts.project_id, document: {sections: []}}

    if (opts.id) {
      this.opts.api[opts.resource].show(opts.id)
      history.pushState(null, null, `/app/admin/${opts.resource}/${opts.id}/edit`)
    } else {
      history.pushState(null, null, `/app/admin/${opts.resource}/new`)
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
        this.opts.api[opts.resource].update(opts.id, this.record)
        .fail(this.errorHandler)
        .then(id => {
          this.update({busy:false})
          //this.closeModal()
        })
      }else{
        this.opts.api[opts.resource].create(this.record)
        .fail(this.errorHandler)
        .then(record => {
          this.update({busy:false})
          this.opts.id = record.id
          history.pushState(null, null, `/app/admin/${opts.resource}/${record.id}/edit`)
          //this.closeModal()
        })
      }
    }

    this.updateRecord = (record) => {
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

    this.setInputValue = (e) => {
      this.record[e.target.name] = e.target.value
    }

    this.tags['r-typeahead-input'][0].on('itemselected', (item) => {
      this.record.project_id = item.id
      this.update()
    })
    this.tags['r-typeahead-input'][1].on('itemselected', (item) => {
      this.record.professional_id = item.id
      this.update()
    })
    this.tags['r-typeahead-input'][2].on('itemselected', (item) => {
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
</r-admin-quote-form>
