import Pikaday from 'pikaday-time/pikaday'
<r-admin-payment-form>

  <h2 class="center mt0 mb2">{ opts.resource.humanize() }</h2>

  <form name="form" class="sm-col-12 left-align" onsubmit="{ submit }" >


    <label for="project_id">Project</label>
    <select name="project_id" class="block col-12 mb2 field" onchange="{loadProfessionals}">
      <option></option>
      <option each="{projects}" value="{id}" selected="{record.project_id == id}">#{id} | {name}</option>
    </select>
    <span if="{errors.project_id}" class="inline-error">{errors.project_id}</span>

    <label for="professional_id">Professional</label>
    <select name="professional_id" class="block col-12 mb2 field" onchange="{loadQuotes}">
      <option></option>
      <option each="{professionals}" value="{id}" selected="{record.professional_id == id}">#{id} | {profile.first_name} {profile.last_name}</option>
    </select>
    <span if="{errors.professional_id}" class="inline-error">{errors.professional_id}</span>

    <label for="quote_id">Quote</label>
    <select name="quote_id" class="block col-12 mb2 field" onchange="{setQuote}">
      <option></option>
      <option each="{quotes}" value="{id}" selected="{record.quote_id == id}">#{id} | {total_amount}</option>
    </select>
    <span if="{errors.quote_id}" class="inline-error">{errors.quote_id}</span>


    <div each="{attr, i in ['fee', 'amount']}">
      <label for="{resource.singular()}[{attr}]">{attr.humanize()}</label>

      <input  class="block col-12 mb2 field"
      type="number" name="{attr}" value="{parseInt(record[attr]) * 0.01}"/>
      <span if="{errors[attr]}" class="inline-error">{errors[attr]}</span>
    </div>

    <div each="{attr, i in ['due_date', 'description']}">
      <label for="{resource.singular()}[{attr}]">{attr.humanize()}</label>

      <input  class="block col-12 mb2 field"
      type="text" name="{attr}" value="{record[attr]}"/>
      <span if="{errors[attr]}" class="inline-error">{errors[attr]}</span>
    </div>

    <div if="{!_.isEmpty(errors)}" id="error_explanation">
      <ul>
        <li each="{field, messages in errors}">{field.humanize()} {messages.join(', ')}</li>
      </ul>
    </div>

    <div class="right-align">
    <button type="submit" class="mb2 btn btn-big btn-primary {busy: busy}">Save</button>
    <a if="{record.id && !record.approved_at}" onclick="{approve}" class="mb2 btn btn-big bg-green white {busy: busy}">Approve</a>
    <a if="{record.id && record.paid_at && !record.refunded_at}" onclick="{refund}" class="mb2 btn btn-big bg-red white {busy: busy}">Refund</a>
    </div>

  </form>

  <script>
  this.approve = (e) => {
    e.preventDefault()

    let data = this.serializeForm(this.form)

    this.update({busy: true, errors: null})
    this.opts.api[opts.resource].approve(opts.id, data)
    .fail(this.errorHandler)
    .then(this.updateReset)
  }

  this.refund = (e) => {
    e.preventDefault()

    this.update({busy: true, errors: null})
    this.opts.api[opts.resource].refund(opts.id)
    .fail(this.errorHandler)
    .then(this.updateReset)

  }

  this.loadResources('projects')

  this.updateRecord = (record) => {
    this.update({record: record, attributes: _.keys(record)})
    if (this.opts.id) {
      this.loadProfessionals({target: {value: record.project_id}})
      this.loadQuotes({target: {value: record.professional_id}})
    }
  }

  this.loadProfessionals = (e) => {
    this.record.project_id = parseInt(e.target.value)
    this.professionals = _.findWhere(this.projects, {id: this.record.project_id}).professionals
  }
  this.loadQuotes = (e) => {
    this.record.professional_id = parseInt(e.target.value)
    this.loadResources('quotes', {professional_id: this.record.professional_id})
  }
  this.setQuote = (e) => {
    this.record.quote_id = parseInt(e.target.value)
  }
  this.on('mount', () => {
    let picker = new Pikaday({
      showTime: false,
      field: this.due_date,
      onSelect:  (date) => {
        this.record.due_date = picker.toString()
        //this.update()
      }
    })
  })
  this.mixin('adminForm')
  </script>

</r-admin-payment-form>
