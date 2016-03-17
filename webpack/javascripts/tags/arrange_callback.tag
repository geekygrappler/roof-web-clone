<r-arrange-callback>

  <div if="{lead}" class="center">
    <h1 class="mt0">Your callback has been successfully arranged.</h2>
    <p class="h3 sm-col-6 mx-auto mb2">Thanks for your interest! We will get back to you very shortly.</p>
    <a href="/" class="btn btn-primary gray">Take me home</a>
  </div>

  <form if="{!lead}" name="form" classes="sm-col-12 left-align" action="/api/leads" onsubmit="{submit}">

    <h2 class="center mt0 mb2">A 1Roof expert will get in touch soon to talk about your project
      and help you with any questions or concerns you may have.
    </h2>

    <div class="clearfix mxn2">
      <div class="sm-col sm-col-6 px2">
        <label for="first_name">First Name *</label>
        <input id="first_name" class="block col-12 mb2 field"
        type="text" name="first_name" autofocus="true" />
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

    <button class="block col-12 mb2 btn btn-big btn-primary {busy: busy}" type="submit">Arrange a Callback</button>
  </form>

  <script>
  this.submit = (e) => {
    let data = this.serializeForm(this.form)
    opts.api.leads.create(data)
    .fail(this.errorHandler)
    .then(lead => this.update({lead}))
  }
  </script>
</r-arrange-callback>
