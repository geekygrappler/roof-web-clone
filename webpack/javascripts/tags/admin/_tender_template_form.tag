import from '../../mixins/tender.js'

<r-admin-tender-template-form>
  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>

  <div class="container p2">

    <h2 class="center mt0 mb2">{opts.id ? 'Editing' : 'Creating'} { opts.resource.singular().humanize() }</h2>

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

    <div class="py3">
    <h4 class="right-align m0"><label><input type="checkbox" onchange="{toggleVat}" checked="{record.document.include_vat}" class="mr1">VAT {tenderVat()}</label></h4>
    <h3 class="right-align m0">Estimated total{ record.document.include_vat ? '(Inc. VAT)' : ''}: { tenderTotal() }</h3>
    </div>

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
    <r-typeahead-input resource="projects" api="{ opts.api }" datum_tokenizer="{['name', 'account_email']}"></r-typeahead-input>
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
        .then(id => {
          this.update({busy:false})
          this.closeModal()
        })
      }else{
        this.opts.api[opts.resource].create(this.record)
        .fail(this.errorHandler)
        .then(record => {
          this.update({busy:false})
          this.opts.id = record.id
          // history.pushState(null, null, `/app/admin/${opts.resource}/${record.id}/edit`)
          this.closeModal()
        })
      }
    }

    this.updateRecord = (record) => {
      this.update({record: record})
    }

    this.setInputValue = (e) => {
      this.record[e.target.name] = e.target.value
    }

    this.tags['r-typeahead-input'].on('itemselected', (item) => {
      this.update({busy: true})
      opts.api.tenders.create({
        project_id: item.id, tender_template_id: this.record.id
      })
    })

    this.mixin('tenderMixin')

  </script>
</r-admin-tender-template-form>
