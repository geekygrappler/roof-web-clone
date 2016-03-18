<r-project-team>

  <h2 class="mt0">Team</h2>
  <p>Here is the team of your project. You can arrange site visits with professionals
    here or invite other members such as family members or your own builders.
  </p>

  <ul class="list-reset mxn1">
    <li each="{project.customers}" class="inline-block p1 sm-col-4 align-top">
      <div class="px2 border">
        <h2 class="inline-block">{ getName() }</h2>
        <span class="inline-block align-middle h6 mb1 px1 border pill">Member</span>
        <p class="overflow-hidden">
          <i class="fa fa-phone"></i> { profile.phone_number }<br>
          <i class="fa fa-envelope"></i> { email }<br>
        </p>
        <p class="overflow-hidden m0 mxn2 p2 bg-yellow">
          <a class="h5 btn btn-small bg-darken-2" onclick="{openAppointments}">
            <i class="fa fa-calendar-o"></i> Appointments
          </a>
        </p>
      </div>
    </li>

    <li each="{project.professionals}" class="inline-block p1 align-top sm-col-4 align-top">
      <div class="px2 border">
        <h2 class="inline-block">{ getName() }</h2>
        <span class="inline-block align-middle h6 mb1 px1 border pill">Professional</span>
        <p class="overflow-hidden">
          <i class="fa fa-phone"></i> { profile.phone_number }<br>
          <i class="fa fa-envelope"></i> { email }<br>
          <div if="{profile.website}"><i  class="fa fa-world"></i>{ profile.website }<br></div>
        </p>
      </div>
    </li>

    <li each="{project.administrators}" class="inline-block p1 sm-col-4 align-top">
      <div class="px2 border">
        <h2 class="inline-block">{ getName() }</h2>
        <span class="inline-block align-middle h6 mb1 px1 border pill">Admin</span>
        <p class="overflow-hidden">
          <i class="fa fa-phone"></i> { profile.phone_number }<br>
          <i class="fa fa-envelope"></i> { email }<br>
        </p>
      </div>
    </li>


  </ul>



  <form name="form" class="sm-col-8 p2 border" onsubmit="{submit}">
    <input type="hidden" name="inviter_id" value="{opts.api.currentAccount.id}">
    <input type="hidden" name="project_id" value="{opts.id}">
    <h3 class="mt0">Invite a new member</h3>
    <div class="clearfix">
      <label class="inline-block col col-6 mb2">
        <input type="radio" name="invitee_attributes[user_type]" value="Customer">Customer
      </label>
      <label class="inline-block col col-6 mb2">
        <input type="radio" name="invitee_attributes[user_type]" value="Professional">Professional
      </label>
    </div>
    <span class="inline-error block" if="{errors['invitee_attributes.user_type']}">{errors['invitee_attributes.user_type']}</span>
    <input type="email" name="invitee_attributes[email]" class="col-12 mb2 field" placeholder="Email"/>
    <span class="inline-error" if="{errors['invitee_attributes.email']}">{errors['invitee_attributes.email']}</span>
    <div class="right-align">
      <button type="submit" class="btn btn-primary {busy: busy}">Invite</button>
    </div>
  </form>



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
  </script>
</r-project-team>
