let taskActions = require("json!../../data/task_actions.json")
import './_comments.tag'

<r-tender-item-action-group-dropdown>
  <select onchange="{changeTaskAction}">
    <option each="{val, name in taskActions}" value="{val}" selected="{val == 'Other'}" no-reorder>{name}</option>
  </select>
  <script>
  this.taskActions = _.omit(taskActions, 'Materials', 'VAT')
  this.changeTaskAction = (e) => {
    e.item = this.opts.item
    this.opts.changeTaskAction(e)
    this.closeModal()
  }
  </script>
</r-tender-item-action-group-dropdown>

<r-tender-item>
  <li class="relative border-right">
    <!--<div if="{opts.border_cleaner}" class="border-cleaner absolute"></div>-->
    <div class="clearfix p1 border-bottom">
      <div if="{ parent.headers.name }" class="sm-col sm-col-{ parent.headers.name } mb1 sm-mb0">
        <input if="{this.parent.parent.type == 'Tender' || this.parent.parent.type == 'TenderTemplate'}" type="text" name="name" value="{ display_name || name }"
        class="fit field inline-input align-left col-12" oninput="{ inputname }"  />
        <label if="{this.parent.parent.type == 'Quote'}">{ display_name || name }</label>
        <br class="sm-hide">
      </div>

      <div if="{ parent.headers.description }" class="sm-col sm-col-{ parent.headers.description } mb1 sm-mb0">
        <input type="text" name="description" value="{ description }" placeholder="Description"
        class="fit field inline-input align-left col-12" oninput="{ inputdesc }" />
        <br class="sm-hide">
      </div>

      <div if="{ parent.headers.supplied }" class="col sm-col-{ parent.headers.supplied } col-1 center">
        <input if="{ parent.opts.name == 'material'}" type="checkbox" name="supplied"
        checked="{ supplied }" class="align-middle" onchange="{ input }" />
      </div>

      <div if="{ parent.headers.quantity }" class="col sm-col-{ parent.headers.quantity } col-3 center relative">
        <a if="{!parent.opts.readonly && ['Decorating','Lay'].indexOf(action) > -1}" rel="edit_dimensions_task_{id}_{name}" onclick="{setActivity}"><i class="fa fa-edit absolute left-0 top-0 z1 mt1 mr1 bg-white" ></i></a>
        <input type="number" name="quantity" value="{ quantity }" step="1" min="0"
        class="fit field inline-input center" oninput="{ input }" />
      </div>

      <div if="{ parent.headers.price }" class="col sm-col-{ parent.headers.price } col-{parent.opts.name == 'task' ? 3 : 2} center relative">
        <i if="{!parent.opts.readonly}" class="fa fa-gbp absolute left-0 top-0 z1 mt1 mr1 bg-white"></i><input if="{!parent.opts.readonly}" type="number" name="price" value="{ parent.opts.name == 'task' ? price / 100 : (supplied ? price / 100 : 0) }"
        disabled="{ parent.opts.name == 'material' && !supplied }" step="1" min="0" class="fit field inline-input center price" oninput="{ input }" />
        <label if="{parent.opts.readonly}">{ formatCurrency(parent.opts.name == 'task' ? price : (supplied ? price : 0)) }</label>
      </div>

      <div if="{ parent.headers.total_cost }" class="col sm-col-{ parent.headers.total_cost } col-3 center relative">
        <i if="{!parent.opts.readonly}" class="fa fa-gbp absolute left-0 top-0 z1 mt1 mr1 bg-white"></i><input if="{!parent.opts.readonly}" type="number" value="{parent.opts.name == 'task' ? (price / 100 * quantity) : (supplied ? price / 100 * quantity : '0')}"
        step="1" min="0" class="fit field inline-input center price" oninput="{ inputTotalCost }" >
        <label if="{parent.opts.readonly}">{ formatCurrency(parent.opts.name == 'task' ? (price * quantity) : (supplied ? price * quantity : '0'))}</label>
      </div>

      <div if="{ parent.headers.actions }" class="col sm-col-{ parent.headers.actions } col-2 center">
        <a href="#" class="btn btn-small border-red red mb1 sm-mb0" onclick="{ removeItem }" title="Delete"><i class="fa fa-trash-o"></i></a>
        <a href="#" if="{parent && parent.parent && parent.parent.record.id && this.parent.parent.type != 'TenderTemplate'}" class="btn btn-small border mb1 sm-mb0" onclick="{ openComments }" title="Comments"><i class="fa fa-comment-o"></i> [{getCommentsCount()}]</a>
        <a if="{action == 'Other'}" class="btn btn-small btn-outline mb1 sm-mb0" onclick="{openGroupCombo}" title="Change Category"><i class="fa fa-edit"></i></a>
      </div>
    </div>
  </li>

  <r-dialog if="{opts.api.activity == ('edit_dimensions_task_' + id + '_' + name)}" title="Edit Dimensions" >
    <form class="p2" onsubmit="{parent.updateDimensions}">
      <label>Dimensions</label>
      <r-area-calculator dimensions="{parent.parent.parent.section.dimensions}" callback="{parent.setQuantity}"></r-area-calculator>
      <div class="clearfix mt2 mxn2">
        <div class="col col-6 px2">
          <button class="block col-12 mb2 btn btn-primary">Save</button>
        </div>
      </div>
    </form>
  </r-dialog>

  <script>

  this.commentsCount = 0
  this.on('mount', () => {
    // $('.animate', this.root).animateCss('bounceIn')
    this.getCommentsCount()
  })

  this.updateDimensions = (e) => {
    e.preventDefault()
    this._item.dimensions = _.compact([parseInt(e.target.width.value), parseInt(e.target.height.value), parseInt(e.target.length.value)])
    this.unsetActivity()
  }

  this.setQuantity = (e) => {
    e.preventDefault()
    this._item.quantity = parseInt(e.currentTarget.value)
    this.unsetActivity()
  }

  this.input = _.debounce((e) => {
    //e.preventUpdate=true
    e.item[e.target.name] = e.target.type === 'checkbox' ? e.target.checked : (e.target.name === 'price' ? (parseInt(e.target.value) || 0) * 100 : (parseInt(e.target.value) || 0))
    //this.update()

    //this.opts.api.tenders.trigger('update')
    this.parent.updateGroupTotal()
    this.parent.parent.updateSectionTotal()
  }, 200)
  this.inputname = (e) => {
    //e.preventDefault()
    e.preventUpdate=true
    e.item.display_name = e.target.value
    //this.update()
    //this.opts.api.tenders.trigger('update')
  }
  this.inputdesc = (e) => {
    //e.preventDefault()
    e.preventUpdate=true
    e.item.description = e.target.value
    //this.update()
    //this.opts.api.tenders.trigger('update')
  }
  this.inputTotalCost = _.debounce((e) => {
    //e.preventUpdate=true
    //$('[name=price]', this.root).val()
    e.item.price = e.target.value * 100 / e.item.quantity
    //this.opts.api.tenders.trigger('update')
    this.parent.updateGroupTotal()
    this.parent.parent.updateSectionTotal()
  }, 200)

  this.openGroupCombo = (e) => {
    e.preventDefault()
    // console.log(this.parent.parent.section)
    riot.mount('r-modal', {
      content: 'r-tender-item-action-group-dropdown',
      persisted: false,
      api: opts.api,
      contentOpts: {api: opts.api, changeTaskAction: this.changeTaskAction, item: e.item}
    })
  }

  this.removeItem = (e) => {
    var ancestorModel = this.parent.parent.parent.parent
    e.preventDefault()
    if (window.confirm(this.ERRORS.CONFIRM_DELETE)) {
        // $('.animate', this.root).one($.animationEnd, () => {
        this.parent.opts.onitemremoved(e, this.parent.opts.name)
        // } ).animateCss('bounceOut')
        ancestorModel.setSectionOffsets('r-tender-section')
        ancestorModel.updateTenderTotal()
        ancestorModel.opts.api[ancestorModel.opts.type_underscore].update(ancestorModel.record.id, ancestorModel.record)
    }
  }

  this.openComments = (e) => {
    e.preventDefault()
    // console.log(this.parent.parent.section)
    riot.mount('r-modal', {
      content: 'r-comments',
      persisted: false,
      api: opts.api,
      contentOpts: {
        parent_tag: this,
        commentsCount: this.commentsCount,
        api: opts.api,
        parent_record: this.parent.parent.record,
        project_id: this.parent.parent.record.project_id,
        commentable_id: e.item.id,
        commentable_type: e.item.action ? 'Task' : 'Material',
        commentable_parent_id: this.parent.parent.record.id,
        commentable_parent_type: this.parent.parent.type
      }
    })
  }
  this.getCommentsCount = () => {
    if (!this._item) { return 0 }
    this.parent.parent.record.comments_counts = this.parent.parent.record.comments_counts || {}
    var item = this._item
    var type = item.action ? 'tasks' : 'materials'
    var counts = _.findWhere(this.parent.parent.record.comments_counts[type], {id: item.id})
    // this.update({commentsCount: counts ? (counts.comments_count || 0) : 0})
    return counts ? (counts.comments_count || 0) : 0

  }



  this.changeTaskAction = (e) => {

    //e.preventUpdate=true
    e.item.action = e.target.value
    //this.update()
    //this.parent.update()
    // console.log('changeTaskAction')
    this.opts.api.tenders.trigger('update')
  }

  </script>
</r-tender-item>
