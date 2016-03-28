let options = require("json!../../data/brief.json")
import '../projects/_option_group_input.tag'
import '../_typeahead_input.tag'

<r-admin-project-form>

  <h2 class="center mt0 mb2">{ opts.resource.humanize() }</h2>

  <form name="form" class="edit_project" onsubmit="{ submit }" autocomplete="off">

    <label for="account_id">Account</label>
    <input type="hidden" name="account_id" value="{record.account_id}">
    <r-typeahead-input resource="accounts" api="{ opts.api }" id="{record.account_id}" datum_tokenizer="email"></r-typeahead-input>
    <span if="{errors.account_id}" class="inline-error">{errors.account_id}</span>

    <label for="name">Name</label>
    <input id="name" class="block col-12 mb2 field"
    type="text" name="name" value="{record.name}"
    oninput="{setValue}"/>

    <section class="container clearfix" data-step="1">
      <div class="container">
        <h2>Mission</h2>
        <div class="clearfix mxn2 border">
          <div each="{options.kind}" class="center col col-6 md-col-4">
            <a class="block p2 bg-lighten-4 black icon-radio--button {active: (name === record.kind)}" onclick="{ setProjectKind }">
              <img class="fixed-height" src="{icon}" alt="{name}">
              <h4 class="m0 caps center truncate icon-radio--name">{name}</h4>
              <input type="radio" name="kind" value="{value}" class="hide" checked="{value === record.kind}">
            </a>
          </div>
        </div>
      </div>
    </section>

    <section class="container clearfix" data-step="2">
      <div class="container">
        <h2>Helpful details</h2>
        <p class="h2">Description *</p>

        <textarea id="brief.description" name="brief[description]" class="fixed-height block col-12 mb2 field"
        placeholder="Please write outline of your project" required="true" autofocus="true"
        oninput="{setValue}">{record.brief.description}</textarea>
        <span if="{errors['brief.description']}" class="inline-error">{errors['brief.description']}</span>

        <div class="clearfix mxn2 mb2 left-align">
          <div class="sm-col sm-col-6 px2">
            <label for="brief[budget]">Budget</label>
            <select id="brief.budget" name="brief[budget]" class="block col-12 mb2 field" onchange="{setValue}">
              <option each="{value, i in options.budget}"
              value="{value}" selected="{value === record.brief.budget}">{value}</option>
            </select>
          </div>
          <div class="sm-col sm-col-6 px2">
            <label for="brief[preferred_start]">Start</label>
            <select id="brief.preferred_start" name="brief[preferred_start]" class="block col-12 mb2 field" onchange="{setValue}">
              <option each="{value, i in options.preferredStart}"
              value="{value}" selected="{value === record.brief.preferred_start}">{value}</option>
            </select>
          </div>
        </div>


      </div>
    </section>

    <section class="container clearfix" data-step="3">
      <div class="container">
        <h2>Documents and Photos</h2>
        <div class="clearfix mxn2">
          <div class="sm-col sm-col-12 px2 mb2">
            <p class="h2">Upload plans, documents, site photos or any other files about your project</p>

            <r-files-input-with-preview name="assets" record="{record}"></r-files-input-with-preview>

          </div>
        </div>

      </div>
    </section>

    <section class="container clearfix" data-step="4">
      <div class="container">
        <h2>Address</h2>
        <p class="h2">Location of project</p>
        <div class="clearfix left-align">
          <label for="address[street_address]">Street Address</label>
          <input id="address.street_address" class="block col-12 mb2 field"
          type="text" name="address[street_address]" value="{record.address.street_address}"
          oninput="{setValue}"/>
          <div class="clearfix mxn2">
            <div class="col col-6 px2">
              <label for="address[city]">City</label>
              <input id="address.city" class="block col-12 mb2 field"
              type="text" name="address[city]" value="{record.address.city}"
              oninput="{setValue}"/>
            </div>
            <div class="col col-6 px2">
              <label for="address[postcode]">Postcode</label>
              <input id="address.postcode" class="block col-12 mb2 field"
              type="text" name="address[postcode]" value="{record.address.postcode}"
              oninput="{setValue}"/>
            </div>
          </div>
        </div>

      </div>
    </section>


    <button type="submit" class="block col-12 mb2 btn btn-big btn-primary {busy: busy}">Save</button>

  </form>

  <script>

  this.step = 5
  this.options = options

  this.setProjectKind = (e) => {
    this.record.kind = e.item.value
  }

  this.setInputValue = (e) => {
    this.record[e.target.name] = e.target.value
  }

  this.tags['r-typeahead-input'].on('itemselected', (item) => {
    this.record.account_id = item.id
    this.update()
  })

  this.submit = this.submit || (e) => {
    let assetsToAssign

    if (e) e.preventDefault()

    let data = this.serializeForm(this.form)

    if (_.isEmpty(data)) {
      $(this.form).animateCss('shake')
      return
    }

    this.update({busy: true, errors: null})

    if (this.opts.id) {
      this.opts.api[this.opts.resource].update(this.opts.id, data)
      .fail(this.errorHandler)
      .then(id => {
        this.update({busy:false})
        this.closeModal()
      })
    }else{

      // stash uploaded assets to be assigned to project
      assetsToAssign = _.pluck(this.record.assets, 'id')

      this.opts.api[this.opts.resource].create(data)
      .fail(this.errorHandler)
      .then(record => {
        this.update({record: record, busy:false})
        this.opts.id = record.id
        // history.pushState(null, null, `/app/admin/${this.opts.resource}/${record.id}/edit`)

        // got some uploads, let's assign them to project
        if( !_.isEmpty(assetsToAssign) ) {
          this.request({url: `/api/projects/${record.id}/assets`, type: 'post', data: {ids: assetsToAssign}})
          .fail(() => {
            this.update({busy:false})
            window.alert(this.ERRORS.ASSET_ASSIGNMENT)
            this.closeModal()
          })
          .then(() => {
            this.update({busy:false})
            this.closeModal()
          })
        } else {
          this.closeModal()
        }

      })
    }
  }

  this.mixin('adminForm')
  </script>

</r-admin-project-form>
