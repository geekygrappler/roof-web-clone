let taskActions = require("json!../../data/task_actions.json")

<r-tender-section>
  <div data-disclosure>
    <div class="relative border-bottom mt2">
      <h3 class="block overflow-hidden mb0">
        <i data-handle class="absolute left-0 top-0 mt1 cursor-pointer fa fa-{ icon }" onclick="{changeIcon}"></i>
        <input type="text" class="block col-12 field border-none tender-section-name h3"
        value="{ section.name.humanize() }" oninput="{renameSection}">
      </h3>
      <a class="absolute right-0 top-0 btn btn-small border-red red" onclick="{removeSection}"><i class="fa fa-trash-o"></i></a>
    </div>
    <div data-details>

      <r-tender-item-group
        name="task"
        task_actions="{taskActions}"
        groupitems="{section.tasks_by_action}"
        each="{ group, items in section.tasks_by_action }"
        headers="{ parent.headers.task }"
        onitemremoved="{ removeItem }">
      </r-tender-item-group>

      <r-tender-item-group
        name="material"
        task_actions="{taskActions}"
        groupitems="{section.materials_by_group}"
        show="{ section.materials && section.materials.length > 0 }"
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
    <h3 class="right-align">{section.name}: { sectionTotal(section, true) }</h3>
  </div>

  <script>
  this.taskActions = _.omit(taskActions, 'Materials', 'VAT')
  this.showDisclosures = true
  this.icon = 'plus-square-o'

  this.changeIcon = (e) => {
    this.icon = $('[data-details]', this.root).hasClass('display-none') ? 'plus-square-o' : 'minus-square-o'
  }

  this.on('update', () => {
    if (this.section) {
      var grouped = _.groupBy(this.section.tasks, (item) => item.action)
      this.section.tasks_by_action = _.groupBy(_.flatten(_.sortBy(grouped, (list, group) => {
        return _.indexOf(_.keys(this.taskActions), group)
      })),(item) => item.action)
      this.section.materials_by_group = {materials: this.section.materials}
      this.opts.api.tenders.trigger('update')
    }
  })

  this.tags.task.on('itemselected', (item) => {
    this.section.tasks = this.section.tasks || []
    let index = _.findIndex(this.section.tasks, task => task.id == item.id )
    if (index < 0 || typeof item.id === 'undefined') {
      this.section.tasks.push(item)
      this.update()
    }
  })
  this.tags.material.on('itemselected', (item) => {
    this.section.materials = this.section.materials || []
    let index = _.findIndex(this.section.materials, mat => mat.id == mat.id )
    if (index < 0 || typeof item.id === 'undefined') {
      this.section.materials.push(item)
      this.update()
    }
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
