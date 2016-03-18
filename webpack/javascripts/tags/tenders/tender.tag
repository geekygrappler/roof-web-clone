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
    <h1>{ opts.id ? (opts.readonly ? 'Showing' : 'Editing') + ' Tender ' + opts.id : 'New Tender' }</h1>

    <r-tender-section each="{ section , i in tender.document.sections }" ></r-tender-section>

    <form if="{ !opts.readonly && tender.document }" onsubmit="{ addSection }" class="mt3 py3 clearfix mxn1 border-top">
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

      <button if="{!currentAccount.isProfessional}" type="submit" class="btn btn-primary btn-big {busy: busy}">Save</button>
    </form>
  </div>
  <script>
    this.headers = {
      task: {name: 7, quantity: 3, actions: 2},
      material: {name: 7, quantity: 3, actions: 2}
    }

    if(opts.readonly) {
      delete this.headers.task.actions
      this.headers.task.name = 9
      delete this.headers.material.actions
      this.headers.material.name = 9
    }

    if(opts.api.currentAccount.isAdministrator) {
      this.headers = {
        task: {name: 6, quantity: 1, price: 1, total_cost: 2, actions: 2},
        material: {name: 5, quantity: 1, price: 1, total_cost: 2, supplied: 1, actions: 2}
      }
    }

    if (opts.id) {
      this.on('mount', () => {
        opts.api.projects.on('show.success', this.updateTenderFromProject)
        opts.api.tenders.on('show.success', this.updateTender)
      })
      this.on('unmount', () => {
        opts.api.projects.off('show.success', this.updateTenderFromProject)
        opts.api.tenders.off('show.success', this.updateTender)
      })
    } else {
      this.tender = {project_id: this.opts.project_id, document: {sections: []}}
    }

    this.submit = (e) => {
      if (e) e.preventDefault()

      this.update({busy: true, errors: null})

      if (this.opts.id) {
        this.opts.api.tenders.update(opts.id, this.tender)
        .fail(this.errorHandler)
        .then(id => this.update({busy:false}))
      }else{
        this.opts.api.tenders.create(this.tender)
        .fail(this.errorHandler)
        .then(tender => {
          this.update({busy:false})
          this.opts.id = tender.id
          history.pushState(null, null, `/app/projects/${tender.project_id}/tenders/${tender.id}`)
        })
      }
    }

    this.updateTenderFromProject = (project) => {
      this.update({tender: project.tender})
    }
    this.updateTender = (tender) => {
      this.update({tender: tender})
    }

    this.mixin('tenderMixin')
    this.mixin('projectTab')
  </script>
</r-tenders-form>
