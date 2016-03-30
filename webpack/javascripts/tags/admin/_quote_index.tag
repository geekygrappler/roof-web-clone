<r-admin-quote-index>

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
              {formatCurrency(record.total_amount)}
            </td>
            <td>
              {formatCurrency(record.paid_amount)}
            </td>
            <td>
              {formatCurrency(record.refunded_amount)}
            </td>
            <td>
              {formatCurrency(record.approved_amount)}
            </td>
            <td>
              <a href="/app/projects/{record.project_id}">{record.project_id}</a>
            </td>
            <td>
              <a href="/app/admin/professionals/{record.professional_id}/edit">{record.professional_id}</a>
            </td>
            <td>
              <a href="/app/admin/tenders/{record.tender_id}/edit">{record.tender_id}</a>
            </td>
            <td class="nowrap">
              {record.accepted_at && formatTime(record.accepted_at)}
            </td>
            <td class="nowrap">
              {record.submitted_at && formatTime(record.submitted_at)}
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
</r-admin-quote-index>
