<r-signin>

  <h2 class="center mt0 mb2">Sign in</h2>
  <form name="form" class="sm-col-12 left-align" action="/api/accounts/sign_in" onsubmit="{submit}">

    <div if="{errors}" id="error_explanation">
      {errors}
    </div>

    <label for="email">Email</label>
    <input class="block col-12 mb2 field" autofocus="true"
    type="text" name="email" />

    <label for="email">Password</label>
    <input class="block col-12 mb2 field" autocomplete="off"
    type="password" name="password" />

    <div>
      <label class="inline-block mb2">
        <input type="checkbox" label="Remember me" name="remember_me" /> Remember me
      </label>
    </div>

    <button name="submit" type="submit" class="block col-12 mb2 btn btn-big btn-primary {busy: busy}" disabled="{busy}">Sign in</button>

    <div class="center">
      <a name="r-reset-password" href="/app/reset-password" title="Reset Password" onclick="{opts.navigate}" class="block">Forgot your password?</a>
    </div>

  </form>

  <div class="center"><a name="r-signup" href="/app/signup" title="Sign up" onclick="{opts.navigate}">Sign up</a></div>


  <script>
  this.submit = (e) => {

    e.preventDefault()

    let creds = this.serializeForm(this.form)

    if (_.isEmpty(creds)) {
      $(this.form).animateCss('shake')
      return
    }

    this.update({busy: true, errors: null})

    this.opts.api.sessions.signin(creds)
    .fail(this.errorHandler)
    .then(account => {
      this.update({busy:false})
      riot.route(opts.api.authenticatedRoot)
    })

  }
  this.showAuthModal = () => {
    this.update({errors: this.ERRORS[401]})
  }
  </script>
</r-signin>
