<r-admin-account-form>
  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>

  <div class="container p2">
    <h2 class="center mt0 mb2">{opts.id ? 'Editing' : 'Creating'} { opts.resource.singular().humanize() }</h2>

    <form name="form" class="sm-col-12 left-align" onsubmit="{ submit }" >

      <label for="email">Email</label>
      <input class="block col-12 mb2 field"
      type="text" name="email" value="{record['email']}"/>
      <span if="{errors['email']}" class="inline-error">{errors['email']}</span>

      <label for="password">Password</label>
      <input class="block col-12 mb2 field"
      type="password" name="password" value="{record['password']}"/>
      <span if="{errors['password']}" class="inline-error">{errors['password']}</span>

      <label for="user_attributes[type]">Type</label>
      <select class="block col-12 mb2 field"
      type="text" name="user_attributes[type]" value="{record['user']['type']}" readonly="{record.id}" disabled="{record.id}">
      <option></option>
      <option value="Customer" selected="{record['user_type'] == 'Customer'}">Customer</option>
      <option value="Professional" selected="{record['user_type'] == 'Professional'}">Professional</option>
      <option value="Administrator" selected="{record['user_type'] == 'Administrator'}">Administrator</option>
      </select>
      <span if="{errors['user']['type']}" class="inline-error">{errors['user']['type']}</span>

      <label for="user_attributes[profile][first_name]">First Name</label>
      <input class="block col-12 mb2 field"
      type="text" name="user_attributes[profile][first_name]" value="{record['profile']['first_name']}"/>
      <span if="{errors['user.profile.first_name']}" class="inline-error">{errors['user.profile.first_name']}</span>

      <label for="user_attributes[profile][last_name]">Last Name</label>
      <input class="block col-12 mb2 field"
      type="text" name="user_attributes[profile][last_name]" value="{record['profile']['last_name']}"/>
      <span if="{errors['user.profile.last_name']}" class="inline-error">{errors['user.profile.last_name']}</span>

      <label for="user_attributes[profile][phone_number]">Phone Number</label>
      <input class="block col-12 mb2 field"
      type="text" name="user_attributes[profile][phone_number]" value="{record['profile']['phone_number']}"/>
      <span if="{errors['user.profile.phone_number']}" class="inline-error">{errors['user.profile.phone_number']}</span>

      <button type="submit" class="block col-12 mb2 btn btn-big btn-primary {busy: busy}">Save</button>

    </form>
  </div>

  <script>
  this.mixin('adminForm')
  </script>

</r-admin-account-form>
