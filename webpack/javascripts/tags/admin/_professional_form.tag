<r-admin-professional-form>
  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>

  <div class="container p2">
  <h2 class="center mt0 mb2">{opts.id ? 'Editing' : 'Creating'} { opts.resource.singular().humanize() }</h2>

  <form name="form" class="sm-col-12 left-align" onsubmit="{ submit }" >

    <div each="{attr, i in ['profile', 'notifications']}">
      <div if="{attr != 'id'}">
      <label for="{attr}">{attr.humanize()}</label>
      <textarea if="{_.isObject(record[attr])}" class="block col-12 mb2 field fixed-height" name="{attr}:object">{JSON.stringify(record[attr], null, 2)}</textarea>
      <input  if="{!_.isObject(record[attr])}" class="block col-12 mb2 field"
      type="text" name="{attr}" value="{record[attr]}"/>
      <span if="{errors[attr]}" class="inline-error">{errors[attr]}</span>
      </div>
    </div>

    <button type="submit" class="block col-12 mb2 btn btn-big btn-primary {busy: busy}">Save</button>

  </form>
  </div>

  <script>
  this.mixin('adminForm')
  </script>

</r-admin-professional-form>
