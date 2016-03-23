import Pikaday from 'pikaday-time/pikaday'

<r-payment-form>
  <h2 class="center mt0 mb2">Payment Form</h2>
  <form name="form" class="sm-col-12 left-align" action="/api/payments" onsubmit="{submit}">
    <input type="hidden" name="project_id" value="{record.project_id}" />
    <input type="hidden" name="quote_id" value="{record.quote_id}" />
    <input type="hidden" name="professional_id" value="{record.professional_id}" />

    <input class="block col-12 mb2 field"
    type="number" name="amount" value="{record.amount}" placeholder="Amount"/>
    <span if="{errors['amount']}" class="inline-error">{errors['amount']}</span>

    <input class="block col-12 mb2 field"
    type="text" name="due_date" value="{record.due_date}" placeholder="Due Date"/>
    <span if="{errors['due_date']}" class="inline-error">{errors['due_date']}</span>

    <textarea class="block col-12 mb2 field"
    type="text" name="description" placeholder="Description" >{record.description}</textarea>
    <span if="{errors['description']}" class="inline-error">{errors['description']}</span>

    <div if="{errors}" id="error_explanation">
      <ul>
        <li each="{field, messages in errors}">{field.humanize()} {messages.join(',')}</li>
      </ul>
    </div>

    <button type="submit" class="block col-12 mb2 btn btn-big btn-primary {busy: busy}">Create</button>

  </form>
  <script>
  this.on('mount', () => {
    let picker = new Pikaday({
      showTime: false,
      field: this.due_date,
      onSelect:  (date) => {
        this.record.due_date = picker.toString()
        this.update()
      }
    })
  })

  this.updateRecord = (record) => {
    this.update({record})
  }

  if (!this.opts.id) {
    this.record = {
      project_id: opts.quote.project_id,
      quote_id: opts.quote.id,
      professional_id: this.currentAccount.user_id,
    }
  } else {
    this.opts.api.payments.show(this.opts.id)
    .fail(this.errorHandler)
    .then(this.updateRecord)
  }

  this.submit = (e) => {
    e.preventDefault()

    let data = this.serializeForm(this.form)

    if (_.isEmpty(data) || _.isEmpty(data.due_date)) {
      $(this.form).animateCss('shake')
      return
    }

    this.update({busy: true, errors: null})

    if (this.opts.id) {
      this.opts.api.payments.update(opts.id, data)
      .fail(this.errorHandler)
      .then(this.updateReset)
    }else{
      this.opts.api.payments.create(data)
      .fail(this.errorHandler)
      .then(record => {
        this.updateReset()
        this.opts.id = record.id
        this.closeModal()
      })
    }
  }
  </script>
</r-payment-form>

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
        <span class="inline-block align-middle h6 mb1 px1 border pill right mt2 mr1">Quote</span>

        <div class="tab-nav">
          <a class="btn btn-narrow border-left border-top border-right {active: activeTab == 'summary'}"
          onclick="{changeTab}" rel="summary">Summary</a>
          <a class="btn btn-narrow border-left border-top border-right {active: activeTab == 'payments'}"
          onclick="{changeTab}" rel="payments">Payments</a>
        </div>
        <div class="tabs m0 mxn2 border-top">

          <div if="{activeTab == 'summary'}">

            <div class="clearfix px2 mt2 mb1" if="{submitted_at}">
              <div class="sm-col sm-col-6"><i class="fa fa-clock-o mr1"></i> Submitted at:</div>
              <div class="sm-col sm-col-6">{fromNow(submitted_at)}</div>
            </div>
            <div class="clearfix px2 mb1" if="{accepted_at}">
              <div class="sm-col sm-col-6"><i class="fa fa-clock-o mr1"></i> Accepted at:</div>
              <div class="sm-col sm-col-6">{fromNow(accepted_at)}</div>
            </div>
            <div class="clearfix px2 mb1">
              <div class="sm-col sm-col-6"><i class="fa fa-user mr1"></i> Professional:</div>
              <div class="sm-col sm-col-6">{ professional.profile.first_name } {professional.profile.last_name }</div>
            </div>
            <div class="clearfix overflow-hidden p1 bg-yellow">
              <a class="btn btn-small bg-darken-2" href="/app/projects/{parent.opts.id}/quotes/{id}">Open</a>
              <a class="btn btn-small bg-darken-2" if="{currentAccount.isProfessional && !accepted_at}" onclick="{delete}">Delete</a>
            </div>

          </div>

          <div if="{activeTab == 'payments'}">
            <table class="table-light mt2">
              <thead>
                <tr>
                  <th>Amount</th> <th>Due Date</th> <th>Status</th> <th></th>
                </tr>
              </thead>
              <tbody>
                <tr each="{payments}">
                  <th>{formatCurrency(amount)}</th>
                  <th>{formatTime(due_date)}</th>
                  <th>{parsePaymentStatus()}</th>
                  <th>
                    <a if="{currentAccount.isProfessional && (parsePaymentStatus() == 'payable' || parsePaymentStatus() == 'waiting')}"
                    class="btn btn-small bg-red white h6 {busy: busy}" onclick="{cancelPayment}">Cancel</a>
                    <button if="{currentAccount.isCustomer && parsePaymentStatus() == 'payable'}"
                    class="btn btn-small bg-green white h6 {busy: busy}" disabled="{busy}" onclick="{payPayment}">Pay</button>
                  </th>
                </tr>
              </tbody>
            </table>

            <table if="{payments.length > 0}" class="table-light mt2">
              <thead>
                <tr>
                  <th>Paid</th>
                  <th if="{refunded_amount > 0}">Refunded</th>
                  <th if="{declined_amount > 0}">Declined</th>
                  <th if="{currentAccount.isProfessional}">Approved</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <th>{formatCurrency(paid_amount)}</th>
                  <th if="{refunded_amount > 0}">{formatCurrency(refunded_amount)}</th>
                  <th if="{declined_amount > 0}">{formatCurrency(declined_amount)}</th>
                  <th if="{currentAccount.isProfessional}">{formatCurrency(approved_amount)}</th>
                </tr>
              </tbody>
            </table>

            <div if="{currentAccount.isProfessional}" class="clearfix overflow-hidden p1 bg-yellow">
              <div class="mt1">
                <a class="btn btn-small bg-darken-2" onclick="{openPaymentForm}">Add Payment</a>
              </div>
            </div>
          </div>
        </div>

      </div>
    </li>
  </ul>

  <script>
  this.activeTab = 'summary'
  this.changeTab = (e) => {
    e.preventDefault()
    this.update({activeTab: e.target.rel})
  }

  this.hasNothing = () => {
    return _.isEmpty(this.project.tender) && _.isEmpty(this.quotes)
  }

  this.on('mount', () => {
    opts.api.quotes.on('index.fail', this.errorHandler)
    opts.api.quotes.on('index.success', this.updateQuote)
    opts.api.quotes.on('create.success', this.addQuote)
    opts.api.quotes.on('delete.success', this.removeQuote)

    opts.api.payments.on('create.success', this.addPayment)
    opts.api.payments.on('cancel.success', this.removePayment)
    opts.api.payments.on('cancel.fail', this.errorHandler)
    opts.api.payments.on('pay.success', this.reload)
    opts.api.payments.on('pay.fail', this.errorHandler)
    opts.api.quotes.index({project_id: opts.id})
  })
  this.on('unmount', () => {
    opts.api.quotes.off('index.fail', this.errorHandler)
    opts.api.quotes.off('index.success', this.updateQuote)
    opts.api.quotes.off('create.success', this.addQuote)
    opts.api.quotes.off('delete.success', this.removeQuote)

    opts.api.payments.off('create.success', this.addPayment)
    opts.api.payments.off('cancel.success', this.removePayment)
    opts.api.payments.off('cancel.fail', this.errorHandler)
    opts.api.payments.off('pay.success', this.reload)
    opts.api.payments.off('pay.fail', this.errorHandler)
  })

  this.reload = () => opts.api.quotes.index({project_id: opts.id})

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

  this.openPaymentForm = (e) => {
    e.preventDefault()
    riot.mount('r-modal', {
      content: 'r-payment-form',
      persisted: false,
      api: opts.api,
      contentOpts: {api: opts.api, quote: e.item}
    })
  }

  this.cancelPayment = (e) => {
    e.preventDefault()
    if (window.confirm(this.ERRORS.CONFIRM_DELETE)) {
      opts.api.payments.cancel(e.item.id)
    }
  }

  this.stripeHandler = StripeCheckout.configure({
    key: 'pk_test_QGae73XobbImg3jsMj81tPRA',
    //image: '/img/documentation/checkout/marketplace.png',
    locale: 'auto',
    currency: 'gbp',
    token: (token) => {
      this.update({busy: true})
      this.opts.api.payments.pay(this.payment.id, token.id)
      // Use the token to create the charge with a server-side script.
      // You can access the token ID with `token.id`
    }
  });
  // Close Checkout on page navigation
  $(window).on('popstate', function() {
    this.stripeHandler.close();
  });

  this.payPayment = (e) => {
    e.preventDefault()
    if (this.currentAccount.paying) {
      this.update({busy: true})
      this.opts.api.payments.pay(e.item.id)
    } else {
      this.payment = e.item
      // Open Checkout with further options
      this.stripeHandler.open({
        //name: 'Stripe.com',
        //description: '2 widgets',
        amount: e.item.amount
      })
    }
  }

  this.addPayment = (payment) => {
    var quote = _.findWhere(this.quotes, {id: payment.quote_id})
    if (quote && !_.findWhere(quote.payments, {id: payment.id})) {
      quote.payments.push(payment)
    }
    this.update()
  }

  this.removePayment = (id) => {
    _.each(this.quotes, (quote) => {
      var _id = _.findIndex(quote.payments, p => p.id === id)
      if (_id > -1) quote.payments.splice(_id, 1)
    })
    this.update()
  }

  this.parsePaymentStatus = function () {
    return this.canceled_at ? 'canceled' : (this.paid_at ? 'paid' : (this.declined_at ? 'declined' : (this.refunded_at ? 'refunded' : (this.approved_at ? 'payable' : 'waiting'))))
  }

  this.parseQuoteStatus = function () {
    return this.accepted_at ? 'accepted' : (this.submitted_at ? 'submitted' :  'waiting')
  }

  this.mixin('projectTab')
  </script>
</r-project-quotes>
