import Pikaday from 'pikaday-time/pikaday'
<r-admin-payment-form>

  <h2 class="center mt0 mb2">{ opts.resource.humanize() }</h2>

  <form name="form" class="sm-col-12 left-align" onsubmit="{ submit }" >


    <label for="project_id">Project</label>

    <input type="hidden" name="project_id" value="{record.project_id}">
    <r-typeahead-input resource="projects" api="{ opts.api }" id="{record.project_id}" datum_tokenizer="{['name', 'account_email']}"></r-typeahead-input>
    <span if="{errors.project_id}" class="inline-error">{errors.project_id}</span>

    <label for="professional_id">Professional</label>
    <input type="hidden" name="professional_id" value="{record.professional_id}">
    <r-typeahead-input resource="professionals" api="{ opts.api }" id="{record.professional_id}" filters="{professionalFilters()}" datum_tokenizer="{['full_name']}"></r-typeahead-input>
    <span if="{errors.professional_id}" class="inline-error">{errors.professional_id}</span>

    <label for="quote_id">Quote</label>
    <input type="hidden" name="quote_id" value="{record.quote_id}">
    <r-typeahead-input resource="quotes" api="{ opts.api }" id="{record.quote_id}" filters="{quoteFilters()}" datum_tokenizer="{['id', 'status', 'amount']}"></r-typeahead-input>
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

  this.updateRecord = (record) => {
    this.update({record: record, attributes: _.keys(record)})
  }

  this.tags['r-typeahead-input'][0].on('itemselected', (item) => {
    this.record.project_id = item.id
    this.update()
  })
  this.tags['r-typeahead-input'][1].on('itemselected', (item) => {
    this.record.professional_id = item.id
    this.update()
  })
  this.tags['r-typeahead-input'][2].on('itemselected', (item) => {
    this.record.quote_id = item.id
    this.update()
  })
  this.quoteFilters = () => {
    return [{name: 'project_id', value: this.record.project_id},{name: 'professional_id', value: this.record.professional_id}]
  }
  this.professionalFilters = () => {
    return [{name: 'project_id', value: this.record.project_id}]
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
