<r-reset-password>

  <h2 class="center mt0 mb2">Reset Password</h2>

  <form name="form" class="sm-col-12 left-align" action="/api/auth/password" onsubmit="{submit}">

    <input type="hidden" name="reset_password_token" value="{resetPasswordToken}"/>
    <span if="{errors['reset_password_token']}" class="inline-error">Token {errors['reset_password_token']}</span>

    <label for="password">Password *</label>
    <input class="block col-12 mb2 field"
    type="password" name="password" />
    <span if="{errors['password']}" class="inline-error">{errors['password']}</span>

    <label for="password">Password Confirmation *</label>
    <input class="block col-12 mb2 field"
    type="password" name="password_confirmation" />
    <span if="{errors['password_confirmation']}" class="inline-error">{errors['password_confirmation']}</span>

    <button type="submit" class="block col-12 mb2 btn btn-big btn-primary {busy: busy}">Reset password</button>

  </form>

  <div class="center">
    <a name="r-signin" href="/app/signin" title="Sign in" onclick="{opts.navigate}">Sign in</a>
    <a name="r-signin" href="/app/signup" title="Sign up" onclick="{opts.navigate}">Sign up</a>
  </div>


  <script>
  this.resetPasswordToken = riot.route.query()['reset_password_token']
  this.submit = (e) => {

    e.preventDefault()

    let data = this.serializeForm(this.form)

    if (_.isEmpty(data)) {
      $(this.form).animateCss('shake')
      return
    }

    this.update({busy: true, errors: null})

    this.opts.api.passwords.update(data)
    .fail(this.errorHandler)
    .then( () => {
      this.update({busy:false, succeed:true})
      window.location.href = '/app/signin'
    })
  }
  </script>
</r-reset-password>
