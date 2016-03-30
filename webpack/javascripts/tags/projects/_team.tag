import '../../mixins/team_tab.js'
<r-project-team>

  <h2 class="mt0">Team</h2>

  <r-typeahead-input if="{currentAccount.isAdministrator}" resource="accounts" api="{ opts.api }" datum_tokenizer="{['full_name', 'email', 'user_type']}"></r-typeahead-input>

  <p>Here is the team of your project. You can arrange site visits with professionals
    here or invite other members such as family members or your own builders.
  </p>

  <ul class="list-reset clearfix mxn1">

    <li each="{project.customers}" class="sm-col sm-col-6 p1 align-top">
      <div class="px2 border">
        <h3 class="inline-block">{ getName() }</h3>
        <span class="inline-block align-middle h6 mb1 px1 border pill bg-lime navy right mt2">Customer</span>
        <p class="overflow-hidden">
          <div><i class="fa fa-phone"></i> { profile.phone_number }</div>
          <div><i class="fa fa-envelope"></i> { email }</div>
        </p>
      </div>
      <div if="{currentAccount.isAdministrator}">
        <a onclick="{removeCustomer}" class="btn btn-small bg-red white">Remove</a>
        <a onclick="{impersonate}" class="btn btn-small bg-red white">Impersonate</a>
      </div>
    </li>

    <li each="{project.shortlist}" class="sm-col sm-col-6 p1 align-top">
      <div class="px2 border">
        <h3 class="inline-block">{ getName() }</h3>
        <span class="inline-block align-middle h6 mb1 px1 border pill bg-aqua blue white right mt2">Professional</span>
        <p class="overflow-hidden">
          <div><i class="fa fa-phone"></i> { profile.phone_number }</div>
          <div><i class="fa fa-envelope"></i> { email }</div>
          <div if="{profile.website}"><i  class="fa fa-world"></i>{ profile.website }</div>
        </p>
      </div>
      <div if="{currentAccount.isAdministrator}">
        <a onclick="{removeShortlist}" class="btn btn-small bg-red white">Remove</a>
        <a onclick="{impersonate}" class="btn btn-small bg-red white">Impersonate</a>
      </div>
    </li>

    <li each="{project.professionals}" class="sm-col sm-col-6 p1 align-top">
      <div class="px2 border">
        <h3 class="inline-block">{ getName() }</h3>
        <span class="inline-block align-middle h6 mb1 px1 border pill bg-aqua blue white right mt2">Professional *</span>
        <p class="overflow-hidden">
          <div><i class="fa fa-phone"></i> { profile.phone_number }</div>
          <div><i class="fa fa-envelope"></i> { email }</div>
          <div if="{profile.website}"><i  class="fa fa-world"></i>{ profile.website }</div>
        </p>
      </div>
      <div if="{currentAccount.isAdministrator}">
        <a onclick="{removeProfessional}" class="btn btn-small bg-red white">Remove</a>
        <a onclick="{impersonate}" class="btn btn-small bg-red white">Impersonate</a>
      </div>
    </li>

    <li each="{project.administrators}" class="sm-col sm-col-6 p1 align-top">
      <div class="px2 border">
        <h3 class="inline-block">{ getName() }</h3>
        <span class="inline-block align-middle h6 mb1 px1 border pill right mt2">Admin</span>
        <p class="overflow-hidden">
          <div><i class="fa fa-phone"></i> { profile.phone_number }</div>
          <div><i class="fa fa-envelope"></i> { email }</div>
        </p>
      </div>
      <div if="{currentAccount.isAdministrator}">
        <a onclick="{removeAdministrator}" class="btn btn-small bg-red white">Remove</a>
        <a onclick="{impersonate}" class="btn btn-small bg-red white">Impersonate</a>
      </div>
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

    <div if="{project.professionals.length > 0}" class="sm-col sm-col-6 px1 mb2">
      <r-project-appointments record="{project}"></r-project-appointments>
    </div>
  </div>


  <script>
  if (this.currentAccount.isAdministrator) {
    this.tags['r-typeahead-input'].on('itemselected', (item) => {
      var coll = item.user_type.plural().toLowerCase()
      coll = coll == 'professionals' ? 'shortlist'  : coll
      if (this.project[`${coll}_ids`].indexOf(item.id) < 0) {
        this.project[`${coll}_ids`].push(item.id)
        this.opts.api.projects.update(this.project.id, this.project)
        .fail(this.errorHandler)
        .then(() => {
          $(this.tags['r-typeahead-input'].query).typeahead('val', null)
          this.opts.api.projects.show(this.project.id)
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
        index = this.project[id_coll].indexOf(e.item.id)
        if (index > -1) {
          // remove from id list and push updates to api
          this.project[id_coll].splice(index, 1)
          if (this.project[id_coll] == null) this.project[id_coll] = []
          this.opts.api.projects.update(this.project.id, this.project)
          .fail(this.errorHandler)
          .then(() => {
            // remove from visible list when api returns success
            index = _.findIndex(this.project[coll], c => c.id == e.item.id)
            this.project[coll].splice(index, 1)
            // update DOM view
            this.update()
          })
        }
      }
    }
    this.impersonate = (e) => {
      e.preventDefault()
      this.opts.api.sessions.impersonate({id: e.item.id})
    }
  }

  this.mixin('teamTab')
  this.mixin('projectTab')
  </script>
</r-project-team>
