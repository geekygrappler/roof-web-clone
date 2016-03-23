<r-signup>

  <h2 class="center mt0 mb2">Sign up</h2>
    <form name="form" class="sm-col-12 left-align" action="/api/auth" onsubmit="{submit}">

      <div class="clearfix mxn2">
        <div class="col col-6 px2">
          <label for="user[profile][first_name]">First Name *</label>
          <input class="block col-12 mb2 field" autofocus="true"
          type="text" name="user[profile][first_name]" />
          <span if="{errors['user.profile.first_name']}" class="inline-error">{errors['user.profile.first_name']}</span>
        </div>
        <div class="col col-6 px2">
          <label for="user[profile][last_name]">Last Name *</label>
          <input class="block col-12 mb2 field"
          type="text" name="user[profile][last_name]" />
          <span if="{errors['user.profile.last_name']}" class="inline-error">{errors['user.profile.last_name']}</span>
        </div>
      </div>

      <label for="user[profile][phone_number]">Phone Number *</label>
      <input class="block col-12 mb2 field"
      type="tel" name="user[profile][phone_number]" />
      <span if="{errors['user.profile.phone_number']}" class="inline-error">{errors['user.profile.phone_number']}</span>

      <h6 class="mb2 p1 green border-left border-right border-bottom" style="margin-top:-1rem">Your privacy is important.
      <br/>We only share your number with selected contractors working on your project.
      </h6>

      <label for="email">Email *</label>
      <input class="block col-12 mb2 field"
      type="text" name="email" />
      <span if="{errors['email']}" class="inline-error">{errors['email']}</span>

      <label for="password">Password *</label>
      <em class="h5">(8 characters minimum)</em>
      <input class="block col-12 mb2 field" autocomplete="off"
      type="password" name="password" />
      <span if="{errors['password']}" class="inline-error">{errors['password']}</span>

      <button type="submit" class="block col-12 mb2 btn btn-big btn-primary {busy: busy}">Sign up</button>

      <small class="h6 block center">By signing up, you agree to the <a href="/pages/terms-conditions">Terms of Service</a></small>

    </form>

  <div class="center"><a name="r-signin" href="/app/signin" title="Sign in" onclick="{opts.navigate}">Sign in</a></div>


  <script>
  this.submit = (e) => {

    e.preventDefault()

    let data = this.serializeForm(this.form)

    if (_.isEmpty(data)) {
      $(this.form).animateCss('shake')
      return
    }

    this.update({busy: true, errors: null})

    this.opts.api.registrations.signup(data)
    .fail(this.errorHandler)
    .then(account => {
      this.update({busy:false})
      riot.route(opts.api.authenticatedRoot, 'Projects', true)
    })
  }
  </script>
</r-signup>
