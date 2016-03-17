<r-option-group-input>
  <div each="{ field, i in opts.groups }" class="mb2">
    <label class="block">{ field.humanize() }</label>

    <label each="{ op, n in parent.opts.options }">
      <input type="radio" name="{getName(field)}" value="{ op }" checked="{ parent.opts.record[field] === op }"> { op.humanize() }
    </label>

  </div>
  <script>
  this.getName = (field) => {
    return opts.name ? `opts.name[${field}]` : field 
  }
  </script>
</r-option-group-input>
