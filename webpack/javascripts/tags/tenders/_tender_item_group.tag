<r-tender-item-group class="{last: drawBorderCleaner()}">
  <ul class="list-reset ml2 mb0 relative">
    <li>
      <h4 class="inline-block mb0 mt1 p1 border-bottom ">

        <a onclick="{toggle}" class="cursor-pointer">
          <i class="fa fa-{ icon } mr1"></i> { group.humanize() }
        </a>
      </h4>
      <ul class="list-reset ml2 border-left mb0" if="{visible}">
        <li if="{drawHeader()}" class="sm-show relative">
          <div class="clearfix p1 border-bottom">
            <div each="{ name, width in headers }" class="sm-col sm-col-{width} {center: name != 'name'} mb1 sm-mb0 truncate">
              { name == 'name' ? '&nbsp;' : name.humanize() }
            </div>
          </div>
        </li>

        <r-tender-item each="{ items }" border_cleaner="{drawBorderCleaner()}"></r-tender-item>

      </ul>
    </li>
  </ul>
  <h5 class="right-align mb0">{formatCurrency(total())}</h5>

  <script>
  let itemKeys

  this.taskActions = opts.task_actions

  this.visible = true

  this.icon = 'plus-square-o'

  this.changeIcon = (e) => {
    this.icon = this.visible ? 'plus-square-o' : 'minus-square-o'
  }

  this.toggle = (e) => {
    e.preventDefault()
    this.visible = !this.visible
    this.changeIcon(e)
  }

  this.total = () => {
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
    this.update()
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
