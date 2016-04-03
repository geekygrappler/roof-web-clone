import './_comments.tag'

<r-tender-item>
  <li class="relative">
    <div if="{opts.border_cleaner}" class="border-cleaner absolute"></div>
    <div class="clearfix animate p1 border-bottom">
      <div if="{ parent.headers.name }" class="sm-col sm-col-{ parent.headers.name } mb1 sm-mb0">
        <input type="text" name="name" value="{ display_name || name }"
        class="fit field inline-input align-left col-12" oninput="{ inputname }" />
        <select if="{action.toLowerCase() == 'other'}" onchange="{changeTaskAction}">
          <option each="{val, name in parent.opts.task_actions}" value="{val}" selected="{val == 'Other'}">{name}</option>
        </select>
        <hr class="sm-hide">
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
        <a href="#" class="btn btn-small border-red red" onclick="{ removeItem }"><i class="fa fa-trash-o"></i></a>
        <a href="#" if="{parent && parent.parent && parent.parent.record.id}" class="btn btn-small border" onclick="{ openComments }"><i class="fa fa-comment-o"></i></a>
      </div>
    </div>
  </li>

  <script>

  this.on('mount', () => {
    // $('.animate', this.root).animateCss('bounceIn')
  })

  this.input = (e) => {
    e.item[e.target.name] = e.target.type === 'checkbox' ? e.target.checked : (e.target.name === 'price' ? (parseInt(e.target.value) || 0) * 100 : (parseInt(e.target.value) || 0))
    //this.update()
    this.opts.api.tenders.trigger('update')
  }
  this.inputname = (e) => {
    e.item.display_name = e.target.value
    this.update()
    this.opts.api.tenders.trigger('update')
  }
  this.inputTotalCost = (e) => {
    //$('[name=price]', this.root).val()
    e.item.price = e.target.value * 100 / e.item.quantity
    this.opts.api.tenders.trigger('update')
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
    e.item.action = e.target.value
    this.update()
    this.parent.update()
    this.opts.api.tenders.trigger('update')
  }

  </script>
</r-tender-item>
