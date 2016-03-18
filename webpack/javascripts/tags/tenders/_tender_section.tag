<r-tender-section>
  <div data-disclosure>
    <div class="border-bottom mt2">
      <h3 class="inline-block mb0" >
        <i data-handle class="cursor-pointer fa fa-{ icon } mr1" onclick="{changeIcon}"></i>
        <input type="text" class="field border-none"
        value="{ section.name.humanize() }" oninput="{renameSection}">
      </h3>
      <a class="btn btn-small right mt2" onclick="{removeSection}"><i class="fa fa-trash-o"></i></a>
    </div>
    <div data-details>

      <r-tender-item-group
        name="task"
        groupitems="{section.tasks_by_action}"
        each="{ group, items in section.tasks_by_action }"
        headers="{ parent.headers.task }"
        onitemremoved="{ removeItem }">
      </r-tender-item-group>

      <r-tender-item-group
        name="material"
        groupitems="{section.materials_by_group}"
        if="{ section.materials && section.materials.length > 0 }"
        each="{ group, items in section.materials_by_group }"
        headers="{ parent.headers.material }"
        onitemremoved="{ removeItem }">
      </r-tender-item-group>

      <div class="clearfix mxn1 mt2">
        <div class="col col-6 px1">
          <r-tender-item-input name="task" auto_focus="{ true }" api="{ parent.opts.api }" icon="tasks" ></r-tender-item-input>
        </div>
        <div class="col col-6 px1">
          <r-tender-item-input name="material" api="{ parent.opts.api }" icon="shopping-basket" ></r-tender-item-input>
        </div>
      </div>

    </div>
    <h4 class="right-align">Section total: { sectionTotal(section, true) }</h4>
  </div>

  <script>
  this.showDisclosures = true
  this.icon = 'folder-open-o'

  this.changeIcon = (e) => {
    this.icon = $('[data-details]', this.root).hasClass('display-none') ? 'folder-open-o' : 'folder-o'
  }

  this.on('update', () => {
    if (this.section) {
      this.section.tasks_by_action = _.groupBy(this.section.tasks, (item) => item.action)
      this.section.materials_by_group = {materials: this.section.materials}
      this.opts.api.tenders.trigger('update')
    }
  })

  this.tags.task.on('itemselected', (item) => {
    this.section.tasks = this.section.tasks || []
    this.section.tasks.push(item)
    this.update()
  })
  this.tags.material.on('itemselected', (item) => {
    this.section.materials = this.section.materials || []
    this.section.materials.push(item)
    this.update()
  })

  this.removeItem = (e, name) => {
    name = name.plural()
    let index = _.findIndex(this.section[name], itm => _.isEqual(itm, e.item) )
    this.section[name].splice(index, 1)
    this.update()
    this.opts.api.tenders.trigger('update')
  }

  this.renameSection = _.debounce((e) => {
    this.section.name = e.target.value
    this.update()
  })

  </script>
</r-tender-section>
