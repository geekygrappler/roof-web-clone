let taskActions = require("json!../../data/task_actions.json")

<r-tender-summary>
  <table class="table-light">
    <tbody>
      <tr each="{name, amount in summary}">
        <td>{name}</td>
        <td>{formatCurrency(amount)}</td>
      </tr>
    </tbody>
  </table>
  <script>
  this.on('mount', () => {
    var summary = _.reduce(
      _.map(this.opts.document.sections, (section)  => {
        if (this.opts.type === 'sections') {
            var obj = {}
            obj[section.name] = section.tasks
        } else {
            var obj = _.groupBy(section.tasks, 'action')
        }
        var tasks = _.mapObject(obj, function (val, key) {
          return itemsTotal(val, key)
        })
        var materials = itemsTotal(section.materials, 'materials')
        if (this.opts.document.include_vat) {
          return _.extend(tasks, {Materials: materials, VAT: vat(tasks)})
        } else {
          return _.extend(tasks, {Materials: materials})
        }

      })
    , function (memo, group) {
      _.each(group, function (val, key) {
        memo[key] = (memo[key] || 0) + val
      })
      return memo
    }, {})

    summary = sortObject(summary)
    this.update({summary})
  })
  function vat (tasks) {
    var subTotal = _.reduce(_.values(tasks), (m,i) => m+i, 0)
    return subTotal * 20 / 100
  }
  function itemsTotal (items, group) {
    return _.reduce(items, function (total, item) {
      if (group == 'materials') {
        return total + (item.supplied ? item.price * item.quantity : 0)
      } else{
        return total + item.price * item.quantity
      }
    }, 0)
  }
  function sortObject(o) {
    var sorted = {},
    key, a = [];

    for (key in o) {
        if (o.hasOwnProperty(key)) {
            a.push(key);
        }
    }

    // a.sort();
    a = _.sortBy(a, (key) => {
      return _.indexOf(_.values(taskActions), key)
    })

    for (key = 0; key < a.length; key++) {
        sorted[a[key]] = o[a[key]];
    }
    return sorted;
  }
  </script>
</r-tender-summary>
