import Pikaday from 'pikaday-time/pikaday'

<r-settings-notifications>
  <h2 class="mt0">Notifications</h2>
</r-settings-notifications>

<r-settings-account>
  <h2 class="mt0">Account</h2>

  <p class="bg-green white p1" if="{fieldsComplete()}">
    Congrats! Your account is verified and you can receive your payments.
  </p>

  <form if="{record}" name="form" class="sm-col-12 left-align" onsubmit="{submit}">

    <virtual if="{fieldsNeeded('business_logo')}">
      <label>Business Logo</label>
      <input class="block col-12 mb2 field" type="text"
      value="{record.stripe_account.object.business_logo}" name="stripe_account[updates][business_logo]">
    </virtual>

    <virtual if="{fieldsNeeded('business_name')}">
      <label>Business Name</label>
      <input class="block col-12 mb2 field" type="text"
      value="{record.stripe_account.object.business_name}" name="stripe_account[updates][business_name]">
    </virtual>

    <virtual if="{fieldsNeeded('business_primary_color')}">
      <label>Business Primary Color</label>
      <input class="block col-12 mb2 field" type="text"
      value="{record.stripe_account.object.business_primary_color}" name="stripe_account[updates][business_primary_color]">
    </virtual>

    <virtual if="{fieldsNeeded('business_url')}">
      <label>Business URL</label>
      <input class="block col-12 mb2 field" type="text"
      value="{record.stripe_account.object.business_url}" name="stripe_account[updates][business_url]">
    </virtual>

    <virtual if="{fieldsNeeded('debit_negative_balances')}">
      <label>Debit Negative Balances</label>
      <input class="block col-12 mb2 field" type="text"
      value="{record.stripe_account.object.debit_negative_balances}" name="stripe_account[updates][debit_negative_balances]">
    </virtual>

    <virtual if="{fieldsNeeded('default_currency')}">
      <label>Default Currency</label>
      <input class="block col-12 mb2 field" type="text"
      value="{record.stripe_account.object.default_currency}" name="stripe_account[updates][default_currency]">
    </virtual>

    <virtual if="{fieldsNeeded('email')}">
      <label>Email</label>
      <input class="block col-12 mb2 field" type="text"
      value="{record.stripe_account.object.email}" name="stripe_account[updates][email]">
    </virtual>

    <fieldset if="{fieldsNeeded('decline_charge_on')}">
      <legend>Decline Charge On</legend>

      <label>Avs Failure</label>
      <input class="block col-12 mb2 field" type="text"
      value="{record.stripe_account.object.decline_charge_on.avs_failure}" name="stripe_account[updates][decline_charge_on][avs_failure]">

      <label>Avs Failure</label>
      <input class="block col-12 mb2 field" type="text"
      value="{record.stripe_account.object.decline_charge_on.cvc_failure}" name="stripe_account[updates][decline_charge_on][cvc_failure]">
    </fieldset>


    <fieldset class="mb2 p1 border">
      <legend><h3>Bank Account</h3></legend>

      <p if="{record.stripe_account.object.external_accounts.total_count > 0}" class="bg-orange white p1">
        You have already registered your bank account with us. You can change the details
        but this will trigger verification process again.
        <br>
        <a class="btn btn-primary" onclick="{letBankAccountChange}">OK, got it. Let me change my account details</a>
      </p>

      <virtual if="{bankAccountWillChange || fieldsNeeded('bank')}">
        <label class="display-none">Object</label>
        <input class="block col-12 mb2 field" type="hidden"
        value="bank_account"
        name="stripe_account[updates][external_account][object]">

        <label>Account Number *</label>
        <input class="block col-12 mb2 field" type="text"
        name="stripe_account[updates][external_account][account_number]">

        <label>Country *</label>
        <input class="block col-12 mb2 field" type="text"
        value="GB"
        name="stripe_account[updates][external_account][country]">

        <label>Currency *</label>
        <input class="block col-12 mb2 field" type="text"
        value="gbp"
        name="stripe_account[updates][external_account][currency]">

        <label>Account Holder Name *</label>
        <input class="block col-12 mb2 field" type="text"
        name="stripe_account[updates][external_account][account_holder_name]">

        <label>Account Holder Type *</label>
        <select class="block col-12 mb2 field"
        name="stripe_account[updates][external_account][account_holder_type]">
          <option></option>
          <option value="individual">Individual</option>
          <option value="company">Company</option>
        </select>

        <label>Account Sort Code *</label>
        <input class="block col-12 mb2 field" type="text"
        name="stripe_account[updates][external_account][routing_number]">

        <a if="{!fieldsNeeded('bank')}" class="btn btn-primary" onclick="{cancelBankAccountChange}">Cancel</a>
      </virtual>
    </fieldset>

    <fieldset class="mb2 p1 border" if="{fieldsNeeded('legal_entity')}">
      <legend><h3>Legal Entity</h3></legend>

      <virtual if="{fieldsNeeded('legal_entity.type')}">
        <label>Type *</label>
        <select class="block col-12 mb2 field"
        name="stripe_account[updates][legal_entity][type]">
          <option></option>
          <option value="individual" selected="{record.stripe_account.object.legal_entity.type === 'individual'}">Individual</option>
          <option value="company" selected="{record.stripe_account.object.legal_entity.type === 'company'}">Company</option>
        </select>
      </virtual>

      <virtual if="{fieldsNeeded('legal_entity.first_name')}">
        <label>First Name *</label>
        <input class="block col-12 mb2 field" type="text"
        value="{record.stripe_account.object.legal_entity.first_name}"
        name="stripe_account[updates][legal_entity][first_name]">
      </virtual>

      <virtual if="{fieldsNeeded('legal_entity.last_name')}">
        <label>Last Name *</label>
        <input class="block col-12 mb2 field" type="text"
        value="{record.stripe_account.object.legal_entity.last_name}"
        name="stripe_account[updates][legal_entity][last_name]">
      </virtual>

      <virtual if="{fieldsNeeded('legal_entity.gender')}">
        <label>Gender</label>
        <input class="block col-12 mb2 field" type="text"
        value="{record.stripe_account.object.legal_entity.gender}"
        name="stripe_account[updates][legal_entity][gender]">
      </virtual>

      <virtual if="{fieldsNeeded('legal_entity.maiden_name')}">
        <label>Maiden Name</label>
        <input class="block col-12 mb2 field" type="text"
        value="{record.stripe_account.object.legal_entity.maiden_name}"
        name="stripe_account[updates][legal_entity][maiden_name]">
      </virtual>

      <virtual if="{fieldsNeeded('legal_entity.dob')}">
        <label>Date of Birth</label>
        <div class="clearfix mxn1">
          <div class="sm-col sm-col-4 px1">
            <label>Day *</label>
            <input class="block col-12 mb2 field" type="text"
            value="{record.stripe_account.object.legal_entity.dob.day}"
            name="stripe_account[updates][legal_entity][dob][day]">
          </div>
          <div class="sm-col sm-col-4 px1">
            <label>Month *</label>
            <input class="block col-12 mb2 field" type="text"
            value="{record.stripe_account.object.legal_entity.dob.month}"
            name="stripe_account[updates][legal_entity][dob][month]">
          </div>
          <div class="sm-col sm-col-4 px1">
            <label>Year *</label>
            <input class="block col-12 mb2 field" type="text"
            value="{record.stripe_account.object.legal_entity.dob.year}"
            name="stripe_account[updates][legal_entity][dob][year]">
          </div>
        </div>
      </virtual>

      <virtual if="{fieldsNeeded('legal_entity.phone_number')}">
        <label>Phone Number *</label>
        <input class="block col-12 mb2 field" type="text"
        value="{record.stripe_account.object.legal_entity.phone_number}"
        name="stripe_account[updates][legal_entity][phone_number]">
      </virtual>

      <virtual if="{fieldsNeeded('legal_entity.personal_id_number')}">
        <label>Personal ID Number *</label>
        <input class="block col-12 mb2 field" type="text"
        value="{record.stripe_account.object.legal_entity.personal_id_number}"
        name="stripe_account[updates][legal_entity][personal_id_number]">
      </virtual>

      <virtual if="{fieldsNeeded('legal_entity.business_name')}">
        <label>Business Name</label>
        <input class="block col-12 mb2 field" type="text"
        value="{record.stripe_account.object.legal_entity.business_name}"
        name="stripe_account[updates][legal_entity][business_name]">
      </virtual>

      <virtual if="{fieldsNeeded('legal_entity.business_tax_id')}">
        <label>Business Tax ID</label>
        <input class="block col-12 mb2 field" type="text"
        value="{record.stripe_account.object.legal_entity.business_tax_id}"
        name="stripe_account[updates][legal_entity][business_tax_id]">
      </virtual>

      <virtual if="{fieldsNeeded('legal_entity.business_vat_id')}">
        <label>Business VAT ID</label>
        <input class="block col-12 mb2 field" type="text"
        value="{record.stripe_account.object.legal_entity.business_vat_id}"
        name="stripe_account[updates][legal_entity][business_vat_id]">
      </virtual>

      <fieldset class="mb2 p1 border" if="{fieldsNeeded('legal_entity.address')}">
        <legend><h4>Address</h4></legend>

        <label>Line1 *</label>
        <input class="block col-12 mb2 field" type="text"
        value="{record.stripe_account.object.legal_entity.address.line1}"
        name="stripe_account[updates][legal_entity][address][line1]">

        <label>Line2</label>
        <input class="block col-12 mb2 field" type="text"
        value="{record.stripe_account.object.legal_entity.address.line2}"
        name="stripe_account[updates][legal_entity][address][line2]">

        <div class="clearfix mxn1">
          <div class="sm-col sm-col-3 px1">
            <label>City *</label>
            <input class="block col-12 mb2 field" type="text"
            value="{record.stripe_account.object.legal_entity.address.city}"
            name="stripe_account[updates][legal_entity][address][city]">
          </div>
          <div class="sm-col sm-col-3 px1">
            <label>Country *</label>
            <input class="block col-12 mb2 field" type="text"
            value="{record.stripe_account.object.legal_entity.address.country}"
            name="stripe_account[updates][legal_entity][address][country]">
          </div>
          <div class="sm-col sm-col-3 px1">
            <label>Postcode *</label>
            <input class="block col-12 mb2 field" type="text"
            value="{record.stripe_account.object.legal_entity.address.postal_code}"
            name="stripe_account[updates][legal_entity][address][postal_code]">
          </div>
          <div class="sm-col sm-col-3 px1">
            <label>State *</label>
            <input class="block col-12 mb2 field" type="text"
            value="{record.stripe_account.object.legal_entity.address.state}"
            name="stripe_account[updates][legal_entity][address][state]">
          </div>
        </div>
      </fieldset>

      <fieldset class="mb2 p1 border" if="{fieldsNeeded('legal_entity.personal_address')}">
        <legend><h4>Personal Address</h4></legend>

        <label>Line1 *</label>
        <input class="block col-12 mb2 field" type="text"
        value="{record.stripe_account.object.legal_entity.personal_address.line1}"
        name="stripe_account[updates][legal_entity][personal_address][line1]">

        <label>Line2</label>
        <input class="block col-12 mb2 field" type="text"
        value="{record.stripe_account.object.legal_entity.personal_address.line2}"
        name="stripe_account[updates][legal_entity][personal_address][line2]">

        <div class="clearfix mxn1">
          <div class="sm-col sm-col-3 px1">
            <label>City *</label>
            <input class="block col-12 mb2 field" type="text"
            value="{record.stripe_account.object.legal_entity.personal_address.city}"
            name="stripe_account[updates][legal_entity][personal_address][city]">
          </div>
          <div class="sm-col sm-col-3 px1">
            <label>Country *</label>
            <input class="block col-12 mb2 field" type="text"
            value="{record.stripe_account.object.legal_entity.personal_address.country}"
            name="stripe_account[updates][legal_entity][personal_address][country]">
          </div>
          <div class="sm-col sm-col-3 px1">
            <label>Postcode *</label>
            <input class="block col-12 mb2 field" type="text"
            value="{record.stripe_account.object.legal_entity.personal_address.postal_code}"
            name="stripe_account[updates][legal_entity][personal_address][postal_code]">
          </div>
          <div class="sm-col sm-col-3 px1">
            <label>State *</label>
            <input class="block col-12 mb2 field" type="text"
            value="{record.stripe_account.object.legal_entity.personal_address.state}"
            name="stripe_account[updates][legal_entity][personal_address][state]">
          </div>
        </div>
      </fieldset>

      <fieldset class="mb2 p1 border" if="{fieldsNeeded('legal_entity.additional_owners')}">
        <legend><h4>Additional Owners</h4></legend>

        <ol>
          <li each="{owner, index in record.stripe_account.object.legal_entity.additional_owners}" class="p1 border">

            <virtual if="{fieldsNeeded('legal_entity.additional_owners.' + index + '.first_name')}">
              <label>First Name *</label>
              <input class="block col-12 mb2 field" type="text"
              value="{owner.first_name}"
              name="stripe_account[updates][legal_entity][additional_owners][{index}][first_name]">
            </virtual>

            <virtual if="{fieldsNeeded('legal_entity.additional_owners.' + index + '.last_name')}">
              <label>Last Name *</label>
              <input class="block col-12 mb2 field" type="text"
              value="{owner.last_name}"
              name="stripe_account[updates][legal_entity][additional_owners][{index}][last_name]">
            </virtual>

            <virtual if="{fieldsNeeded('legal_entity.additional_owners.' + index + '.dob')}">
              <label>Date of Birth</label>
              <div class="clearfix mxn1">
                <div class="sm-col sm-col-4 px1">
                  <label>Day *</label>
                  <input class="block col-12 mb2 field" type="text"
                  value="{owner.dob.day}"
                  name="stripe_account[updates][legal_entity][additional_owners][{index}][dob][day]">
                </div>
                <div class="sm-col sm-col-4 px1">
                  <label>Month *</label>
                  <input class="block col-12 mb2 field" type="text"
                  value="{owner.dob.month}"
                  name="stripe_account[updates][legal_entity][additional_owners][{index}][dob][month]">
                </div>
                <div class="sm-col sm-col-4 px1">
                  <label>Year *</label>
                  <input class="block col-12 mb2 field" type="text"
                  value="{owner.dob.year}"
                  name="stripe_account[updates][legal_entity][additional_owners][{index}][dob][year]">
                </div>
              </div>
            </virtual>

            <fieldset class="mb2 p1 border" if="{fieldsNeeded('legal_entity.additional_owners.' + index + '.address')}">
              <legend><h5>Address</h5></legend>

              <label>Line1 *</label>
              <input class="block col-12 mb2 field" type="text"
              value="{owner.address.line1}"
              name="stripe_account[updates][legal_entity][additional_owners][{index}][address][line1]">

              <label>Line2</label>
              <input class="block col-12 mb2 field" type="text"
              value="{owner.address.line2}"
              name="stripe_account[updates][legal_entity][additional_owners][{index}][address][line2]">

              <div class="clearfix mxn1">
                <div class="sm-col sm-col-3 px1">
                  <label>City *</label>
                  <input class="block col-12 mb2 field" type="text"
                  value="{owner.address.city}"
                  name="stripe_account[updates][legal_entity][additional_owners][{index}][address][city]">
                </div>
                <div class="sm-col sm-col-3 px1">
                  <label>Country *</label>
                  <input class="block col-12 mb2 field" type="text"
                  value="{owner.address.country}"
                  name="stripe_account[updates][legal_entity][additional_owners][{index}][address][country]">
                </div>
                <div class="sm-col sm-col-3 px1">
                  <label>Postcode *</label>
                  <input class="block col-12 mb2 field" type="text"
                  value="{owner.address.postal_code}"
                  name="stripe_account[updates][legal_entity][additional_owners][{index}][address][postal_code]">
                </div>
                <div class="sm-col sm-col-3 px1">
                  <label>State *</label>
                  <input class="block col-12 mb2 field" type="text"
                  value="{owner.address.state}"
                  name="stripe_account[updates][legal_entity][additional_owners][{index}][address][state]">
                </div>
              </div>
            </fieldset>

            <virtual if="{fieldsNeeded('legal_entity.additional_owners.' + index + '.verification.document')}">
              <label>Verification Document *</label>
              <input class="block col-12 p1 mb2 field" type="file"
              data-additional-owners-file-index="{index}"
              name="professional[stripe_account][updates][legal_entity][additional_owners][{index}][identity_document]">
            </virtual>

            <a class="btn btn-small btn-primary" onclick="{removeAdditionalOwner}">Remove Additional Owner</a>
          </li>
        </ol>

        <a class="btn btn-small btn-primary mb2" onclick="{addAdditionalOwner}">Add Additional Owner</a>
      </fieldset>

    </fieldset>

    <virtual if="{fieldsNeeded('legal_entity.verification.document')}">
      <label>Verification Document *</label>
      <input class="block col-12 p1 mb2 field" type="file"
      id="stripe_account_updates_legal_entity_identity_document"
      name="professional[stripe_account][updates][legal_entity][identity_document]">
    </virtual>

    <div if="{!_.isEmpty(errors)}" id="error_explanation">
      <ul>
        <li each="{field, messages in errors}">{field.humanize()} {messages.join(', ')}</li>
      </ul>
    </div>

    <button type="submit" class="block col-12 mb2 btn btn-big btn-primary {busy: busy}">Save</button>
  </form>

  <script>
  this.fieldsComplete = () => {
    return _.isEmpty(this.record.stripe_account.object.verification.fields_needed)
  }
  this.fieldsNeeded = (key) => {
    var needed = false
    needed = !_.isEmpty(_.filter(
      this.dot.pick('verification.fields_needed', this.record.stripe_account.object),
      er => er.startsWith(key)
    ))
    if (
      key.includes('additional_owners.') &&
      !_.isEmpty(_.filter(
        this.dot.pick('verification.fields_needed', this.record.stripe_account.object),
        er => er === 'additional_owners'
      ))
    ) {
      needed = true
    }
    return needed
  }
  this.letBankAccountChange = (e) => {
    e.preventDefault()
    this.update({bankAccountWillChange: true})
  }
  this.cancelBankAccountChange = (e) => {
    e.preventDefault()
    this.update({bankAccountWillChange: false})
  }
  this.addAdditionalOwner = (e) => {
    e.preventDefault()
    this.record.stripe_account.object.legal_entity.additional_owners = this.record.stripe_account.object.legal_entity.additional_owners || []
    this.record.stripe_account.object.legal_entity.additional_owners.push({})
    this.update()
  }
  this.removeAdditionalOwner = (e) => {
    e.preventDefault()
    if (window.confirm(this.ERRORS.CONFIRM_DELETE)) {
      this.record.stripe_account.object.legal_entity.additional_owners.splice(e.item.index, 1)
      this.update()
    }
  }
  this.on('mount', () => {
    opts.api.professionals.on('show.success',this.show)
    opts.api.professionals.on('show.fail',this.errorHandler)
    opts.api.professionals.on('update.success',this.reload)
    opts.api.professionals.on('update.fail',this.errorHandler)
    opts.api.professionals.show(this.currentAccount.user_id)
  })
  this.on('unmount', () => {
    opts.api.professionals.off('show.success',this.update)
    opts.api.professionals.off('show.fail',this.errorHandler)
    opts.api.professionals.off('update.success',this.reload)
    opts.api.professionals.off('update.fail',this.errorHandler)
    this.destroyFileUploader()
  })
  this.show = (record) => {
    this.update({record: record, errors: null, busy: false})
    this.setupFileUploader()
  }
  this.reload = () => {
    this.destroyFileUploader()
    opts.api.professionals.show(this.currentAccount.user_id)
  }
  this.submit = (e) => {
    e.preventDefault()

    let data = this.serializeForm(e.target, {useIntKeysAsArrayIndex: true})

    if (_.isEmpty(data)) {
      $(e.target).animateCss('shake')
      return
    }

    this.update({busy: true, errors: null})
    this.opts.api.professionals.update(this.currentAccount.user_id, data)
  }
  this.setupFileUploader = () => {
    var self = this
    $('input[type=file]', this.root).each(function () {
      var $input = $(this)
      $input.fileupload({
        paramName: $input.attr('name'),
        type: 'put',
        url: `/api/professionals/${self.currentAccount.user_id}`,
        dropZone: false,
        add: function (e, data) {
          data.submit()
          .success(self.reload)
          .error(self.errorHandler)
        }
      })
    })
  }
  this.destroyFileUploader = () => {
    $('input[type=file]', this.root).fileupload('destroy');
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
