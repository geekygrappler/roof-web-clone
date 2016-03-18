
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
        type="date" name="profile[dob]" value="{currentAccount.profile.dob}"/>
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
  if(opts.api.currentAccount.isProfessional) {
    this.subnavLinks = [
      {href: `/app/settings/profile`, name: 'profile', tag: 'r-settings-profile'},
      {href: `/app/settings/notifications`, name: 'notifications', tag: 'r-settings-notifications'},
      {href: `/app/settings/account`, name: 'account', tag: 'r-settings-account'}
    ]
  }
  </script>
</r-settings>
