import '../../mixins/team_tab.js'
<r-project-team>

  <h2 class="mt0">Team</h2>
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
    </li>

    <li each="{project.professionals}" class="sm-col sm-col-6 p1 align-top">
      <div class="px2 border">
        <h3 class="inline-block">{ getName() }</h3>
        <span class="inline-block align-middle h6 mb1 px1 border pill bg-aqua blue white right mt2">Professional</span>
        <p class="overflow-hidden">
          <div><i class="fa fa-phone"></i> { profile.phone_number }</div>
          <div><i class="fa fa-envelope"></i> { email }</div>
          <div if="{profile.website}"><i  class="fa fa-world"></i>{ profile.website }</div>
        </p>
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
  this.mixin('teamTab')
  this.mixin('projectTab')
  </script>
</r-project-team>
