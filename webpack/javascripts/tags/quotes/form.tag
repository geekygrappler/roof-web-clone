import from '../../mixins/typeahead.js'
import from '../../mixins/tender.js'

<r-quotes-form>

  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>

  <div class="container p2 {readonly: opts.readonly}">
    <h1>{ opts.id ? (opts.readonly ? 'Showing' : 'Editing') + ' Quote ' + opts.id : 'New Quote' }</h1>

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


      <button if="{opts.id && (opts.api.currentAccount && opts.api.currentAccount.user_type == 'Customer')}"
      class="btn btn-primary btn-big {busy: busy}" onclick="{acceptQuote}" disabled="{tender.accepted_at}">{tender.accepted_at ? 'Accepted' : 'Accept'} <span if="{tender.accepted_at}">{fromNow(tender.accepted_at)}</span></button>

      <virtual if="{opts.api.currentAccount && opts.api.currentAccount.user_type != 'Customer'}">
        <button type="submit" class="btn btn-primary btn-big {busy: busy}">Save</button>
        <a if="{opts.id}" class="btn btn-primary btn-big {busy: busy}" onclick="{submitQuote}">Submit</a>
      </virtual>
    </form>
  </div>
  <script>

    this.headers = {
      task: {name: 6, quantity: 1, price: 1, total_cost: 2, actions: opts.readonly ? null : 2},
      material: {name: 5, quantity: 1, price: 1, total_cost: 2, supplied: 1, actions: opts.readonly ? null : 2}
    }

    if (opts.id) {
      opts.api.quotes.on('show.fail', this.errorHandler)
      opts.api.quotes.on('show.success', tender => {
        this.update({tender: tender})
      })
      opts.api.quotes.show(opts.id)
    } else {
      this.tender = {project_id: this.opts.project_id, document: {sections: []}}
    }

    this.submit = (e) => {
      if (e) e.preventDefault()

      this.update({busy: true})

      if (this.opts.id) {
        this.opts.api.quotes.update(opts.id, this.tender)
        .fail(this.errorHandler)
        .then(id => this.update({busy:false}))
      }else{
        this.opts.api.quotes.create(this.tender)
        .fail(this.errorHandler)
        .then(tender => {
          this.update({busy:false})
          this.opts.id = tender.id
          history.pushState(null, null, `/app/projects/${tender.project_id}/quotes/${tender.id}`)
        })
      }
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

    this.mixin('tenderMixin')

  </script>
</r-quotes-form>
