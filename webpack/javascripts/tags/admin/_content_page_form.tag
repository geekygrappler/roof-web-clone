<r-admin-content-page-form>
  <h2 class="center mt0 mb2">{ opts.resource.humanize() }</h2>

  <form name="form" class="sm-col-12 left-align" onsubmit="{ submit }" autocomplete="off">

    <label for="first_name">Pathname</label>
    <input class="block col-12 mb2 field"
    type="text" name="pathname" value="{record['pathname']}"/>
    <span if="{errors['pathname']}" class="inline-error">{errors['pathname']}</span>

    <label for="first_name">Body</label>
    <textarea class="block col-12 mb2 field code"
    name="body">{record['Body']}</textarea>
    <span if="{errors['Body']}" class="inline-error">{errors['Body']}</span>

    <button type="submit" class="block col-12 mb2 btn btn-big btn-primary {busy: busy}">Save</button>

  </form>
  <script>
  this.mixin('adminForm')
  this.mixin('codeMirror')
  </script>
</r-admin-content-page-form>
