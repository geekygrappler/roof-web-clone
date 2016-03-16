<r-header>
  <header class="container">
    <div>
      <nav class="relative clearfix {opts.color || 'black'} h5">
        <div class="left">
          <a href="/" class="btn py2"><img src="/images/logos/{opts.color || 'black'}.svg" class="logo--small" /></a>
        </div>
        <div class="right py1 sm-show mr1" if="{opts.api.currentAccount}">
          <a href="/app/projects/new" class="btn py2">Projects</a>
          <a href="/app/settings" class="btn py2">Settings</a>
          <a href="/app/signout" class="btn py2">Sign out</a>
        </div>
        <div class="right py1 sm-show mr1" if="{!opts.api.currentAccount}">
          <a href="/pages/about" class="btn py2">About us</a>
          <a href="/#how-it-works" class="btn py2">How it works</a>
          <a href="/app/signin" class="btn py2">Sign in</a>
        </div>
        <div class="right sm-hide py1 mr1">
          <div class="inline-block" data-disclosure>
            <div data-details class="fixed top-0 right-0 bottom-0 left-0"></div>
            <a class="btn py2 m0">
              <span class="md-hide">
                <i class="fa fa-bars"></i>
              </span>
            </a>
            <div data-details class="absolute left-0 right-0 nowrap bg-white black mt1">
              <ul class="h5 list-reset py1 mb0" if="{opts.api.currentAccount}">
                <li><a href="/app/projects/new" class="btn block">Projects</a></li>
                <li><a href="/app/settings" class="btn block">Settings</a></li>
                <li><a href="/app/signout" class="btn block">Sign out</a></li>
              </ul>
              <ul class="h5 list-reset py1 mb0" if="{!opts.api.currentAccount}">
                <li><a href="/pages/about" class="btn block">About us</a></li>
                <li><a href="/#how-it-works" class="btn block">How it works</a></li>
                <li><a href="/app/signin" class="btn block">Sign in</a></li>
              </ul>
            </div>
          </div>
        </div>
      </nav>
    </div>
  </header>
</r-header>

<r-projects>
  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>
  <h1>Projects</h1>
</r-projects>

<r-signup>

  <h2 class="center mt0 mb2">Sign up</h2>
    <form name="form" classes="sm-col-12 left-align" action="/api/accounts" onsubmit="{submit}">

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

      <button type="submit" class="block col-12 mb2 btn btn-big btn-primary">Sign up</button>

      <small class="h6 block center">By signing up, you agree to the <a href="/pages/terms-conditions">Terms of Service</a></small>

    </form>

  <div class="center"><a name="r-signin" href="/app/signin" title="Sign in" onclick="{opts.navigate}">Sign in</a></div>


  <script>
  this.submit = (e) => {

    e.preventDefault()

    let data = this.serializeForm(this.form)

    if (_.isEmpty(data)) {
      $(this.form).animateCss('.shake')
      return
    }

    this.update({busy: true})


    this.opts.api.registrations.signup(data)
    .fail(this.errorHandler)
    .then(account => this.update({busy:false}))
  }
  </script>
</r-signup>

<r-signin>

  <h2 class="center mt0 mb2">Sign in</h2>
  <form name="form" classes="sm-col-12 left-align" action="/api/accounts/sign_in" onsubmit="{submit}">

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
      $(this.form).animateCss('.shake')
      return
    }

    this.update({busy: true})
    this.opts.api.sessions.signin(creds)
    .fail(this.errorHandler)
    .then(account => this.update({busy:false}))

  }
  this.showAuthModal = () => {
    this.update({errors: this.ERRORS[401]})
  }
  </script>
</r-signin>

<r-tabs>
  <div name="tab"></div>

  <script>
  this.navigate = (e) => {
    if (e) {
      e.preventDefault()
      this.opts.tab = e.target.name
      history.pushState(null, e.target.title, e.target.href)
    }
    riot.mount(this.tab, this.opts.tab, {navigate: this.navigate, api: opts.api})
  }
  this.navigate()

  </script>
</r-tabs>

<r-auth>
  <r-tabs tab="{opts.tab}" api="{opts.api}"></r-tabs>
</r-auth>

<r-modal>

  <div name="body" class="black modal-body out">
    <div class="fixed left-0 top-0 right-0 bottom-0 z4 overflow-auto bg-darken-4">
      <div class="relative sm-col-6 sm-px3 px1 py3 mt4 mb4 mx-auto bg-white modal-container">
        <a if="{!opts.persisted}" class="absolute btn btn-small right-0 top-0 mr1 mt1" onclick="{close}">
          <i class="fa fa-times"></i>
        </a>
        <div name="content"></div>
      </div>
    </div>
  </div>

  <script>
  riot.mount(this.content, this.opts.content, this.opts.contentOpts)

  // auth modal? let's auto close it when it's done
  if(this.opts.content == 'r-auth') {
    this.opts.api.sessions.on('signin.success', () => this.close())
    this.opts.api.registrations.on('signup.success', () => this.close())
  }

  this.close = (e) => {
    if (e) e.preventUpdate = true
    $(this.body)
    .on('transitionend', this.unmount.bind(true))
    .addClass('out')
  }

  this.on('mount', () => {
    document.body.classList.add('overflow-hidden')
    setTimeout(() => {
      $(this.body).removeClass('out')
    }, 100)
  })

  this.on('unmount', () => {
    $('body').removeClass('overflow-hidden')
  })
  </script>
</r-modal>


<r-app>
  <yield from="header" />

  <div name="content"></div>

  <script>
  this.opts.api.sessions.on('signin.success', this.update)
  this.opts.api.sessions.on('signout.success', this.update)
  this.opts.api.registrations.on('signup.success', this.update)
  riot.route('signout', () => {
    this.opts.api.sessions.signout()
  })
  riot.route('signin', () => {
    if (opts.api.currentAccount) return riot.route(this.authenticatedRoot)
    riot.mount('r-modal', {content: 'r-auth', persisted: true, api: opts.api, contentOpts: {tab: 'r-signin', api: opts.api}})
  })
  riot.route('signup', () => {
    if (opts.api.currentAccount) return riot.route(this.authenticatedRoot)
    riot.mount('r-modal', {content: 'r-auth', persisted: true, api: opts.api, contentOpts: {tab: 'r-signup', api: opts.api}})
  })
  riot.route('projects', () => {
    riot.mount(this.content, 'r-projects', {api: opts.api})
  })
  </script>
</r-app>
