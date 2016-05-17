import from '../../mixins/tender.js'
import './_tender_item_input.tag'
import './_tender_item.tag'
import './_tender_item_group.tag'
import './_tender_section.tag'

<r-tenders-form>

  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>

  <div class="container p2 {readonly: opts.readonly}">
    <h1> { opts.id ? (opts.readonly ? 'Showing' : 'Editing') + ' Tender ' + opts.id : 'New Tender' }</h1>

    <a class="mb1 btn btn-small h6 btn-outline orange" href="/app/projects/{project.id}">
      <i class="fa fa-chevron-left"></i> Back to Project
    </a>

    <r-tender-section each="{ section , i in record.document.sections }" no-reorder></r-tender-section>

    <div class="py3">
    <h2 class="right-align m0"><label><input type="checkbox" onchange="{toggleVat}" checked="{record.document.include_vat}" class="mr1">VAT {tenderVat()}</label></h2>
    <h1 class="right-align m0">Estimated total{ record.document.include_vat ? '(Inc. VAT)' : ''}: { tenderTotal }</h2>
    </div>

    <form if="{ !opts.readonly && record.document }" onsubmit="{ addSection }" class="mt3 py3 clearfix mxn1 border-top">
      <div class="col col-8 px1">
        <input type="text" name="sectionName" placeholder="Section name" class="block col-12 field" />
      </div>
      <div class="col col-4 px1">
        <button type="submit" class="block col-12 btn btn-primary"><i class="fa fa-puzzle-piece"></i> Add Section</button>
      </div>
    </form>

    <form name="form" onsubmit="{ submit }" class="right-align">

      <div if="{errors}" id="error_explanation" class="left-align">
        <ul>
          <li each="{field, messsages in errors}"> <strong>{field.humanize()}</strong> {messsages} </li>
        </ul>
      </div>

      <button if="{!currentAccount.isProfessional}" type="submit" class="btn btn-primary btn-big {busy: busy}">Save</button>
      <a if="{currentAccount.isProfessional}" onclick="{cloneTender}" class="btn btn-primary btn-big {busy: busy}">Clone</a>
    </form>
  </div>
  <script>
  this.type = 'Tender'
    this.headers = {
      task: {name: 3, description: 4, quantity: 3, actions: 2},
      material: {name: 3, description: 4, quantity: 3, actions: 2}
    }

    if(opts.readonly) {
      delete this.headers.task.actions
      this.headers.task.name = 5
      delete this.headers.material.actions
      this.headers.material.name = 5
    }

    if(opts.api.currentAccount.isAdministrator) {
      this.headers = {
        task: {name: 3, description: 3, quantity: 1, price: 1, total_cost: 2, actions: 2},
        material: {name: 2, description: 3, quantity: 1, price: 1, total_cost: 2, supplied: 1, actions: 2}
      }
    }

    if (opts.id) {
      this.on('mount', () => {
        opts.api.projects.on('show.success', this.updateTenderFromProject)
        opts.api.tenders.on('show.success', this.updateTender)
      })
      this.on('unmount', () => {
        opts.api.projects.off('show.success', this.updateTenderFromProject)
        opts.api.tenders.off('show.success', this.updateRecord)
      })
    } else {
      this.record = {project_id: this.opts.project_id, document: {sections: []}}
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
        this.opts.api.tenders.update(opts.id, this.record)
        .fail(this.errorHandler)
        .then(id => this.update({busy:false}))
      }else{
        this.opts.api.tenders.create(this.record)
        .fail(this.errorHandler)
        .then(record => {
          this.update({busy:false})
          this.opts.id = record.id
          window.location.href = `/app/projects/${record.project_id}/tenders/${record.id}`
        })
      }
    }

    this.updateTenderFromProject = (project) => {
      this.update({record: project.tender})
    }
    this.updateRecord = (record) => {
      this.update({record: record})
    }
    this.cloneTender = (e) => {
      e.preventDefault()
      opts.api.quotes.create({
        project_id: this.record.project_id,
        tender_id: this.record.id,
        professional_id: this.currentAccount.user_id
      })
      .then((quote) => {
        riot.route(`/projects/${this.record.project_id}/quotes/${quote.id}`)
      })
    }

    this.mixin('tenderMixin')
    this.mixin('projectTab')
  </script>
</r-tenders-form>
