import from '../../mixins/tender.js'

<r-quotes-form>

  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>

  <div class="container p2 {readonly: isReadonly()} border">
    <div class="clearfix">
      <div class="left mb4 overflow-hidden">
        <h1 class="mb0">{ opts.id ? getTitle() : 'New Quote' }</h1>
        <a class="btn btn-small h6 btn-outline orange" href="/app/projects/{record.project_id}"><i class="fa fa-chevron-left"></i> Back to Project</a>
      </div>
      <div class="right h5 mt3 align-right">
        <div>Created at: {formatTime(record.created_at)}</div>
        <div if="{record.submitted_at}">Submitted at: {formatTime(record.submitted_at)}</div>
        <div if="{record.accepted_at}">Accepted at: {formatTime(record.accepted_at)}</div>
      </div>
    </div>


    <div if="{currentAccount.isAdministrator}">
    <label for="project_id">Professional</label>
    <input type="hidden" name="professional_id" value="{record.professional_id}">
    <r-typeahead-input resource="professionals" api="{ opts.api }" id="{record.professional_id}" filters="{professionalFilters()}" datum_tokenizer="{['full_name']}"></r-typeahead-input>
    <span if="{errors.professional_id}" class="inline-error">{errors.professional_id}</span>

    <label for="tender_id">Tender</label>
    <input type="hidden" name="tender_id" value="{record.tender_id}">
    <r-typeahead-input resource="tenders" api="{ opts.api }" id="{record.tender_id}" filters="{tenderFilters()}" datum_tokenizer="{['id', 'total_amount']}"></r-typeahead-input>
    <span if="{errors.tender_id}" class="inline-error">{errors.tender_id}</span>
    </div>

    <div class="clearfix mb4">
      <div class="sm-col sm-col-6">
        <h4>From</h4>
        <address>
          {record.professional.profile.first_name} {record.professional.profile.last_name}<br>
          <virtual if="{!isAllValuesEmpty(record.professional.address)}">
            {record.professional.address.street_address}<br>
            {record.professional.address.postcode}, {record.professional.address.city}<br>
            {record.professional.address.country}
          </virtual>
        </address>
      </div>
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

    <form name="form" onsubmit="{ submit }">

      <div class="clearfix mxn2">
        <div class="sm-col sm-col-6 px2">
        <label>Insurance Amount</label>

        <select name="insurance_amount" class="block col-12 field mb2" onchange="{setVal}" if="{!currentAccount.isCustomer}">
          <option>Select</option>
          <option each="{_, i in new Array(19)}" key="0" value="{(i+1)}" selected="{record.insurance_amount == (i+1)}">{(i+1) + ' Million'}</option>
        </select>
        <p if="{currentAccount.isCustomer}">{record.insurance_amount ?  record.insurance_amount + ' Million' : 'N/A'}</p>
        </div>

        <div class="sm-col sm-col-6 px2">
        <label>Guarantee Length</label>
        <select name="guarantee_length" class="block col-12 field mb2" onchange="{setVal}" if="{!currentAccount.isCustomer}">
          <option>Select</option>
          <option each="{_, i in new Array(19)}" key="0" value="{(i+1)}" selected="{record.guarantee_length == (i+1)}">{(i+1) + (i > 0 ? ' Years' : ' Year')}</option>
        </select>
        <p if="{currentAccount.isCustomer}">{record.guarantee_length ? record.guarantee_length + ' Years' : 'N/A'} </p>
        </div>
      </div>

      <label>Summary</label>
      <textarea type="text" name="summary" placeholder="Summary" class="block col-12 field mb2" oninput="{setVal}" if="{!currentAccount.isCustomer}">{record.summary}</textarea>
      <p if="{currentAccount.isCustomer}">{record.summary ? record.summary : 'N/A'}</p>

      <div if="{errors}" id="error_explanation" class="left-align">
        <ul>
          <li each="{field, messsages in errors}"> <strong>{field.humanize()}</strong> {messsages} </li>
        </ul>
      </div>

      <div class="right-align">
        <button if="{opts.id && !currentAccount.isProfessional && record.submitted_at}"
        class="btn btn-primary btn-big {busy: busy}" onclick="{acceptQuote}" disabled="{record.accepted_at}">
        {record.accepted_at ? 'Accepted' : 'Accept'} <span if="{record.accepted_at}">{fromNow(record.accepted_at)}</span>
        </button>

        <virtual if="{!opts.readonly && !currentAccount.isCustomer}">
          <button type="submit" class="btn btn-primary btn-big {busy: busy}">Save</button>
          <a if="{opts.id}" class="btn bg-green white btn-big {busy: busy}" onclick="{submitQuote}">
            {record.submitted_at ? 'Submitted' : 'Submit'} <span if="{record.submitted_at}">{fromNow(record.submitted_at)}</span>
          </a>
        </virtual>
      </div>

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

    this.setVal = (e) => {
      this.record[e.target.name] = e.target.value
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
        this.opts.api.quotes.submit(this.opts.id, this.record)
        .fail(this.errorHandler)
        .then(id => {
          this.record.submitted_at = new Date()
          this.update({busy:false})
        })
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
