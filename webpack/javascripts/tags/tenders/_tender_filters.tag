
<r-tender-filters>
  <div class="overflow-auto nowrap mb1">
    <a class="btn btn-small {'btn-primary': section == null}" onclick="{setSectionFilter}">All</a>
    <a each="{opts.record.document.sections}" class="btn btn-small {'btn-primary': section == id}" onclick="{setSectionFilter}">{name}</a>
  </div>
  <div class="overflow-auto nowrap">
    <a class="btn btn-small {'btn-primary': action == null}" onclick="{setActionFilter}">All</a>
    <a each="{name in actions()}" class="btn btn-small {'btn-primary': action == name}" onclick="{setActionFilter}">{name}</a>
  </div>
  <script>
  this.actions = () => {
    return _.union(_.uniq(_.pluck(_.flatten(_.pluck(this.opts.record.document.sections, 'tasks')), 'action')), ['Materials'])
  }
  this.setSectionFilter = (e) => {
    this.update({section: e.item ? e.item.id : null})
  }
  this.setActionFilter = (e) => {
    this.update({action: e.item ? e.item.name : null})
  }
  </script>
</r-tender-filters>
