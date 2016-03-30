import '../../mixins/team_tab.js'

let options = require("json!../../data/brief.json")
import '../projects/_option_group_input.tag'
import '../_typeahead_input.tag'

import '../projects/_appointments.tag'

<r-admin-project-form-overview>
  <h2 class="mt0">{ record.name }</h2>
  <hr>

  <h3>Description</h3>
  <p>{ record.brief.description }</p>

  <div class="clearfix mxn1">
    <div class="sm-col sm-col-6 px1">
      <h3>Budget</h3>
      <p if="{ record.brief.budget }">{ record.brief.budget }</p>
      <p if="{ !record.brief.budget && !currentAccount.isProfessional}">
        You have not set a project budget yet (<a href="/app/projects/{ record.id }/brief">add one</a>)
      </p>
      <p if="{ !record.brief.budget && currentAccount.isProfessional}">
        N/A
      </p>
    </div>

    <div class="sm-col sm-col-6 px1">
      <h3>Preferred Start date</h3>
      <p if="{ record.brief.preferred_start }">{ record.brief.preferred_start }</p>
      <p if="{ !record.brief.preferred_start && !currentAccount.isProfessional}">
        You have not defined a start date yet (<a href="/app/projects/{ record.id }/brief">set now</a>)
      </p>
      <p if="{ !record.brief.preferred_start && currentAccount.isProfessional}">
        N/A
      </p>
    </div>
  </div>

  <h3>Address</h3>
    <address if="{ !isAllValuesEmpty(record.address) }" class="mb3">
      { record.address.street_address }
      { record.address.city }, { record.address.postcode }
    </address>
    <p if="{ isAllValuesEmpty(record.address) && !currentAccount.isProfessional}">
      You have not defined the address yet (<a href="/app/projects/{ record.id }/brief">fix now</a>)
    </p>
    <p if="{ isAllValuesEmpty(record.address) && currentAccount.isProfessional}">
      N/A
    </p>
  </div>

  <script>
  this.mixin('adminForm')
  </script>
</r-admin-project-form-overview>

<r-admin-project-form-brief>
  <form name="form" class="edit_project" onsubmit="{ submit }" autocomplete="off">

    <label for="account_id">Account</label>
    <input type="hidden" name="account_id" value="{record.account_id}">
    <r-typeahead-input resource="accounts" api="{ opts.api }" id="{record.account_id}" datum_tokenizer="{['email']}"></r-typeahead-input>
    <span if="{errors.account_id}" class="inline-error">{errors.account_id}</span>

    <label for="name">Name</label>
    <input id="name" class="block col-12 mb2 field"
    type="text" name="name" value="{record.name}"
    oninput="{setValue}"/>

    <section class="container clearfix" data-step="1">
      <div class="container">
        <h2>Mission</h2>
        <div class="clearfix border">
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
        //this.closeModal()
      })
    }else{

      // stash uploaded assets to be assigned to project
      assetsToAssign = _.pluck(this.record.assets, 'id')

      this.opts.api[this.opts.resource].create(data)
      .fail(this.errorHandler)
      .then(record => {
        this.update({record: record, busy:false})
        this.opts.id = record.id
        history.pushState(null, null, `/app/admin/${this.opts.resource}/${record.id}/edit`)

        // got some uploads, let's assign them to project
        if( !_.isEmpty(assetsToAssign) ) {
          this.request({url: `/api/projects/${record.id}/assets`, type: 'post', data: {ids: assetsToAssign}})
          .fail(() => {
            this.update({busy:false})
            window.alert(this.ERRORS.ASSET_ASSIGNMENT)
            //this.closeModal()
          })
          .then(() => {
            this.update({busy:false})
            //this.closeModal()
          })
        } else {
          //this.closeModal()
        }

      })
    }
  }
  this.mixin('adminForm')
  </script>
</r-admin-project-form-brief>

<r-admin-project-form-docs>
  <h2 class="mt0">Documents and Photos</h2>
  <div class="clearfix mxn2">
    <div class="sm-col sm-col-12 px2 mb2">
      <p class="h2">Upload plans, documents, site photos or any other files about your project</p>
      <r-files-input-with-preview name="assets" record="{record}"></r-files-input-with-preview>
    </div>
  </div>
  <script>
  this.mixin('adminForm')
  </script>
</r-admin-project-form-docs>

<r-admin-project-form-team>
  <h2 class="mt0">Team</h2>
  <r-typeahead-input resource="accounts" api="{ opts.api }" datum_tokenizer="{['full_name', 'email', 'user_type']}"></r-typeahead-input>

  <ul class="list-reset clearfix mxn1">

    <li each="{record.customers}" class="sm-col sm-col-6 p1 align-top">
      <div class="px2 border">
        <h3 class="inline-block">{ getName() }</h3>
        <span class="inline-block align-middle h6 mb1 px1 border pill bg-lime navy right mt2">Customer</span>
        <p class="overflow-hidden">
          <div><i class="fa fa-phone"></i> { profile.phone_number }</div>
          <div><i class="fa fa-envelope"></i> { email }</div>
        </p>
      </div>
      <a onclick="{removeCustomer}" class="btn btn-small bg-red white">Remove</a>
    </li>

    <li each="{record.shortlist}" class="sm-col sm-col-6 p1 align-top">
      <div class="px2 border">
        <h3 class="inline-block">{ getName() }</h3>
        <span class="inline-block align-middle h6 mb1 px1 border pill bg-aqua blue white right mt2">Professional</span>
        <p class="overflow-hidden">
          <div><i class="fa fa-phone"></i> { profile.phone_number }</div>
          <div><i class="fa fa-envelope"></i> { email }</div>
          <div if="{profile.website}"><i  class="fa fa-world"></i>{ profile.website }</div>
        </p>
      </div>
      <a onclick="{removeShortlist}" class="btn btn-small bg-red white">Remove</a>
    </li>

    <li each="{record.professionals}" class="sm-col sm-col-6 p1 align-top">
      <div class="px2 border">
        <h3 class="inline-block">{ getName() }</h3>
        <span class="inline-block align-middle h6 mb1 px1 border pill bg-aqua blue white right mt2">Professional</span>
        <p class="overflow-hidden">
          <div><i class="fa fa-phone"></i> { profile.phone_number }</div>
          <div><i class="fa fa-envelope"></i> { email }</div>
          <div if="{profile.website}"><i  class="fa fa-world"></i>{ profile.website }</div>
        </p>
      </div>
      <a onclick="{removeProfessional}" class="btn btn-small bg-red white">Remove</a>
    </li>

    <li each="{record.administrators}" class="sm-col sm-col-6 p1 align-top">
      <div class="px2 border">
        <h3 class="inline-block">{ getName() }</h3>
        <span class="inline-block align-middle h6 mb1 px1 border pill right mt2">Admin</span>
        <p class="overflow-hidden">
          <div><i class="fa fa-phone"></i> { profile.phone_number }</div>
          <div><i class="fa fa-envelope"></i> { email }</div>
        </p>
      </div>
      <a onclick="{removeAdministrator}" class="btn btn-small bg-red white">Remove</a>
    </li>

  </ul>


  <div class="clearfix mxn1">
    <div class="sm-col sm-col-6 px1 mb2">
      <form name="form" class="sm-col-12 px2 border" onsubmit="{submit}">
        <h3><i class="fa fa-paper-plane-o"></i> Invite a new member</h3>
        <div class="clearfix">
          <label class="inline-block col col-6 mb2 truncate">
            <input type="radio" name="invitee_attributes[user_type]" value="Customer">Customer
          </label>
          <label class="inline-block col col-6 mb2 truncate">
            <input type="radio" name="invitee_attributes[user_type]" value="Professional">Professional
          </label>
        </div>
        <span class="inline-error block" if="{errors['invitee_attributes.user_type']}">{errors['invitee_attributes.user_type']}</span>
        <input type="email" name="invitee_attributes[email]" class="col-12 mb2 field" placeholder="Email"/>
        <span class="inline-error" if="{errors['invitee_attributes.email']}">{errors['invitee_attributes.email']}</span>
        <input type="hidden" name="inviter_id" value="{opts.api.currentAccount.id}">
        <input type="hidden" name="project_id" value="{opts.id}">
        <div class="right-align">
          <button type="submit" class="btn btn-primary mb2 {busy: busy}">Invite</button>
        </div>
      </form>
    </div>

    <div if="{record.professionals.length > 0}" class="sm-col sm-col-6 px1 mb2">
      <r-project-appointments record="{record}"></r-project-appointments>
    </div>
  </div>
  <script>
  this.tags['r-typeahead-input'].on('itemselected', (item) => {
    var coll = item.user_type.plural().toLowerCase()
    coll = coll == 'professionals' ? 'shortlist'  : coll
    if (this.record[`${coll}_ids`].indexOf(item.id) < 0) {
      this.record[`${coll}_ids`].push(item.id)
      this.opts.api.projects.update(this.record.id, this.record)
      .fail(this.errorHandler)
      .then(() => {
        $(this.tags['r-typeahead-input'].query).typeahead('val', null)
        this.opts.api.projects.show(this.record.id)
      })
    }
  })
  this.removeCustomer = (e) => {
    this.removeFromMembership('customers_ids', 'customers', e)
  }
  this.removeShortlist = (e) => {
    this.removeFromMembership('shortlist_ids', 'shortlist', e)
  }
  this.removeProfessional = (e) => {
    this.removeFromMembership('professionals_ids', 'professionals', e)
  }
  this.removeAdministrator = (e) => {
    this.removeFromMembership('administrators_ids', 'administrators', e)
  }
  this.removeFromMembership = (id_coll, coll, e) => {
    var index
    e.preventDefault()
    // confirm
    if (window.confirm(this.ERRORS.CONFIRM_DELETE) ) {
      // find index
      index = this.record[id_coll].indexOf(e.item.id)
      if (index > -1) {
        // remove from id list and push updates to api
        this.record[id_coll].splice(index, 1)
        this.opts.api.projects.update(this.record.id, this.record)
        .fail(this.errorHandler)
        .then(() => {
          // remove from visible list when api returns success
          index = _.findIndex(this.record[coll], c => c.id == e.item.id)
          this.record[coll].splice(index, 1)
          // update DOM view
          this.update()
        })
      }
    }
  }
  this.mixin('teamTab')
  this.mixin('adminForm')
  </script>
</r-admin-project-form-team>

<r-admin-project-form-quotes>
</r-admin-project-form-quotes>


<r-admin-project-form>
  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>

  <div class="container">
    <div class="py3 px2">
      <div class="clearfix mxn2">

        <r-subnav links="{subnavLinks}" tab="{opts.tab}" ></r-subnav>
        <div class="sm-col sm-col-9 sm-px2">
            <r-tabs tab="{opts.tab}"
            api="{opts.api}"
            resource="{opts.resource}"
            content_opts="{opts.contentOpts}">
          </r-tabs>
        </div>

      </div>
    </div>
  </div>

  <script>
  this.opts.contentOpts = _.extend(this.opts.contentOpts || {}, this.opts)
  this.subnavLinks = [
    {href: `/app/admin/projects/${opts.id}/edit/overview`, name: 'overview', tag: 'r-admin-project-form-overview'},
    {href: `/app/admin/projects/${opts.id}/edit/brief`, name: 'brief', tag: 'r-admin-project-form-brief'},
    {href: `/app/admin/projects/${opts.id}/edit/docs`, name: 'docs', tag: 'r-admin-project-form-docs'},
    {href: `/app/admin/projects/${opts.id}/edit/team`, name: 'team', tag: 'r-admin-project-form-team'},
    {href: `/app/admin/projects/${opts.id}/edit/quotes`, name: 'quotes', tag: 'r-admin-project-form-quotes'}
  ]

  </script>

</r-admin-project-form>
