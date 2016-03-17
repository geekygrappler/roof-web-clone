<r-project-team>

  <h2 class="mt0">Team</h2>
  <p>Here is the team of your project. You can arrange site visits with professionals
    here or invite other members such as family members or your own builders.
  </p>

  <ul class="list-reset">
    <li each="{project.customers}" class="inline-block p1 col-4 align-top">
      <div class="px2 border">
        <h2 class="inline-block">{ getName() }</h2>
        <span class="inline-block align-middle h6 mb1 px1 border pill">Member</span>
        <p class="overflow-hidden">
          <i class="fa fa-phone"></i> { profile.phone_number }<br>
          <i class="fa fa-envelope"></i> { email }<br>
        </p>
      </div>
    </li>

    <li each="{project.professionals}" class="inline-block p1 align-top col-4 align-top">
      <div class="px2 border">
        <h2 class="inline-block">{ getName() }</h2>
        <span class="inline-block align-middle h6 mb1 px1 border pill">Professional</span>
        <p class="overflow-hidden">
          <i class="fa fa-phone"></i> { profile.phone_number }<br>
          <i class="fa fa-envelope"></i> { email }<br>
          <div if="{profile.website}"><i  class="fa fa-world"></i>{ profile.website }<br></div>
        </p>
      </div>
    </li>

    <li each="{project.administrators}" class="inline-block p1 col-4 align-top">
      <div class="px2 border">
        <h2 class="inline-block">{ getName() }</h2>
        <span class="inline-block align-middle h6 mb1 px1 border pill">Admin</span>
        <p class="overflow-hidden">
          <i class="fa fa-phone"></i> { profile.phone_number }<br>
          <i class="fa fa-envelope"></i> { email }<br>
        </p>
      </div>
    </li>


  </ul>

  <script>
  this.mixin('projectTab')
  this.getName = function () {
    return this.id !== this.opts.api.currentAccount.id ? this.fullName() : 'You'
  }
  this.fullName = function () {
    return `${this.profile.first_name} ${this.profile.last_name}`
  }
  </script>
</r-project-team>
