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
      _.map(this.opts.document.sections, function (section)  {
        var tasks = _.mapObject(_.groupBy(section.tasks, 'action'), function (val, key) {
          return itemsTotal(val, key)
        })
        var materials = itemsTotal(section.materials, 'materials')
        return _.extend(tasks, {Materials: materials, VAT: vat(tasks)})
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
      return _.indexOf(_.keys(taskActions), key)
    })

    for (key = 0; key < a.length; key++) {
        sorted[a[key]] = o[a[key]];
    }
    return sorted;
  }
  </script>
</r-tender-summary>
