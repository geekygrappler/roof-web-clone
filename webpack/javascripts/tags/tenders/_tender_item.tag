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
    <div if="{opts.border_cleaner}" class="border-cleaner absolute"></div>
    <div class="clearfix animate p1 border-bottom">
      <div if="{ parent.headers.name }" class="sm-col sm-col-{ parent.headers.name } mb1 sm-mb0">
        <input type="text" name="name" value="{ display_name || name }"
        class="fit field inline-input align-left col-12" oninput="{ inputname }" />
        <a if="{action == 'Other'}" class="btn btn-small btn-outline h6" onclick="{openGroupCombo}">Change Category</a>
        <br class="sm-hide">
      </div>

      <div if="{ parent.headers.quantity }" class="col sm-col-{ parent.headers.quantity } col-3 center">
        <input type="number" name="quantity" value="{ quantity }" step="1" min="0"
        class="fit field inline-input center" oninput="{ input }" />
      </div>

      <div if="{ parent.headers.price }" class="col sm-col-{ parent.headers.price } col-{parent.opts.name == 'task' ? 3 : 2} center relative">
        <i class="fa fa-gbp absolute left-0 top-0 z1 mt1 mr1 bg-white"></i><input type="number" name="price" value="{ parent.opts.name == 'task' ? price / 100 : (supplied ? price / 100 : 0) }"
        disabled="{ parent.opts.name == 'material' && !supplied }" step="1" min="0" class="fit field inline-input center price" oninput="{ input }" />
      </div>

      <div if="{ parent.headers.total_cost }" class="col sm-col-{ parent.headers.total_cost } col-3 center relative">
        <i class="fa fa-gbp absolute left-0 top-0 z1 mt1 mr1 bg-white"></i><input type="number" value="{parent.opts.name == 'task' ? (price / 100 * quantity) : (supplied ? price / 100 * quantity : '0')}"
        step="1" min="0" class="fit field inline-input center price" oninput="{ inputTotalCost }" >
      </div>

      <div if="{ parent.headers.supplied }" class="col sm-col-{ parent.headers.supplied } col-1 center">
        <input if="{ parent.opts.name == 'material'}" type="checkbox" name="supplied"
        checked="{ supplied }" class="align-middle" onchange="{ input }" />
      </div>

      <div if="{ parent.headers.actions }" class="col sm-col-{ parent.headers.actions } col-2 center">
        <a href="#" class="btn btn-small border-red red mb1 sm-mb0" onclick="{ removeItem }"><i class="fa fa-trash-o"></i></a>
        <a href="#" if="{parent && parent.parent && parent.parent.record.id}" class="btn btn-small border mb1 sm-mb0" onclick="{ openComments }"><i class="fa fa-comment-o"></i></a>
      </div>
    </div>
  </li>

  <script>


  this.on('mount', () => {
    // $('.animate', this.root).animateCss('bounceIn')
  })

  this.input = _.debounce((e) => {
    //e.preventUpdate=true
    e.item[e.target.name] = e.target.type === 'checkbox' ? e.target.checked : (e.target.name === 'price' ? (parseInt(e.target.value) || 0) * 100 : (parseInt(e.target.value) || 0))
    //this.update()

    //this.opts.api.tenders.trigger('update')
    this.parent.updateGroupTotal()
    this.parent.parent.updateSectionTotal()
  }, 300)
  this.inputname = (e) => {
    //e.preventUpdate=true
    e.item.display_name = e.target.value
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
  }, 300)

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
    e.preventDefault()
    if (window.confirm(this.ERRORS.CONFIRM_DELETE)) {
    // $('.animate', this.root).one($.animationEnd, () => {
      this.parent.opts.onitemremoved(e, this.parent.opts.name)
    // } ).animateCss('bounceOut')
    }
  }

  this.openComments = (e) => {
    e.preventDefault()
    // console.log(this.parent.parent.section)
    riot.mount('r-modal', {
      content: 'r-comments',
      persisted: false,
      api: opts.api,
      contentOpts: {api: opts.api, project: this.parent.parent.record, item: e.item}
    })
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
