import Pikaday from 'pikaday-time/pikaday'
<r-settings-notifications>
  <h2 class="mt0">Notifications</h2>
</r-settings-notifications>

<r-settings-account>
  <h2 class="mt0">Account</h2>
  <form name="form" class="sm-col-12 left-align" onsubmit="{submit}">
    <virtual  if="{needsLegalEntity()}">
      <h3>Legal Entity</h3>

      <label>Date of birth *</label>
      <div class="clearfix">
        <div class="sm-col sm-col-4">
          <input class="block col-12 mb2 field"
          type="text" name="stripe_account[updates][legal_entity][dob][day]"
          value="{record.stripe_account.object.legal_entity.dob.day}"
          placeholder="Day"/>
          <span if="{errors['stripe_account.updates.legal_entity.dob.day']}" class="inline-error">
          {errors['stripe_account.updates.legal_entity.dob.day']}
          </span>
        </div>

        <div class="sm-col sm-col-4">
          <input class="block col-12 mb2 field"
          type="text" name="stripe_account[updates][legal_entity][dob][month]"
          value="{record.stripe_account.object.legal_entity.dob.month}"
          placeholder="Month"/>
          <span if="{errors['stripe_account.updates.legal_entity.dob.month']}" class="inline-error">
          {errors['stripe_account.updates.legal_entity.dob.month']}
          </span>
        </div>

        <div class="sm-col sm-col-4">
          <input class="block col-12 mb2 field"
          type="text" name="stripe_account[updates][legal_entity][dob][year]"
          value="{record.stripe_account.object.legal_entity.dob.year}"
          placeholder="Year"/>
          <span if="{errors['stripe_account.updates.legal_entity.dob.year']}" class="inline-error">
          {errors['stripe_account.updates.legal_entity.dob.year']}
          </span>
        </div>
      </div>

      <label>Type *</label>
      <select class="block col-12 mb2 field"
      name="stripe_account[updates][legal_entity][type]" >
        <option></option>
        <option value="individual" selected="{this.dot.pick('legal_entity.type', record.stripe_account.object) == 'individual'}">Individual</option>
        <option value="company" selected="{this.dot.pick('legal_entity.type', record.stripe_account.object) == 'company'}">Company</option>
      </select>

      <label>First Name *</label>
      <input class="block col-12 mb2 field"
      type="text" name="stripe_account[updates][legal_entity][first_name]"
      value="{record.stripe_account.object.legal_entity.first_name}" />

      <label>Last Name *</label>
      <input class="block col-12 mb2 field"
      type="text" name="stripe_account[updates][legal_entity][last_name]"
      value="{record.stripe_account.object.legal_entity.last_name}" />
    </virtual>

    <virtual if="{needsBankAccount()}">
      <h3>Bank Account</h3>

      <input type="hidden" name="stripe_account[updates][external_account][object]" value="bank_account" />
      <input type="hidden" name="stripe_account[updates][external_account][country]" value="GB" />
      <input type="hidden" name="stripe_account[updates][external_account][currency]" value="gbp" />

      <label>Account Number *</label>
      <input class="block col-12 mb2 field"
      type="text" name="stripe_account[updates][external_account][account_number]"
      value="{record.stripe_account.object.external_account.account_number}" />

      <label>Sort Code *</label>
      <input class="block col-12 mb2 field"
      type="text" name="stripe_account[updates][external_account][routing_number]"
      value="{record.stripe_account.object.external_account.routing_number}" />

      <label>Account Holder Name</label>
      <input class="block col-12 mb2 field"
      type="text" name="stripe_account[updates][external_account][account_holder_name]"
      value="{record.stripe_account.object.external_account.account_holder_name}" />

      <label>Account Holder Type</label>
      <select class="block col-12 mb2 field"
      name="stripe_account[updates][external_account][account_holder_type]" >
        <option></option>
        <option value="individual" selected="{this.dot.pick('external_account.account_holder_type', record.stripe_account.object) == 'individual'}">Individual</option>
        <option value="company" selected="{this.dot.pick('external_account.account_holder_type', record.stripe_account.object) == 'company'}">Company</option>
      </select>
    </virtual>

    <virtual if="{needsIdDocument()}">
      <label>Clear photo or scan of your ID *</label>
      <input type="file" name="stripe_account[updates][legal_entity][verification][document]" />
    </virtual>

    <div if="{!_.isEmpty(errors)}" id="error_explanation">
      <ul>
        <li each="{field, messages in errors}">{field.humanize()} {messages.join(', ')}</li>
      </ul>
    </div>

    <button type="submit" class="block col-12 mb2 btn btn-big btn-primary {busy: busy}">Save</button>
  </form>

  <script>
  this.needsLegalEntity = () => {
    return !_.isEmpty(
      _.filter(
        this.dot.pick('verification.fields_needed', this.record.stripe_account.object),
        er => er.indexOf('legal_entity') > -1
      )
    )
  }
  this.needsBankAccount = () => {
    return !_.isEmpty(this.dot.pick('verification.fields_needed.bank', this.record.stripe_account.object))
  }
  this.needsIdDocument = () => {
    return !_.isEmpty(this.dot.pick('verification.fields_needed.document', this.record.stripe_account.object))
  }
  this.on('mount', () => {
    opts.api.professionals.on('show.success',this.show)
    opts.api.professionals.on('show.fail',this.errorHandler)
    opts.api.professionals.on('update.success',this.updateReset)
    opts.api.professionals.on('update.fail',this.errorHandler)
    opts.api.professionals.show(this.currentAccount.user_id)
  })
  this.on('unmount', () => {
    opts.api.professionals.off('show.success',this.update)
    opts.api.professionals.off('show.fail',this.errorHandler)
    opts.api.professionals.off('update.success',this.updateReset)
    opts.api.professionals.off('update.fail',this.errorHandler)
  })
  this.show = (record) => {
    this.update({record: record})
  }
  this.submit = (e) => {

    e.preventDefault()

    let data = this.serializeForm(e.target, {})

    if (_.isEmpty(data)) {
      $(e.target).animateCss('shake')
      return
    }

    this.update({busy: true, errors: null})

    this.opts.api.professionals.update(this.currentAccount.user_id, data)
  }

  </script>
</r-settings-account>

<r-settings-profile>
  <h2 class="mt0">Profile</h2>
    <form name="{currentAccount.user_type.plural()}" class="sm-col-12 left-align" onsubmit="{submit}">

      <div class="clearfix mxn2">
        <div class="col col-6 px2">
          <label for="profile[first_name]">First Name *</label>
          <input class="block col-12 mb2 field" autofocus="true"
          type="text" name="profile[first_name]" value="{currentAccount.profile.first_name}"/>
          <span if="{errors['profile.first_name']}" class="inline-error">{errors['profile.first_name']}</span>
        </div>
        <div class="col col-6 px2">
          <label for="profile[last_name]">Last Name *</label>
          <input class="block col-12 mb2 field"
          type="text" name="profile[last_name]" value="{currentAccount.profile.last_name}"/>
          <span if="{errors['profile.last_name']}" class="inline-error">{errors['profile.last_name']}</span>
        </div>
      </div>

      <label for="profile[phone_number]">Phone Number *</label>
      <input class="block col-12 mb2 field"
      type="tel" name="profile[phone_number]" value="{currentAccount.profile.phone_number}"/>
      <span if="{errors['profile.phone_number']}" class="inline-error">{errors['profile.phone_number']}</span>

      <div if="{currentAccount.isProfessional}">
        <label for="profile[info]">Info</label>
        <textarea class="block col-12 mb2 field"
        name="profile[info]" value="{currentAccount.profile.info}"></textarea>
        <span if="{errors['profile.info']}" class="inline-error">{errors['profile.info']}</span>

        <label for="profile[dob]">Date of birth</label>
        <input class="block col-12 mb2 field"
        type="text" name="profile[dob]" value="{currentAccount.profile.dob}"/>
        <span if="{errors['profile.dob']}" class="inline-error">{errors['profile.dob']}</span>

        <div each="{field, i in proFields}">
          <label for="profile[{field}]">{field.humanize()}</label>
          <input class="block col-12 mb2 field"
          type="text" name="profile[{field}]" value="{currentAccount.profile[field]}"/>
          <span if="{errors['profile.' + field]}" class="inline-error">{errors['profile.'+field]}</span>
        </div>
      </div>

      <button type="submit" class="block col-12 mb2 btn btn-big btn-primary {busy: busy}">Save</button>
    </form>

    <form name="registrations" class="sm-col-12 left-align" onsubmit="{submit}">
      <label for="email">Email *</label>
      <input class="block col-12 mb2 field"
      type="text" name="email" value="{currentAccount.email}"/>
      <span if="{errors['email']}" class="inline-error">{errors['email']}</span>

      <label for="password">Password</label>
      <em class="h5">(8 characters minimum, leave empty if you don't want to change it)</em>
      <input class="block col-12 mb2 field" autocomplete="off"
      type="password" name="password" />
      <span if="{errors['password']}" class="inline-error">{errors['password']}</span>

      <label for="password">Current Password *</label>
      <em class="h5">(8 characters minimum)</em>
      <input class="block col-12 mb2 field" autocomplete="off"
      type="password" name="current_password" />
      <span if="{errors['current_password']}" class="inline-error">{errors['current_password']}</span>

    <button type="submit" class="block col-12 mb2 btn btn-big btn-primary {busy: busy}">Save</button>

    </form>
  <script>
  this.submit = (e) => {

    e.preventDefault()

    let data = this.serializeForm(e.target)

    if (_.isEmpty(data)) {
      $(e.target).animateCss('shake')
      return
    }

    this.update({busy: true, errors: null})

    this.opts.api[e.target.name].update(this.currentAccount.user_id, data)
    .fail(this.errorHandler)
    .then(id => {
      this.update({busy:false})
    })
  }
  this.proFields = [
    'website',
    'company_name', 'company_info', 'company_registration_number',
    'company_vat_number',
    'insurance_number',
    'insurance_amount',
    'guarantee_duration'
  ]
  if(this.currentAccount.isProfessional) {
    this.on('mount', () => {
      let picker = new Pikaday({
        showTime: false,
        field: this['profile[dob]'],
        onSelect:  (date) => {
          this.currentAccount.profile.dob = picker.toString()
          this.update()
        }
      })
    })
  }
  </script>
</r-settings-profile>


<r-settings>
  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>
  <div class="container">
    <div class="py3 px2">
      <div class="clearfix mxn2">

        <r-subnav links="{subnavLinks}" tab="{opts.tab}" ></r-subnav>
        <div class="sm-col sm-col-9 sm-px2">
            <r-tabs tab="{opts.tab}" api="{opts.api}" content_opts="{opts.contentOpts}"></r-tabs>
        </div>

      </div>
    </div>
  </div>
  <script>
  this.subnavLinks = [
    {href: `/app/settings/profile`, name: 'profile', tag: 'r-settings-profile'},
    {href: `/app/settings/notifications`, name: 'notifications', tag: 'r-settings-notifications'}
  ]
  if(this.currentAccount.isProfessional) {
    this.subnavLinks = [
      {href: `/app/settings/profile`, name: 'profile', tag: 'r-settings-profile'},
      {href: `/app/settings/notifications`, name: 'notifications', tag: 'r-settings-notifications'},
      {href: `/app/settings/account`, name: 'account', tag: 'r-settings-account'}
    ]
  }
  </script>
</r-settings>
