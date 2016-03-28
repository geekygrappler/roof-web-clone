<r-admin-payment-index>

  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>

  <div class="container p2">
    <form onsubmit="{ search }">
      <input type="text" name="query" class="block mb2 col-12 field" placeholder="Search { opts.resource }" />
    </form>

    <div class="overflow-auto">
      <a class="btn btn-primary" onclick="{ open }">New</a>
      <table id="streamtable" class="table-light bg-white">
        <thead class="bg-darken-1">
          <tr>
              <th each="{ attr, i in headers }" class="nowrap">{ attr.humanize() }</th>
              <th></th>
          </tr>
        </thead>
        <tbody>
          <tr each="{ record, i in records }">
            <td>
              {record.id}
            </td>
            <td>
              {record.status}
            </td>
            <td>
              {formatCurrency(record.fee)}
            </td>
            <td>
              {formatCurrency(record.amount)}
            </td>
            <td class="nowrap">
              {formatTime(record.due_date)}
            </td>
            <td class="nowrap">
              {record.approved_at && formatTime(record.approved_at)}
            </td>
            <td class="nowrap">
              {record.paid_at && formatTime(record.paid_at)}
            </td>
            <td class="nowrap">
              {record.canceled_at && formatTime(record.canceled_at)}
            </td>
            <td class="nowrap">
              {record.declined_at && formatTime(record.declined_at)}
            </td>
            <td class="nowrap">
              {record.refunded_at && formatTime(record.refunded_at)}
            </td>
            <td>
              <a href="/app/admin/projects/{record.project_id}/edit">{record.project_id}</a>
            </td>
            <td>
              <a href="/app/admin/quotes/{record.quote_id}/edit">{record.quote_id}</a>
            </td>
            <td>
              <a href="/app/admin/professionals/{record.professional_id}/edit">{record.professional_id}</a>
            </td>
            <td>
              <a href="/app/admin/customers/{record.customer_id}/edit">{record.customer_id}</a>
            </td>
            <td class="nowrap">
              {formatTime(record.created_at)}
            </td>
            <td class="nowrap">
              {formatTime(record.updated_at)}
            </td>
            <td class="nowrap">
              <button class="btn border btn-small mr1 mb1" onclick="{open}">
                <i class="fa fa-pencil"></i>
              </button>
              <button class="btn btn-small border-red red mb1" onclick="{destroy}">
                <i class="fa fa-trash-o"></i>
              </button>
            </td>
          </tr>
        <tbody>
      </table>
    </div>
    <r-pagination></r-pagination>
  </div>
  <script>
  this.mixin('admin')
  this.mixin('adminIndex')

  </script>
</r-admin-payment-index>
