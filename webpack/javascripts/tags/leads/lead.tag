<r-leads-form>
  <form class="sm-col-7 md-col-5 left-align mx-auto mb4 p3 bg-lighten-4 black border adwords-form" name="form" onsubmit="{submit}">
    <h4 class="mt0 mb2 center">Arrange a free phone consultation</h4>

    <input type="hidden" name="meta[source]" value="adwords" />
    <input type="hidden" name="meta[glcid]" value="{opts.query.gclid}" />
    <input type="hidden" name="meta[utm_referrer]" value="{opts.query.utm_referrer}" />


    <div class="clearfix mxn2">
      <div class="sm-col sm-col-6 px2">
        <label for="first_name">First Name *</label>
        <input id="first_name" class="block col-12 mb2 field"
        type="text" name="first_name" autofocus="{opts.autofocus}" />
        <span if="{errors.first_name}" class="inline-error">{errors.first_name}</span>
      </div>
      <div class="sm-col sm-col-6 px2">
        <label for="last_name">First Name *</label>
        <input id="last_name" class="block col-12 mb2 field"
        type="text" name="last_name" />
        <span if="{errors.last_name}" class="inline-error">{errors.last_name}</span>
      </div>
    </div>
    <label for="phone_number">Phone Number *</label>
    <input id="phone_number" class="block col-12 mb2 field"
    type="tel" name="phone_number" />
    <span if="{errors.phone_number}" class="inline-error">{errors.phone_number}</span>
    <p class="h6 mb2">We never pass your details to 3rd parties.</p>
    <label for="person_project_type">Project type</label>
    <select class="block col-12 field mb2" name="meta[project_kind]" >
      <option value="renovation">Renovation</option>
      <option value="loft conversion">Loft Conversion</option>
      <option value="extension">Extension</option>
      <option value="basement conversion">Basement Conversion</option>
      <option value="kitchen renovation">Kitchen Renovation</option>
      <option value="bathroom Renovation">Bathroom Renovation</option>
      <option value="redecoration">Redecoration</option>
      <option value="new build">New Build</option>
    </select>
    <button name="button" type="submit" class="block col-12 btn btn-big btn-primary">Arrange a Callback</button>
  </form>
  <script>
  this.submit = (e) => {
    let data = this.serializeForm(this.form)

    this.update({busy: true, errors: null})

    opts.api.leads.create(data)
    .fail(this.errorHandler)
    .then(lead => {
      this.update({lead: lead, busy: false})
      this.sendGALeadConfirmationConversion().then(function () {
        window.location.href = '/pages/thank-you'
      })
    })
  }
  </script>
</r-leads-form>

<r-lead>
  <yield to="header">
    <header class="white bg-gray bg-cover bg-center" style="background-image: url(/assets/home/bg1_blur-e5c75336b83fc12f32299970aa6dde8b3fd0ea2f2227329fabd88b019a2da107.jpg)">
      <div class="container">
        <div class="center px2  clearfix">
          <div class="center mt2">
            <img src="/images/logos/black.svg" class="logo--medium">
          </div>
          <h1 class="h1 h2-responsive mt1 mb1">Get your project off to the perfect start by speaking to an expert</h1>
          <p class="sm-col-10 mx-auto mb3 h3">We will help answer any questions you have and advise you on the next steps.</p>
          <r-leads-form autofocus="true" query="{opts.query}"></r-leads-form>
        </div>
      </div>
    </header>
  </yield>
</r-lead>
