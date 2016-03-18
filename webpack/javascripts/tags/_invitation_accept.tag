<r-invitation-accept>

  <h2 class="center mt0 mb2">Sign up</h2>
    <form name="form" classes="sm-col-12 left-align" action="/api/invitations/accept" onsubmit="{submit}">

      <div if="{errors.token}" id="error_explanation">{errors.token}</div>

      <div class="clearfix mxn2">
        <div class="col col-6 px2">
          <label for="invitee_attributes[profile][first_name]">First Name *</label>
          <input class="block col-12 mb2 field" autofocus="true"
          type="text" name="invitee_attributes[profile][first_name]" />
          <span if="{errors['user.profile.first_name']}" class="inline-error">{errors['user.profile.first_name']}</span>
        </div>
        <div class="col col-6 px2">
          <label for="invitee_attributes[profile][last_name]">Last Name *</label>
          <input class="block col-12 mb2 field"
          type="text" name="invitee_attributes[profile][last_name]" />
          <span if="{errors['user.profile.last_name']}" class="inline-error">{errors['user.profile.last_name']}</span>
        </div>
      </div>

      <label for="invitee_attributes[profile][phone_number]">Phone Number *</label>
      <input class="block col-12 mb2 field"
      type="tel" name="invitee_attributes[profile][phone_number]" />
      <span if="{errors['user.profile.phone_number']}" class="inline-error">{errors['user.profile.phone_number']}</span>

      <h6 class="mb2 p1 green border-left border-right border-bottom" style="margin-top:-1rem">Your privacy is important.
      <br/>We only share your number with selected contractors working on your project.
      </h6>

      <label for="password">Password *</label>
      <em class="h5">(8 characters minimum)</em>
      <input class="block col-12 mb2 field" autocomplete="off"
      type="password" name="invitee_attributes[password]" />
      <span if="{errors['password']}" class="inline-error">{errors['password']}</span>

      <input type="hidden" name="token" value="{opts.api.invitationToken}" />

      <button type="submit" class="block col-12 mb2 btn btn-big btn-primary {busy: busy}">Sign up</button>

      <small class="h6 block center">By signing up, you agree to the <a href="/pages/terms-conditions">Terms of Service</a></small>

    </form>


  <script>
  this.submit = (e) => {

    e.preventDefault()

    let data = this.serializeForm(this.form)

    if (_.isEmpty(data)) {
      $(this.form).animateCss('shake')
      return
    }

    this.update({busy: true, errors: null})

    this.opts.api.invitations.accept(data)
    .fail(this.errorHandler)
    .then(invitation => {
      this.opts.api.invitationToken = null
      delete this.opts.api.invitationToken
      this.update({busy:false})
      riot.route(`/projects/${invitation.project_id}`)
    })
  }
  </script>
</r-invitation-accept>
