<r-tender-item-group class="col-11">

  <ul class="list-reset ml2 mb0 relative {last: last}">
    <li>
      <h4 class="block mb0 mt1 p1 border-bottom border-right group-title">

        <a onclick="{toggle}" class="cursor-pointer">
          <i class="fa fa-{ icon } mr1 hide"></i> { group.humanize() }
        </a>
      </h4>
      <ul class="list-reset ml2 border-left mb0" if="{visible}">
        <li if="{header}" class="sm-show relative">
          <div class="clearfix p1 border-bottom">
            <div each="{ name, width in headers }" class="sm-col sm-col-{width} mb1 sm-mb0">
              { ['name','description'].indexOf(name) > -1  ? '&nbsp;' : name.humanize() }
              <span class='actions-header hide' if='{name == "actions"}'></span>
            </div>
          </div>
        </li>

        <r-tender-item each="{items}" border_cleaner="{last}" readonly="{opts.readonly}" no-reorder></r-tender-item>

      </ul>
    </li>
  </ul>
  <div class="clearfix relative group-total-wrapper">
    <h4 class="right mt1 mb0 p1 border abolute group-total bg-white z2">
      <div class="bg-white relative z4">{formatCurrency(groupTotal)}</div>
    </h4>
  </div>

  <script>
  let itemKeys

  // this.taskActions = opts.task_actions

  this.visible = this.parent.parent.opts.id ? false : true

  this.icon = this.visible ? 'minus-square-o' : 'plus-square-o'

  this.toggle = (e) => {
    e.preventDefault()
    this.visible = !this.visible
    this.icon = this.visible ? 'plus-square-o' : 'minus-square-o'
  }

  // this.on('update', () => {
  //   if(this.tags['r-tender-item'] && this.items && this.items.length != this.tags['r-tender-item'].length) this.update({visible: true})
  // })

  this.updateGroupTotal = () => {
    this.groupTotal = this.calcGroupTotal()
  }

  this.calcGroupTotal = () => {
    return _.reduce(this.items, (total, item) => {
      if (this.group == 'materials') {
        return total + (item.supplied ? item.price * item.quantity : 0)
      } else{
        return total + item.price * item.quantity
      }
    }, 0)
  }

  this.on('mount', () => {
    itemKeys = Object.keys(this.opts.groupitems)
    this.groupTotal = this.calcGroupTotal()
    this.last = this.drawBorderCleaner()
    this.header = this.drawHeader()
    this.update()
  })

  this.on('update', () => {

    if (this.items) {
      this.groupTotal = this.calcGroupTotal()
      this.last = this.drawBorderCleaner()
      this.header = this.drawHeader()
      this.update()
    }
  })

  this.drawHeader = () => {
    if (this.isMounted) {
      return itemKeys.indexOf(this.group) == 0
    }
  }

  this.drawBorderCleaner = () => {
    if (this.isMounted) {
      return itemKeys.indexOf(this.group) == itemKeys.length - 1
    }
  }

  this.headers = this.opts.headers
  </script>
</r-tender-item-group>
