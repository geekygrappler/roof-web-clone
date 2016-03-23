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
