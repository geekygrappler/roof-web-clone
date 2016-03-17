let options = require("json!../../data/brief.json")
import './_file_input.tag'
import './_files_input_with_preview.tag'
import '../arrange_callback.tag'

<r-projects-brief>
  <yield if="{!opts.api.currentAccount}" to="header">
    <header class="container">
      <nav class="relative clearfix {step > 0 ? 'black' : 'white'} h5">
        <div class="left">
          <a href="/" class="btn py2"><img src="/images/logos/{step > 0 ? 'black' : 'white'}.svg" class="logo--small" /></a>
        </div>
      </nav>
    </header>
  </yield>

  <yield if="{opts.api.currentAccount}" to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>

  <section if="{!opts.api.currentAccount}" class="absolute col-12 center px2 py2 white {out: step != 0}" data-step="0">
    <div class="container">
      <h1 class="h1 h1-responsive sm-mt4 mb1">Thanks for getting started!</h1>
      <p class="h3 sm-col-6 mx-auto mb2">The next few questions will create your brief :)</p>
      <div><button class="btn btn-big btn-primary mb3" onclick="{ start }">Ok, Got it</button></div>
      <p>Or <button class="h5 btn btn-narrow btn-outline white ml1 mr1" onclick="{ showArrangeCallbackModal }">Arrange a callback</button> to speak with a human</p>
    </div>
  </section>

  <form name="form" action="/api/projects" onsubmit="{submit}">

  <section class="absolute col-12 center px2 py2 {out: step != 1}" data-step="1">
    <div class="container">
      <h1 class="h1-responsive mt0 mb4">Mission</h1>
      <div class="clearfix mxn2 border">
        <div each="{options.kind}" class="center col col-6 md-col-4">
          <a class="block p2 bg-lighten-4 black icon-radio--button {active: (name === project.kind)}" onclick="{ setProjectKind }">
            <img class="fixed-height" src="{icon}" alt="{name}">
            <h4 class="m0 caps center truncate icon-radio--name">{name}</h4>
            <input type="radio" name="kind" value="{value}" class="hide" checked="{value === project.kind}">
          </a>
        </div>
      </div>
    </div>
  </section>

  <section class="absolute col-12 center px2 py2 {out: step != 2}" data-step="2">
    <div class="container">
      <h1 class="h1-responsive mt0 mb4">Helpful details</h1>
      <p class="h2">Description *</p>

      <textarea id="brief.description" name="brief[description]" class="fixed-height block col-12 mb2 field"
      placeholder="Please write outline of your project" required="true" autofocus="true"
      oninput="{setValue}">{project.brief.description}</textarea>
      <span if="{errors['brief.description']}" class="inline-error">{errors['brief.description']}</span>

      <div class="clearfix mxn2 mb2 left-align">
        <div class="sm-col sm-col-6 px2">
          <label for="brief[budget]">Budget</label>
          <select id="brief.budget" name="brief[budget]" class="block col-12 mb2 field" onchange="{setValue}">
            <option each="{value, i in options.budget}"
            value="{value}" selected="{value === project.brief.budget}">{value}</option>
          </select>
        </div>
        <div class="sm-col sm-col-6 px2">
          <label for="brief[preferred_start]">Start</label>
          <select id="brief.preferred_start" name="brief[preferred_start]" class="block col-12 mb2 field" onchange="{setValue}">
            <option each="{value, i in options.preferredStart}"
            value="{value}" selected="{value === project.brief.preferred_start}">{value}</option>
          </select>
        </div>
      </div>

      <div class="right-align">
        <a class="btn btn-big mb4" onclick="{ prevStep }">Back</a>
        <a class="btn btn-big btn-primary mb4" onclick="{ nextStep }">Continue</a>
      </div>
    </div>
  </section>

  <section class="absolute col-12 center px2 py2 {out: step != 3}" data-step="3">
    <div class="container">
      <h1 class="h1-responsive mt0 mb4">Documents and Photos</h1>
      <div class="clearfix mxn2">
        <div class="sm-col sm-col-12 px2 mb2">
          <p class="h2">Upload plans, documents, site photos or any other files about your project</p>

          <r-files-input-with-preview name="assets" record="{project}"></r-files-input-with-preview>

        </div>
      </div>
      <div class="right-align">
        <a class="btn btn-big mb1" onclick="{ prevStep }">Back</a>
        <a class="btn btn-big btn-primary mb1" onclick="{ nextStep }">Continue</a>
      </div>
      <div class="right-align mb4">
        <a onclick="{ parent.nextStep }">Skip for now</a>
      </div>
    </div>
  </section>

  <section class="absolute col-12 center px2 py2 {out: step != 4}" data-step="4">
    <div class="container">
      <h1 class="h1-responsive mt0 mb4">Address</h1>
      <p class="h2">Location of project</p>
      <div class="clearfix left-align">
        <label for="address[street_address]">Street Address</label>
        <input id="address.street_address" class="block col-12 mb2 field"
        type="text" name="address[street_address]" value="{project.address.street_address}"
        oninput="{setValue}"/>
        <div class="clearfix mxn2">
          <div class="col col-6 px2">
            <label for="address[city]">City</label>
            <input id="address.city" class="block col-12 mb2 field"
            type="text" name="address[city]" value="{project.address.city}"
            oninput="{setValue}"/>
          </div>
          <div class="col col-6 px2">
            <label for="address[postcode]">Postcode</label>
            <input id="address.postcode" class="block col-12 mb2 field"
            type="text" name="address[postcode]" value="{project.address.postcode}"
            oninput="{setValue}"/>
          </div>
        </div>
      </div>
      <div class="right-align">
          <a class="btn btn-big mb1" onclick="{ prevStep }">Back</a>
          <a class="btn btn-big btn-primary mb1" onclick="{ nextStep }">Continue</a>
      </div>
    </div>
  </section>

  <section class="absolute col-12 center px2 py2 {out: step != 5}" data-step="5">
    <div class="container">
      <h1 class="h1-responsive mt0 mb4">Project Summary</h1>
      <div class="clearfix p3 border mb3">
        <p class="h3 mt0">
          You are planning a <strong><span class="inline-block px1 mb1 border-bottom border-yellow summary--project-type">{ project.kind }</span></strong>
          <span show="{ !_.isEmpty(_.compact(_.values(project.address))) }" class="summary--address-container">at <strong><span class="inline-block px1 mb1 border-bottom border-yellow summary--address"><span each="{name, add in project.address }">{ add }, </span></span></strong></span>.
          The basic overview of the brief is: <strong><span class="inline-block px1 mb1 border-bottom border-yellow summary--description">{ project.brief.description }</span></strong>.
          <br>
          <span show="{ project.brief.budget }" class="summary--budget-container" >You have a budget of <strong><span class="inline-block px1 mb1 border-bottom border-yellow summary--budget">{ project.brief.budget }</span></strong></span>
          <span show="{ project.brief.preferred_start }" class="summary--start-date-container">and would like to start <strong><span class="inline-block px1 mb1 border-bottom border-yellow summary--start-date">{ project.brief.preferred_start }</span></strong>.</span>
        </p>
      </div>
      <div class="right-align">
        <a class="btn btn-big mb4" onclick="{ prevStep }">Back</a>
        <button class="btn btn-big btn-primary mb4" type="submit">Correct! Make it happen</button>
      </div>
    </div>
  </section>
  </form>

  <script>
  this.step = opts.api.currentAccount ? 1 : 0
  this.project = {brief: {}, address: {}}
  this.options = options
  // listen signup/signin events if not logged in as we need to resubmit form
  // after user authorized herself
  if (!opts.api.currentAccount) {
    opts.api.sessions.one('signin.success', () => this.submit())
    opts.api.registrations.one('signup.success', () => this.submit())
  }

  if( this.step === 0) {
    $('body')
    .one('transitionend', () => $('body').removeClass('no-transition'))
    .addClass('no-transition bg-gray')
  }

  this.start = () => {
    $("body").toggleClass('no-transition bg-gray')
    setTimeout(()=> $(".logo--small").attr('src', $(".logo--small").attr('data-src-black')), 300)
    this.update({step: 1})
  }

  this.setProjectKind = (e) => {
    this.project.kind = e.item.value
    this.update({step: 2})
  }

  this.setValue = (e) => {
    this.dot.str(e.target.id, e.target.value, this.project)
  }

  this.nextStep = (e) => {
    e.preventDefault()
    if (this.validateStep()) this.update({step: this.step + 1})
  }

  this.prevStep = (e) => {
    e.preventDefault()
    this.update({step: this.step - 1})
  }

  this.validateStep = () => {
    let hasError, $requireds = $(`[data-step=${this.step}] [required]`)
    if ($requireds.length > 0) {
      hasError = _.isEmpty(_.compact(_.map($requireds, el => {
        let empty = _.isEmpty(el.value)
        if (empty) {
          this.update({errors: {[el.id]: [this.ERRORS.BLANK]}})
        }
        return empty ? null : true
      })))
      return !hasError
    } else {
      return true
    }
  }

  this.submit = (e) => {
    let project, assetsToAssign
    if (e) e.preventDefault()

    if (this.step === 5) {
      project = this.serializeForm(this.form)

      if (_.isEmpty(project)) {
        $(this.form).animateCss('shake')
        return
      }

      this.update({busy: true})

      // stash uploaded assets to be assigned to project
      assetsToAssign = _.pluck(this.project.assets, 'id')

      this.opts.api.projects.create(project)
      .fail(this.errorHandler)
      .then(project => {
        this.update({busy:false})

        // no assets? go to project page immediately
        if( _.isEmpty(assetsToAssign) ) {
          riot.route(`/projects/${project.id}`)

        // got some uploads, let's assign them to project
        } else {
          this.request({url: `/api/projects/${project.id}/assets`, type: 'post', data: {ids: assetsToAssign}})
          .fail(() => {
            window.alert(this.ERRORS.ASSET_ASSIGNMENT)
            riot.route(`/projects/${project.id}`)
          })
          .then(() => {
            console.log('assets uplaoded')
            riot.route(`/projects/${project.id}`)
          })
        }
      })
    } else {
      this.update({step: this.step + 1})
    }
  }

  this.showAuthModal = () => {
    riot.mount('r-modal', {
      content: 'r-auth',
      persisted: false,
      api: opts.api,
      contentOpts: {tab: 'r-signup', api: opts.api}
    })
  }

  this.showArrangeCallbackModal = () => {
    riot.mount('r-modal', {
      content: 'r-arrange-callback',
      persisted: false,
      api: opts.api,
      contentOpts: {api: opts.api}
    })
  }

  </script>
</r-projects-brief>
