let taskActions = require("json!../../data/task_actions.json")

<r-tender-section>
  <div>

    <div class="relative border-bottom mt2">
      <h3 class="block overflow-hidden mb0">

        <a if="{section.dimensions && section.dimensions.length > 0}" class="h6 bg-teal gray rounded notification-badge" onclick="{setActivity}" rel="edit_dimensions_{section.id}">{section.dimensions.join('x')}</a>
        <a if="{!parent.opts.readonly && (!section.dimensions || section.dimensions.length == 0)}" onclick="{setActivity}" rel="edit_dimensions_{section.id}"><i class="fa fa-edit"></i></a>

        <input type="text" class="col-10 field border-none tender-section-name h3"
        value="{ section.name.humanize() }" oninput="{renameSection}">
      </h3>
      <a class="absolute right-0 top-0 btn btn-small border-red red" onclick="{removeSection}"><i class="fa fa-trash-o"></i></a>
    </div>
    <virtual if="{visible}">

      <r-tender-item-group
        name="task"
        groupitems="{section.tasks_by_action}"
        readonly="{parent.parent.opts.readonly}"
        each="{ group, items in section.tasks_by_action }"
        headers="{ parent.headers.task }"
        quote='{opts.quote}'
        onitemremoved="{ removeItem }" no-reorder>
      </r-tender-item-group>

      <r-tender-item-group
        name="material"
        if="{(filterAction == 'Materials' || !filterAction)}"
        readonly="{parent.parent.opts.readonly}"
        groupitems="{section.materials_by_group}"
        show="{ section.materials && section.materials.length > 0 }"
        each="{ group, items in section.materials_by_group }"
        quote='{opts.quote}'
        headers="{ parent.headers.material }"
        onitemremoved="{ removeItem }" no-reorder>
      </r-tender-item-group>

    </virtual>
    <div class="clearfix {'with-line': !visible}">
      <h3 class="right border p1 bg-white relative z2 section-total">{visible ? section.name + ':' : ''} { sectionTotal }</h3>
    </div>

    <div if="false" class="clearfix mxn1 mt2 mb3 hide">
      <div class="col col-6 px1">
        <r-tender-item-input name="task" auto_focus="{ true }" api="{ parent.opts.api }" icon="tasks" ></r-tender-item-input>
      </div>
      <div class="col col-6 px1">
        <r-tender-item-input name="material" api="{ parent.opts.api }" icon="shopping-basket" ></r-tender-item-input>
      </div>
    </div>

    <r-dialog if="{opts.api.activity == ('edit_dimensions_' + section.id)}" title="Edit Dimensions" >
      <form class="p2" onsubmit="{parent.updateDimensions}">
        <label>Section Dimensions</label>
        <r-area-calculator dimensions="{parent.section.dimensions}" callback="{preventSubmit}"></r-area-calculator>
        <div class="clearfix mt2 mxn2">
          <div class="col col-6 px2">
            <button class="block col-12 mb2 btn btn-primary">Save</button>
          </div>
        </div>
      </form>
    </r-dialog>

  </div>

  <script>
  this.taskActions = _.omit(taskActions, 'Materials', 'VAT')
  //this.showDisclosures = true
  this.visible = true

  this.updateDimensions = (e) => {
    this.section.dimensions = _.compact([parseInt(e.target.width.value), parseInt(e.target.height.value), parseInt(e.target.length.value)])
    this.unsetActivity()
    this.update()
  }

  this.updateSectionTotalLocal = () => {
    this.sectionTotal = this.calcSectionTotal(this.section, true)
  }

  this.updateSectionTotal = () => {
    this.updateSectionTotalLocal()
    this.parent.updateTenderTotal()
  }

  this.on('mount', () => {
    this.parent.tags['r-tender-filters'].on('update', this.updateSectionTotalLocal)
  })

  this.on('before-unmount', () => {
    this.parent.tags['r-tender-filters'] && this.parent.tags['r-tender-filters'].off('update', this.updateSectionTotalLocal)
  })

  this.on('update', () => {

    if (this.section) {
      this.filterAction = this.parent.tags['r-tender-filters'].action

      var tasks = _.isString(this.filterAction) ? _.filter(this.section.tasks, task => task.action == this.filterAction) : this.section.tasks
      var tasksWithDescription = _.map(tasks, (item) => {
        item.description = item.description ? item.description : ''
        return item
      })

      var grouped = _.groupBy(tasksWithDescription, (item) => item.action)
      this.section.tasks_by_action = _.groupBy(_.flatten(_.sortBy(grouped, (list, group) => {
        return _.indexOf(_.keys(this.taskActions), group)
      })),(item) => item.action)

      var materialsWithDescription = _.map(this.section.materials, (item) => {
        item.description = item.description ? item.description : ''
        return item
      })
      this.section.materials_by_group = {materials: materialsWithDescription}
      if (!this.sectionTotal) this.updateSectionTotal()
    }
  })

  this.itemselectedFn = function(item) {
      var sec = this.parent.currentScrolledSection.section
      sec.tasks = sec.tasks || []
      let index = _.findIndex(sec.tasks, task => task.id == item.id )
      if (index < 0 || typeof item.id === 'undefined') {
        sec.tasks.push(item)
        this.update()
        this.updateSectionTotal()
        this.opts.api.tenders.trigger('update')
      }
  }

  this.tags.task.on('itemselected', (item) => {
    this.itemselectedFn(item)
  })

  this.tags.material.on('itemselected', (item) => {
    this.section.materials = this.section.materials || []
    let index = _.findIndex(this.section.materials, mat => mat.id == mat.id )
    if (index < 0 || typeof item.id === 'undefined') {
      this.section.materials.push(item)
      this.update()
      this.updateSectionTotal()
      this.opts.api.tenders.trigger('update')
    }
  })

  this.removeItem = (e, name) => {
    name = name.plural()
    let index = _.findIndex(this.section[name], itm => _.isEqual(itm, e.item) )
    this.section[name].splice(index, 1)
    this.update()
    this.opts.api.tenders.trigger('update')
  }

  this.renameSection = (e) => {
    e.preventUpdate = true
    this.section.name = e.target.value
  }

  </script>
</r-tender-section>
