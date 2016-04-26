<r-forgot-password>

  <h2 class="center mt0 mb2">Forgot Password</h2>

  <form if="{!succeed}" name="form" class="sm-col-12 left-align" action="/api/auth/password" onsubmit="{submit}">

    <label for="email">Email *</label>
    <input class="block col-12 mb2 field"
    type="text" name="email" />
    <span if="{errors['email']}" class="inline-error">{errors['email']}</span>

    <button type="submit" class="block col-12 mb2 btn btn-big btn-primary {busy: busy}">Send password reset instructions</button>

  </form>

  <p if="{succeed}" class="p2">Password reset instructions sent to your email.</p>

  <div class="center">
    <a name="r-signin" href="/app/signin" title="Sign in" onclick="{opts.navigate}">Sign in</a>
    <a name="r-signin" href="/app/signup" title="Sign up" onclick="{opts.navigate}">Sign up</a>
  </div>


  <script>
  this.submit = (e) => {

    e.preventDefault()

    let data = this.serializeForm(this.form)

    if (_.isEmpty(data)) {
      $(this.form).animateCss('shake')
      return
    }

    this.update({busy: true, errors: null})

    this.opts.api.passwords.create(data)
    .fail(this.errorHandler)
    .then(account => {
      this.update({busy:false, succeed:true})

    })
  }
  </script>
</r-forgot-password>
