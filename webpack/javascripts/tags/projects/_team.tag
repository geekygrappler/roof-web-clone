<r-project-team>

  <h2 class="mt0">Team</h2>
  <p>Here is the team of your project. You can arrange site visits with professionals
    here or invite other members such as family members or your own builders.
  </p>

  <ul class="list-reset clearfix mxn1">

    <li each="{project.customers}" class="sm-col sm-col-6 p1 align-top">
      <div class="px2 border">
        <h3 class="inline-block">{ getName() }</h3>
        <span class="inline-block align-middle h6 mb1 px1 border pill bg-lime navy right mt2">Customer</span>
        <p class="overflow-hidden">
          <div><i class="fa fa-phone"></i> { profile.phone_number }</div>
          <div><i class="fa fa-envelope"></i> { email }</div>
          <a if="{currentAccount.id != id && currentAccount.user_type != user_type}"
          class="h6 btn btn-small btn-primary mt1" onclick="{openAppointmentModal}"><i class="fa fa-calendar-check-o"></i> Arrange Appointment</a>
        </p>
      </div>
    </li>

    <li each="{project.professionals}" class="sm-col sm-col-6 p1 align-top">
      <div class="px2 border">
        <h3 class="inline-block">{ getName() }</h3>
        <span class="inline-block align-middle h6 mb1 px1 border pill bg-aqua blue white right mt2">Professional</span>
        <p class="overflow-hidden">
          <div><i class="fa fa-phone"></i> { profile.phone_number }</div>
          <div><i class="fa fa-envelope"></i> { email }</div>
          <div if="{profile.website}"><i  class="fa fa-world"></i>{ profile.website }</div>
          <a if="{currentAccount.id != id && currentAccount.user_type != user_type}"
          class="h6 btn btn-small btn-primary mt1" onclick="{openAppointmentModal}"><i class="fa fa-calendar-check-o"></i> Arrange Appointment</a>
        </p>
      </div>
    </li>

    <li each="{project.administrators}" class="sm-col sm-col-6 p1 align-top">
      <div class="px2 border">
        <h3 class="inline-block">{ getName() }</h3>
        <span class="inline-block align-middle h6 mb1 px1 border pill right mt2">Admin</span>
        <p class="overflow-hidden">
          <div><i class="fa fa-phone"></i> { profile.phone_number }</div>
          <div><i class="fa fa-envelope"></i> { email }</div>
        </p>
      </div>
    </li>


  </ul>


  <div class="clearfix mxn1">
    <div class="sm-col sm-col-6 px1 mb2">
      <form name="form" class="sm-col-12 px2 border" onsubmit="{submit}">
        <h3><i class="fa fa-paper-plane-o"></i> Invite a new member</h3>
        <div class="clearfix">
          <label class="inline-block col col-6 mb2 truncate">
            <input type="radio" name="invitee_attributes[user_type]" value="Customer">Customer
          </label>
          <label class="inline-block col col-6 mb2 truncate">
            <input type="radio" name="invitee_attributes[user_type]" value="Professional">Professional
          </label>
        </div>
        <span class="inline-error block" if="{errors['invitee_attributes.user_type']}">{errors['invitee_attributes.user_type']}</span>
        <input type="email" name="invitee_attributes[email]" class="col-12 mb2 field" placeholder="Email"/>
        <span class="inline-error" if="{errors['invitee_attributes.email']}">{errors['invitee_attributes.email']}</span>
        <input type="hidden" name="inviter_id" value="{opts.api.currentAccount.id}">
        <input type="hidden" name="project_id" value="{opts.id}">
        <div class="right-align">
          <button type="submit" class="btn btn-primary mb2 {busy: busy}">Invite</button>
        </div>
      </form>
    </div>

    <div class="sm-col sm-col-6 px1 mb2">
      <div class="sm-col-12 px2 border">
        <h3><i class="fa fa-calendar-o"></i> Appointments</h3>

          <dl>
            <dt class="left">
              <i class="fa fa-hand-o-right"></i>
            </dt>
            <dd>
              <h4>At 02 May 2016</h4>
              <div><strong>Host:</strong> John Berger</div>
              <div><strong>Attendant:</strong> Dennis Bishofberger</div>
              <a class="btn btn-small h6 bg-maroon white mt1"><i class="fa fa-ban"></i> Cancel</a>
            </dd>
          </dl>

          <dl class="gray">
            <dt class="left">
              <i class="fa fa-thumbs-o-up"></i>
            </dt>
            <dd>
              <h4>Was 02 May 2013</h4>
              <div><strong>Host:</strong> John Berger</div>
              <div><strong>Attendant:</strong> Dennis Bishofberger</div>
            </dd>
          </dl>

      </div>
    </div>
  </div>


  <script>
  this.mixin('projectTab')

  this.getName = function () {
    return this.id !== this.currentAccount.id ? this.fullName() : 'You'
  }
  this.fullName = function () {
    return `${this.profile.first_name} ${this.profile.last_name}`
  }

  this.submit = (e) => {

    e.preventDefault()

    let data = this.serializeForm(this.form)

    if (_.isEmpty(data)) {
      $(this.form).animateCss('shake')
      return
    }

    this.update({busy: true, errors: null})

    this.opts.api.invitations.invite(data)
    .fail(this.errorHandler)
    .then(invitation => {
      this.update({busy:false})
      this.form.reset()
    })

  }
  this.openAppointmentModal = (e) => {
    e.preventDefault()
    riot.mount('r-modal', {
      content: 'r-appointment-form',
      persisted: false,
      api: opts.api,
      contentOpts: {api: opts.api}
    })
  }
  </script>
</r-project-team>
