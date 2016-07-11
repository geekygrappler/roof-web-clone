
import './_tender_summary.tag'
import './_project_payments.tag'

<r-project-quotes>

  <h2 class="mt0">Quotes</h2>

  <div if="{_.isEmpty(this.quotes) && !currentAccount.isCustomer}" class="mt2">
    <p>There is no quote yet</p>
    <a class="btn btn-primary mb2" href="/app/projects/{opts.id}/quotes/new">Create a Quote</a>
  </div>

  <div if="{_.isEmpty(this.quotes) && currentAccount.isCustomer}" class="mt2">
    <p>There is no quote submitted yet</p>
  </div>

  <a if="{!_.isEmpty(this.quotes) && currentAccount.isAdministrator}" class="btn btn-primary mb2" href="/app/projects/{opts.id}/quotes/new">Create a Quote</a>

  <ul class="list-reset mxn1">

    <li each="{quotes}" class="block p1 sm-col-12 align-top">
      <div class="px2 border clearfix">
        <h2 class="inline-block sm-mb4">{ formatCurrency(total_amount) }</h2>


        <div class="inline-block mt2 p2 border sm-right mb2 sm-mb0">
          <span if="{submitted_at}">
            <i class="fa fa-clock-o mr1"></i> Submitted at: {fromNow(submitted_at)}<br>
          </span>
          <span if="{accepted_at}">
            <i class="fa fa-clock-o mr1"></i> Accepted at: {fromNow(accepted_at)}<br>
          </span>
          <span>
            <i class="fa fa-user mr1"></i> Professional: <strong>{ professional.profile.first_name } {professional.profile.last_name }</strong>
          </span>
        </div>

        <div class="tab-nav">
          <a class="btn btn-narrow border-left border-top border-right {active: activeTab == 'section'}"
          onclick="{changeTab}" rel="section">Section Breakdown </a>
          <a class="btn btn-narrow border-left border-top border-right {active: activeTab == 'summary'}"
          onclick="{changeTab}" rel="summary">Trade Breakdown</a>
          <a class="btn btn-narrow border-left border-top border-right {active: activeTab == 'payments'}"
          onclick="{changeTab}" rel="payments">Payments</a>
        </div>
        <div class="tabs m0 mxn2 border-top">

          <div if="{activeTab == 'section'}" class="mt2">

            <r-tender-summary document="{document}" type='sections'></r-tender-summary>

            <div class="clearfix overflow-hidden p1 bg-yellow">
              <a class="btn btn-small bg-darken-2" href="/app/projects/{parent.opts.id}/quotes/{id}">Open</a>
              <a class="btn btn-small bg-darken-2" if="{!currentAccount.isCustomer && !accepted_at}" onclick="{delete}">Delete</a>
            </div>

          </div>

          <div if="{activeTab == 'summary'}" class="mt2">

            <r-tender-summary document="{document}" type='trade'></r-tender-summary>

            <div class="clearfix overflow-hidden p1 bg-yellow">
              <a class="btn btn-small bg-darken-2" href="/app/projects/{parent.opts.id}/quotes/{id}">Open</a>
              <a class="btn btn-small bg-darken-2" if="{!currentAccount.isCustomer && !accepted_at}" onclick="{delete}">Delete</a>
            </div>

          </div>

          <div if="{activeTab == 'payments'}" class="mt2">
            <r-project-payments api="{opts.api}" quote="{this}" payment_id="{parent.opts.payment_id}"></r-project-payments>
          </div>

        </div>

      </div>
    </li>
  </ul>

  <script>

  this.activeTab = this.opts.tab || 'section'

  this.changeTab = (e) => {
    e.preventDefault()
    this.update({activeTab: e.target.rel})
    history.pushState(null,null,
      _.contains(['summary', 'sections'], this.activeTab) ? window.location.href.replace('payments', 'quotes') :
      window.location.href.replace('quotes','payments')
    )
  }

  this.on('mount', () => {
    opts.api.quotes.on('index.fail', this.errorHandler)
    opts.api.quotes.on('index.success', this.updateQuote)
    opts.api.quotes.on('create.success', this.addQuote)
    opts.api.quotes.on('delete.success', this.removeQuote)
    opts.api.quotes.index({project_id: opts.id, id: opts.quote_id})
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

  this.delete = (e) => {
    e.preventDefault()
    if (window.confirm(this.ERRORS.CONFIRM_DELETE)) {
      opts.api.quotes.delete(e.item.id)
    }
  }

  this.mixin('projectTab')
  </script>
</r-project-quotes>
