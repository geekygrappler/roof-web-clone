import from '../../mixins/tender.js'

<r-admin-tender-form>


  <div class="container p2">
    <label for="project_id">Project</label>
    <select name="project_id" class="block col-12 mb2 field" onchange="{setInputValue}">
      <option></option>
      <option each="{projects}" value="{id}" selected="{record.project_id == id}">#{id} | {name} | {customers[0].profile.first_name} {customers[0].profile.last_name}</option>
    </select>
    <span if="{errors.project_id}" class="inline-error">{errors.project_id}</span>

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
    </form>

    <div if="{record.id}" class="mt4 clearfix">
      <p>Add a Professional to this Project by creating a Quote from this tender. Choosen pro will be shortlisted.</p>
      <div class="sm-col sm-col-9">
      <select name="professional_ids[]" id="professional_ids" multiple class="block col-12 mb2 field">
        <option each="{professionals}" value="{id}">#{id} | {profile.first_name} | {profile.last_name}</option>
      </select>
      </div>
      <div class="sm-col sm-col-3 px1 center white">
        <a class="btn bg-blue {busy: busy}" onclick="{createQuote}">Create Quote!</a>
      </div>
    </div>
  </div>
  <script>

    this.record = {project_id: null, document: {sections: []}}
    this.projects = []
    this.professionals = []

    this.headers = {
      task: {name: 6, quantity: 1, price: 1, total_cost: 2, actions: 2},
      material: {name: 5, quantity: 1, price: 1, total_cost: 2, supplied: 1, actions: 2}
    }

    this.on('mount', () => {
      this.opts.api[opts.resource].on('show.fail', this.errorHandler)
      this.opts.api[opts.resource].on('show.success', this.updateRecord)
      opts.api.quotes.on('create.fail', this.errorHandler)
      opts.api.quotes.on('create.success', this.updateReset)
    })
    this.on('unmount', () => {
      this.opts.api[opts.resource].off('show.fail', this.errorHandler)
      this.opts.api[opts.resource].off('show.success', this.updateRecord)
      opts.api.quotes.off('create.fail', this.errorHandler)
      opts.api.quotes.off('create.success', this.updateReset)
    })

    if (opts.id) {
      this.opts.api[opts.resource].show(opts.id)
      this.loadResources('professionals')
      history.pushState(null, null, `/app/admin/${opts.resource}/${opts.id}/edit`)
    } else {
      history.pushState(null, null, `/app/admin/${opts.resource}/new`)
    }
    this.loadResources('projects')

    this.submit = (e) => {
      if (e) e.preventDefault()

      this.record.project_id = this.project_id.value

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

    this.createQuote = (e) => {
      e.preventDefault()

      let ids = $(this.professional_ids).serializeJSON({parseAll: true}).professional_ids

      _.each(ids, id => {
        opts.api.quotes.create({
          project_id: this.record.project_id,
          tender_id: this.record.id,
          professional_id: id
        })
      })
      this.update({busy: true})
    }

    this.setInputValue = (e) => {
      this.record[e.target.name] = e.target.value
    }

    this.mixin('tenderMixin')

  </script>
</r-admin-tender-form>
