<r-admin-lead-form>
  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>

  <div class="container p2">
  <h2 class="center mt0 mb2">{opts.id ? 'Editing' : 'Creating'} { opts.resource.singular().humanize() }</h2>

  <form name="form" class="sm-col-12 left-align" onsubmit="{ submit }" autocomplete="off">

    <label for="first_name">First Name</label>
    <input class="block col-12 mb2 field"
    type="text" name="first_name" value="{record['first_name']}"/>
    <span if="{errors['first_name']}" class="inline-error">{errors['first_name']}</span>

    <label for="last_name">Last Name</label>
    <input class="block col-12 mb2 field"
    type="text" name="last_name" value="{record['last_name']}"/>
    <span if="{errors['last_name']}" class="inline-error">{errors['last_name']}</span>

    <label for="phone_number">Phone Number</label>
    <input class="block col-12 mb2 field"
    type="text" name="phone_number" value="{record['phone_number']}"/>
    <span if="{errors['phone_number']}" class="inline-error">{errors['phone_number']}</span>

    <label for="meta">Meta</label>
    <textarea class="block col-12 mb2 field fixed-height" name="meta:object">{JSON.stringify(record['meta'], null, 2)}</textarea>

    <h3>Convert</h3>
    <p>Fill below fields if you want to convert Lead to a Customer, leave empty otherwise</p>
    <label for="email">Email</label>
    <input class="block col-12 mb2 field"
    type="text" name="email" value="{record['email']}" autocomplete="off"/>
    <span if="{errors['email']}" class="inline-error">{errors['email']}</span>

    <label for="password">Password</label>
    <input class="block col-12 mb2 field"
    type="password" name="password" value="{record['password']}" autocomplete="off"/>
    <span if="{errors['password']}" class="inline-error">{errors['password']}</span>

    <button type="submit" class="block col-12 mb2 btn btn-big btn-primary {busy: busy}">Save</button>

  </form>
  </div>

  <script>
  this.mixin('adminForm')
  </script>

</r-admin-lead-form>
