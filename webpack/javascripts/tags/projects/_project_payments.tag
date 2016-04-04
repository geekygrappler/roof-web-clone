<r-project-payments>
  <div class="overflow-scroll">
  <table class="table-light">
    <thead>
      <tr>
        <th>Amount</th> <th>Due Date</th> <th>Status</th> <th></th>
      </tr>
    </thead>
    <tbody>
      <tr each="{payments}" class="{'bg-yellow': id == parent.opts.payment_id}">
        <td>{formatCurrency(amount)}</td>
        <td>{formatTime(due_date)}</td>
        <td>{status}</td>
        <td>
          <a if="{currentAccount.isAdministrator && (status == 'waiting')}"
          class="btn btn-small bg-red white h6" href="/app/admin/payments/{id}/edit" target="_blank">Edit</a>
          <a if="{currentAccount.isProfessional && (status == 'payable' || status == 'waiting')}"
          class="btn btn-small bg-red white h6 {busy: busy}" onclick="{cancelPayment}">Cancel</a>
          <button if="{currentAccount.isCustomer && status == 'payable'}"
          class="btn btn-small bg-green white h6 {busy: busy}" disabled="{busy}" onclick="{payPayment}">Pay</button>
        </td>
      </tr>
    </tbody>
  </table>

  <table if="{payments.length > 0}" class="table-light mt2">
    <thead>
      <tr>
        <th>Paid</th>
        <th if="{quote.refunded_amount > 0}">Refunded</th>
        <th if="{quote.declined_amount > 0}">Declined</th>
        <th if="{currentAccount.isProfessional}">Approved</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>{formatCurrency(quote.paid_amount)}</th>
        <td if="{refunded_amount > 0}">{formatCurrency(quote.refunded_amount)}</td>
        <td if="{declined_amount > 0}">{formatCurrency(quote.declined_amount)}</td>
        <td if="{currentAccount.isProfessional}">{formatCurrency(quote.approved_amount)}</td>
      </tr>
    </tbody>
  </table>

  <div if="{currentAccount.isProfessional}" class="clearfix overflow-hidden p1 bg-yellow">
    <div class="mt1">
      <a class="btn btn-small bg-darken-2" onclick="{openPaymentForm}">Add Payment</a>
    </div>
  </div>
  </div>

  <script>

  this.on('mount', () => {


    opts.api.payments.on('create.success', this.addPayment)
    opts.api.payments.on('cancel.success', this.removePayment)
    opts.api.payments.on('cancel.fail', this.errorHandler)
    opts.api.payments.on('pay.success', this.reload)
    opts.api.payments.on('pay.fail', this.errorHandler)

  })

  this.on('unmount', () => {


    opts.api.payments.off('create.success', this.addPayment)
    opts.api.payments.off('cancel.success', this.removePayment)
    opts.api.payments.off('cancel.fail', this.errorHandler)
    opts.api.payments.off('pay.success', this.reload)
    opts.api.payments.off('pay.fail', this.errorHandler)
  })

  this.on('before-mount', () => {
    if(this.opts.quote_id) {
      // this.quote = this.opts.quote
      this.opts.api.quotes.show(this.opts.quote_id).then(quote => this.update({quote}))
      this.loadResources('payments', {quote_id: this.opts.quote_id})

    } else {
      this.quote = this.opts.quote
      this.loadResources('payments', {quote_id: this.quote.id})
    }
  })

  this.reload = () => {
    this.update({busy: false})
    this.opts.api.quotes.index({project_id: opts.id})
  }

  this.openPaymentForm = (e) => {
    e.preventDefault()
    riot.mount('r-modal', {
      content: 'r-payment-form',
      persisted: false,
      api: opts.api,
      contentOpts: {api: opts.api, quote: this.quote}
    })
  }

  this.cancelPayment = (e) => {
    e.preventDefault()
    if (window.confirm(this.ERRORS.CONFIRM_DELETE)) {
      opts.api.payments.cancel(e.item.id)
    }
  }

  this.payPayment = (e) => {
    e.preventDefault()
    if (this.currentAccount.paying) {
      this.update({busy: true})
      this.opts.api.payments.pay(e.item.id)
    } else {
      this.payment = e.item

      // load Stripe if not loaded
      if (typeof window.StripeCheckout !== 'undefined' || window.StripeCheckout != null) {
        // Open Checkout with further options
        this.stripeHandler.open({
          //name: 'Stripe.com',
          //description: '2 widgets',
          amount: e.item.amount
        })
      } else {
        this.update({busy: true})
        $.getScript('https://checkout.stripe.com/checkout.js')
        .then(() => {

          this.stripeHandler = StripeCheckout.configure({
            key: $('meta[name=stripe-key]').attr('content'),
            //image: '/img/documentation/checkout/marketplace.png',
            locale: 'auto',
            currency: 'gbp',
            token: (token) => {
              this.update({busy: true})
              this.opts.api.payments.pay(this.payment.id, token.id)
              // Use the token to create the charge with a server-side script.
              // You can access the token ID with `token.id`
            },
            closed: () => {
              this.update({busy: false})
            }
          });

          // Close Checkout on page navigation
          $(window).on('popstate', function() {
            this.stripeHandler.close();
            this.update({busy: false})
          });

          // Open Checkout with further options
          this.stripeHandler.open({
            //name: 'Stripe.com',
            //description: '2 widgets',
            amount: e.item.amount
          })


        })
      }
    }
  }

  this.addPayment = (payment) => {
    if (!_.findWhere(this.payments, {id: payment.id})) {
      this.payments.push(payment)
    }
    this.update()
  }

  this.removePayment = (id) => {
    var _id = _.findIndex(this.payments, p => p.id === id)
    if (_id > -1) this.payments.splice(_id, 1)
    this.update()
  }

  </script>
</r-project-payments>
