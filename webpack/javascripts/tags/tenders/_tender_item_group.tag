<r-tender-item-group>
  <ul class="list-reset ml2 border-left mb0 relative">
    <li>
      <h4 class="inline-block mb0 mt1 p1 border-bottom ">
        <select if="{group.toLowerCase() == 'other'}" onchange="{changeTaskAction}">
          <option each="{val, name in taskActions}" value="{val}" selected="{val == 'Other'}">{name}</option>
        </select>
        <span if="{group.toLowerCase() != 'other'}">{ group.humanize() }</span>
      </h4>
      <ul class="list-reset ml2 border-left mb0">
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
  <h5 class="right-align">Group total: {formatCurrency(total())}<h5>

  <script>
  let itemKeys

  this.taskActions = {
   "Strip out": "Strip out",
   "Wire and connect": "Electrics",
   "Plumb": "Plumbing",
   "Build": "Building",
   "Install": "Carpentery",
   "Tile": "Tiling",
   "Lay": "Flooring",
   "Prepare": "Preparation",
   "Plaster": "Plastering",
   "Decorate": "Decorating",
   "Other": "Other"
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

  this.changeTaskAction = (e) => {
    _.map(this.items, item => item.action = e.target.value)
    this.update()
  }

  this.headers = this.opts.headers
  </script>
</r-tender-item-group>
