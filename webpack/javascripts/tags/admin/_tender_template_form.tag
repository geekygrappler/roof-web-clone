import from '../../mixins/tender.js'

<r-admin-tender-template-form>


  <div class="container p2">
    <h1><input type="text" name="name" value="{ record.name }"
      class="block col-12 field" placeholder="Name" oninput="{setInputValue}"/></h1>

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
    <p>When you apply a template to a project, if there isn't Tender on the project it clones itself to project,
      if Tender exists it apply changes to project's tender
    </p>
    <div class="sm-col sm-col-9">
    <select name="project_ids[]" id="project_ids" multiple class="block col-12 mb2 field">
      <option each="{projects}" value="{id}">#{id} | {name} | {customers[0].profile.first_name} {customers[0].profile.last_name}</option>
    </select>
    </div>
    <div class="sm-col sm-col-3 center px1 right-align">
      <a class="block center white btn bg-blue {busy: busy}" onclick="{addToProject}">Apply to Project(s)</a>
    </div>
  </div>

  </div>
  <script>
    this.record = {name: null, document: {sections: []}}

    this.headers = {
      task: {name: 6, quantity: 1, price: 1, total_cost: 2, actions: 2},
      material: {name: 5, quantity: 1, price: 1, total_cost: 2, supplied: 1, actions: 2}
    }

    this.on('mount', () => {
      this.opts.api[opts.resource].on('show.fail', this.errorHandler)
      this.opts.api[opts.resource].on('show.success', this.updateRecord)
      opts.api.tenders.on('create.fail', this.errorHandler)
      opts.api.tenders.on('create.success', this.updateReset)
    })
    this.on('unmount', () => {
      this.opts.api[opts.resource].off('show.fail', this.errorHandler)
      this.opts.api[opts.resource].off('show.success', this.updateRecord)
      opts.api.tenders.off('create.fail', this.errorHandler)
      opts.api.tenders.off('create.success', this.updateReset)
    })

    if (opts.id) {
      this.opts.api[opts.resource].show(opts.id)
      this.loadResources('projects')
      history.pushState(null, null, `/app/admin/${opts.resource}/${opts.id}/edit`)
    } else {
      history.pushState(null, null, `/app/admin/${opts.resource}/new`)
    }

    this.submit = (e) => {
      if (e) e.preventDefault()

      this.update({busy: true, errors: null})
      this.record.name = this.name.value

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

    this.addToProject = (e) => {
      e.preventDefault()

      let ids = $(this.project_ids).serializeJSON({parseAll: true}).project_ids
      _.each(ids, id => {
        opts.api.tenders.create({
          project_id: id, tender_template_id: this.record.id
        })

      })
      this.update({busy: true})
    }

    this.setInputValue = (e) => {
      this.record[e.target.name] = e.target.value
    }

    this.mixin('tenderMixin')

  </script>
</r-admin-tender-template-form>
