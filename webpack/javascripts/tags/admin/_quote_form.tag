import from '../../mixins/tender.js'

<r-admin-quote-form>


  <div class="container p2">

    <label for="project">Project</label>
    <select name="project_id" class="block col-12 mb2 field" onchange="{setInputValue}">
      <option></option>
      <option each="{projects}" value="{id}" selected="{record.project_id == id}">#{id} | {name} | {customers[0].profile.first_name} {customers[0].profile.last_name}</option>
    </select>
    <span if="{errors.project}" class="inline-error">{errors.project}</span>

    <label for="project_id">Professional</label>
    <select name="professional_id" class="block col-12 mb2 field" onchange="{setInputValue}">
      <option></option>
      <option each="{professionals}" value="{id}" selected="{record.professional_id == id}">#{id} | {profile.first_name} {profile.last_name}</option>
    </select>
    <span if="{errors.professional_id}" class="inline-error">{errors.professional_id}</span>

    <label for="tender_id">Tender</label>
    <select name="tender_id" class="block col-12 mb2 field" onchange="{setInputValue}">
      <option></option>
      <option each="{tenders}" value="{id}" selected="{record.tender_id == id}">#{id}</option>
    </select>
    <span if="{errors.tender_id}" class="inline-error">{errors.project}</span>

    <r-tender-section each="{ section , i in record.document.sections }" ></r-tender-section>

    <form if="{ !opts.readonly && record.document }" onsubmit="{ addSection }" class="mt3 py3 clearfix mxn1 border-top">
      <div class="col col-8 px1">
        <input type="text" name="sectionName" placeholder="Section name" class="block col-12 field" />
      </div>
      <div class="col col-4 px1">
        <button type="submit" class="block col-12 btn btn-primary"><i class="fa fa-puzzle-piece"></i> Add Section</button>
      </div>
    </form>

    <h3 class="right-align m0 py3">Estimated total: { tenderTotal() }</h3>

    <form name="form" onsubmit="{ submit }" class="right-align">

      <div if="{errors}" id="error_explanation" class="left-align">
        <ul>
          <li each="{field, messsages in errors}"> <strong>{field.humanize()}</strong> {messsages} </li>
        </ul>
      </div>

      <button type="submit" class="btn btn-primary btn-big {busy: busy}">Save</button>

      <a if="{record.id}" class="btn bg-green white btn-big {busy: busy}" onclick="{submitQuote}">Submit</a>
      <a if="{record.id}"
      class="btn bg-red btn-big {busy: busy}" onclick="{acceptQuote}" disabled="{record.accepted_at}">
      {record.accepted_at ? 'Accepted' : 'Accept'} <span if="{record.accepted_at}">{fromNow(record.accepted_at)}</span>
      </a>

    </form>
  </div>
  <script>

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
    this.loadResources('projects')
    this.loadResources('professionals')
    this.loadResources('tenders')

    this.record = {name: null, document: {sections: []}}
    if (opts.id) {
      this.opts.api[opts.resource].show(opts.id)
      history.pushState(null, null, `/app/admin/${opts.resource}/${opts.id}/edit`)
    } else {
      history.pushState(null, null, `/app/admin/${opts.resource}/new`)
    }

    this.submit = (e) => {
      if (e) e.preventDefault()

      this.update({busy: true, errors: null})

      if (this.opts.id) {
        this.opts.api[opts.resource].update(opts.id, this.record)
        .fail(this.errorHandler)
        .then(id => this.update({busy:false}))
      }else{
        this.opts.api[opts.resource].create(this.record)
        .fail(this.errorHandler)
        .then(record => {
          this.update({busy:false})
          this.opts.id = record.id
          history.pushState(null, null, `/app/admin/${this.resource}/${record.id}/edit`)
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

    this.mixin('tenderMixin')

  </script>
</r-admin-quote-form>
