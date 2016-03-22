
<r-project-quotes>

  <h2 class="mt0">Quotes</h2>

  <p if="{hasNothing()}">
    Hmm, it seems we are still working on your tender and it will show up here when it's ready.
    You can speed up the process by creating a tender document and we will be notified about it.
    <div if="{hasNothing() && currentAccount.isProfessional}" class="mt2">
      <a class="btn btn-primary" href="/app/projects/{opts.id}/quotes/new">Create a Quote</a>
    </div>
    <div if="{hasNothing() && currentAccount.isCustomer}" class="mt2">
      <a class="btn btn-primary" href="/app/projects/{opts.id}/tenders/new">Create a Tender Document</a>
    </div>
    <div if="{hasNothing() && currentAccount.isAdministrator}" class="mt2">
      <a class="btn btn-primary mr1" href="/app/projects/{opts.id}/tenders/new">Create a Tender Document</a>
      <a class="btn btn-primary" href="/app/projects/{opts.id}/quotes/new">Create a Quote</a>
    </div>
  </p>

  <p if="{ !_.isEmpty(project.tender) && _.isEmpty(quotes) && currentAccount.isCustomer}">
    Here is your <a href="/app/projects/{opts.id}/tenders/${project.tender.id}">Tender Document</a>.
    Actual <strong>quotes</strong> from Professionals will appear here when they submit them.
  </p>
  <p if="{ !_.isEmpty(project.tender) && _.isEmpty(quotes) && currentAccount.isProfessional}">
    Here is the the <a href="/app/projects/{opts.id}/tenders/${project.tender.id}">Tender Document</a>.
    Click <strong>Clone</strong> button to get your copy and work on it.
  </p>

  <ul class="list-reset mxn1">

    <li if="{project.tender}" class="block p1 sm-col-12 align-top">
      <div class="px2 border">
        <h2 class="inline-block">{ formatCurrency(project.tender.total_amount) }</h2>
        <span class="inline-block align-middle h6 mb1 px1 border pill right mt2">Tender</span>
        <p class="overflow-hidden m0 mxn2 p1 border-top">
          <a class="btn btn-small" href="/app/projects/{opts.id}/tenders/{project.tender.id}">Open</a>
          <a class="btn btn-small btn-primary" if="{currentAccount.isProfessional && (quotes && quotes.length == 0)}" onclick="{clone}">Clone</a>
        </p>
      </div>
    </li>

    <li each="{quotes}" class="block p1 sm-col-12 align-top">
      <div class="px2 border clearfix">
        <h2 class="inline-block">{ formatCurrency(total_amount) }</h2>
        <span if="{accepted_at}" class="inline-block align-middle h6 mb1 px1 border bg-lime navy pill right mt2">Accepted</span>
        <span if="{!accepted_at && submitted_at}" class="inline-block align-middle h6 mb1 px1 border pill mr1">Submitted</span>
        <span class="inline-block align-middle h6 mb1 px1 border pill right mt2 mr1">Quote</span>
        <span class="italic mt2 mr1">by { professional.profile.first_name } {professional.profile.last_name }</span>
        <div class="clearfix overflow-hidden m0 mxn2 p1 {'bg-lime': accepted_at, 'bg-yellow': (submitted_at && !accepted_at), 'bg-gray white': (!submitted_at && !accepted_at)}">
          <span if="{!accepted_at && submitted_at}"><i class="fa fa-clock-o mr1"></i>submitted at: {fromNow(submitted_at)}</i></span>
          <span if="{accepted_at}"><i class="fa fa-clock-o mr1"></i>accepted at: {fromNow(accepted_at)}</i></span>
          <div class="mt1">
            <a class="btn btn-small bg-darken-2" href="/app/projects/{parent.opts.id}/quotes/{id}">Open</a>
            <a class="btn btn-small bg-darken-2" if="{currentAccount.isProfessional && !accepted_at}" onclick="{delete}">Delete</a>
          </div>
        </div>
      </div>
    </li>
  </ul>

  <script>

  this.hasNothing = () => {
    return _.isEmpty(this.project.tender) && _.isEmpty(this.quotes)
  }

  this.on('mount', () => {
    opts.api.quotes.on('index.fail', this.errorHandler)
    opts.api.quotes.on('index.success', this.updateQuote)
    opts.api.quotes.on('create.success', this.addQuote)
    opts.api.quotes.on('delete.success', this.removeQuote)
    opts.api.quotes.index({project_id: opts.id})
  })
  this.on('unmount', () => {
    opts.api.quotes.off('index.fail', this.errorHandler)
    opts.api.quotes.off('index.success', this.updateQuote)
    opts.api.quotes.off('create.success', this.addQuote)
    opts.api.quotes.off('delete.success', this.removeQuote)
  })

  this.updateQuote = (quotes) => this.update({quotes})

  this.addQuote = (quote) => {
    this.quotes = this.quotes || []
    if (!_.findWhere(this.quotes, {id: quote.id})) {
      this.quotes.push(quote)
    }
    this.update()
  }

  this.removeQuote = (id) => {
    let _id = _.findIndex(this.quotes, q => q.id === id)
    if (_id > -1) this.quotes.splice(_id, 1)
    this.update()
  }

  this.clone = (e) => {
    e.preventDefault()
    opts.api.quotes.create({
      project_id: opts.id,
      tender_id: this.project.tender.id,
      professional_id: this.currentAccount.user_id
    })
  }

  this.delete = (e) => {
    e.preventDefault()
    if (window.confirm(this.ERRORS.CONFIRM_DELETE)) {
      opts.api.quotes.delete(e.item.id)
    }
  }

  this.mixin('projectTab')
  </script>
</r-project-quotes>
