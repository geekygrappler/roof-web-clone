import from '../../mixins/typeahead.js'
import from '../../mixins/tender.js'

<r-tender-item-input>
  <div class="relative">
    <form onsubmit="{ preventSubmit }">
      <input name="query" type="text" class="block col-12 field"
      oninput="{ search }" onkeyup="{ onKey }"
      placeholder="Search and add {modelName}" autocomplete="off" />
    </form>
    <i class="fa fa-{ opts.icon } absolute right-0 top-0 p1"></i>
    <ul name="list" if="{ data.length > 0}" class="col-12 list-reset absolute overflow-auto border bg-white z2" style="max-height:10rem">
      <li each="{ data }" class="border-bottom typeahead-item {'cursor': isCursor(this)}" onmouseover="{ moveCursor }">
        <a class="cursor-pointer p2" onclick="{ selectItem }">{ name }</a>
      </li>
    </ul>
  </div>

  <script>
  this.index = -1
  this.identifier = 'id'
  this.apiMethod = 'post'
  this.apiPath = `/api/${this.opts.name.plural()}/search`
  this.modelName = this.opts.name

  this.getDefaultItem = (name) => {
    let item
    if (opts.name === 'task') {
      item = {
        name: name,
        action: 'Other',
        group: 'Other',
        quantity: 1,
        price: 0,
        unit: 'unitless'
      }
    } else if (opts.name === 'material') {
      item = {
        name: name,
        quantity: 1,
        price: 0,
        supplied: false
      }
    }
    return item
  }

  this.mixin('typeaheadMixin')

  if (this.opts.auto_focus) {
    this.on('mount', () => {
      _.defer( () => this.query.focus() )
    })
  }
  </script>
</r-tender-item-input>

<r-tender-item>
  <li>
  <div class="clearfix animate py1 border-bottom">
    <div if="{ parent.headers.name }" class="sm-col sm-col-{ parent.headers.name } mb1 sm-mb0">
      { name }
      <hr class="sm-hide">
    </div>

    <div if="{ parent.headers.quantity }" class="col sm-col-{ parent.headers.quantity } col-3">
      <input type="number" name="quantity" value="{ quantity }" min="0"
      class="fit field inline-input center" oninput="{ input }" />
    </div>

    <div if="{ parent.headers.price }" class="col sm-col-{ parent.headers.price } col-{parent.opts.name == 'task' ? 3 : 2} center">
      <input type="number" name="price" value="{ parent.opts.name == 'task' ? price : (supplied ? price : 0) }"
      disabled="{ parent.opts.name == 'material' && !supplied }" min="0" class="fit field inline-input center" oninput="{ input }" />
    </div>

    <div if="{ parent.headers.total_cost }" class="col sm-col-{ parent.headers.total_cost } col-3 center">
      { this.formatCurrency(parent.opts.name == 'task' ? (price * quantity) : (supplied ? price * quantity : '0')) }
    </div>

    <div if="{ parent.headers.supplied }" class="col sm-col-{ parent.headers.supplied } col-1 center">
      <input if="{ parent.opts.name == 'material'}" type="checkbox" name="supplied"
      checked="{ supplied }" class="align-middle" onchange="{ input }" />
    </div>

    <div if="{ parent.headers.actions }" class="col sm-col-{ parent.headers.actions } col-2 center">
      <a href="#" class="btn btn-small navy" onclick="{ removeItem }"><i class="fa fa-trash-o"></i></a>
    </div>
  </div>
  </li>

  <script>
  this.on('mount', () => {
    $('.animate', this.root).animateCss('bounceIn')
  })

  this.input = (e) => {
    e.item[e.target.name] = e.target.type === 'checkbox' ? e.target.checked : parseInt(e.target.value)
    this.update()
    this.opts.api.tenders.trigger('update')
  }

  this.removeItem = (e) => {
    $('.animate', this.root).one($.animationEnd, () => {
      this.parent.opts.onitemremoved(e, this.parent.opts.name)
    } ).animateCss('bounceOut')
  }
  </script>
</r-tender-item>

<r-tender-item-group>
  <ul class="list-reset ml2 mb3">
    <li>
      <h4 class="mb1">{ group.humanize() }</h4>
      <ul class="list-reset ml2">
        <li class="sm-show">
          <div class="clearfix py1 border-bottom">
            <div each="{ name, width in headers }" class="sm-col sm-col-{width} {center: name != 'name'} mb1 sm-mb0 truncate">
              { name.humanize() }
            </div>
          </div>
        </li>

        <r-tender-item each="{ items }"></r-tender-item>

      </ul>
    </li>
  </ul>
  <script>
  this.headers = this.opts.headers
  </script>
</r-tender-item-group>


<r-tender-section>
  <div data-disclosure>
    <h3 data-handle class="cursor-pointer inline-block" onclick="{ changeIcon }">
      <i class="fa fa-{ icon } mr1"></i>{ section.name.humanize() }</h3>
    <div data-details>

      <r-tender-item-group
        name="task"
        each="{ group, items in section.tasks_by_action }"
        headers="{ parent.headers.task }"
        onitemremoved="{ removeItem }">
      </r-tender-item-group>

      <r-tender-item-group
        name="material"
        if="{ section.materials && section.materials.length > 0 }"
        each="{ group, items in section.materials_by_group }"
        headers="{ parent.headers.material }"
        onitemremoved="{ removeItem }">
      </r-tender-item-group>

      <div class="clearfix mxn1">
        <div class="col col-6 px1">
          <r-tender-item-input name="task" auto_focus="{ true }" api="{ parent.opts.api }" icon="tasks" ></r-tender-item-input>
        </div>
        <div class="col col-6 px1">
          <r-tender-item-input name="material" api="{ parent.opts.api }" icon="shopping-basket" ></r-tender-item-input>
        </div>
      </div>
    </div>
  </div>

  <script>
  this.showDisclosures = true
  this.icon = 'folder-open-o'

  this.changeIcon = (e) => {
    this.icon = $('[data-details]', this.root).hasClass('display-none') ? 'folder-open-o' : 'folder-o'
  }
  // this.on('mount', () => {
  //   _.each(this.$disclosures, disc => $(disc).show())
  // })
  this.on('update', () => {
    if (this.section) {
      this.section.tasks_by_action = _.groupBy(this.section.tasks, (item) => item.action)
      this.section.materials_by_group = {materials: this.section.materials}
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
    let index = _.findIndex(this.section[name], {id: e.item.id})
    this.section[name].splice(index, 1)
    this.update()
    this.opts.api.tenders.trigger('update')
  }

  </script>
</r-tender-section>

<r-tenders-form>

  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>

  <div class="container p2">
    <h1>{ opts.id ? 'Editing Tender ' + opts.id : 'New Tender' }</h1>

    <r-tender-section each="{ section , i in tender.document.sections }" ></r-tender-section>

    <form if="{ tender.document }" onsubmit="{ addSection }" class="mt3 py3 clearfix mxn1 border-top">
      <div class="col col-8 px1">
        <input type="text" name="sectionName" placeholder="Section name" class="block col-12 field" />
      </div>
      <div class="col col-4 px1">
        <button type="submit" class="block col-12 btn btn-primary"><i class="fa fa-puzzle-piece"></i> Add Section</button>
      </div>
    </form>

    <h3 class="right-align m0 py3">Estimated total: { tenderTotal() }</h3>

    <form name="form" onsubmit="{ submit }" class="right-align">

      <div if="{errors}" id="error_explanation" class="left-align">
        <ul>
          <li each="{field, messsages in errors}"> <strong>{field.humanize()}</strong> {messsages} </li>
        </ul>
      </div>

      <button type="submit" class="btn btn-primary btn-big {busy: busy}">Save</button>
    </form>
  </div>
  <script>
    this.headers = {
      task: {name: 7, quantity: 3, actions: 2},
      material: {name: 7, quantity: 3, actions: 2}
    }

    if (opts.id) {
      opts.api.projects.on('show.success', project => {
        this.update({tender: project.tender})
      })
      opts.api.tenders.on('show.success', tender => {
        this.update({tender: tender})
      })
    } else {
      this.tender = {project_id: this.opts.project_id, document: {sections: []}}
    }

    this.submit = (e) => {
      if (e) e.preventDefault()

      this.update({busy: true})

      if (this.opts.id) {
        this.opts.api.tenders.update(opts.id, this.tender)
        .fail(this.errorHandler)
        .then(id => this.update({busy:false}))
      }else{
        this.opts.api.tenders.create(this.tender)
        .fail(this.errorHandler)
        .then(tender => {
          this.update({busy:false})
          this.opts.id = tender.id
          history.pushState(null, null, `/app/projects/${tender.project_id}/tenders/${tender.id}`)
        })
      }
    }

    this.mixin('tenderMixin')
    this.mixin('projectTab')
  </script>
</r-tenders-form>
