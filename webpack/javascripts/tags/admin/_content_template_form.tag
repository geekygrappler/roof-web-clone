<r-admin-content-template-form>
  <h2 class="center mt0 mb2">{ opts.resource.humanize() }</h2>

  <form name="form" class="sm-col-12 left-align" onsubmit="{ submit }" autocomplete="off">

    <label for="first_name">Path</label>
    <input class="block col-12 mb2 field"
    type="text" name="path" value="{record['path']}"/>
    <span if="{errors['path']}" class="inline-error">{errors['path']}</span>

    <!-- as we are sticking with english, html and erb, no need to bother by displaying those inputs -->
    <input type="hidden" name="locale" value="en"/>
    <input type="hidden" name="format" value="html"/>
    <input type="hidden" name="handler" value="erb"/>

    <div class="mb2">
      <input type="hidden" name="partial" value="{record['partial']}"/>
      <label><input type="checkbox" checked="{record['partial']}" onchange="{setPartial}" /> Partial</label>
      <span if="{errors['partial']}" class="inline-error">{errors['partial']}</span>
    </div>

    <label for="first_name">Body</label>
    <textarea class="block col-12 mb2 field code"
    name="body">{record['Body']}</textarea>
    <span if="{errors['Body']}" class="inline-error">{errors['Body']}</span>

    <button type="submit" class="block col-12 mb2 btn btn-big btn-primary {busy: busy}">Save</button>

  </form>
  <script>
  this.setPartial = (e) => this.partial.value = e.target.checked
  this.mixin('adminForm')
  this.mixin('codeMirror')
  </script>
</r-admin-content-template-form>
