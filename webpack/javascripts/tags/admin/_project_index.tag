<r-admin-project-index>

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
              <th each="{ attr, i in headers }" class="nowrap cursor-pointer" onclick="{sort}">{ attr.humanize() } <i class="fa fa-sort"></i></th>
              <th></th>
          </tr>
        </thead>
        <tbody>
          <tr each="{ record, i in records }">
            <td>
              <a href="/app/projects/{record.id}" target="_blank">{record.id}</a>
            </td>
            <td>
              {record.name}
            </td>
            <td>
              {record.kind}
            </td>
            <td>
              <a href="/app/admin/accounts/{record.account_id}/edit">{record.account_id}</a>
            </td>
            <td class="nowrap">
              {formatTime(record.created_at)}
            </td>
            <td class="nowrap">
              {formatTime(record.updated_at)}
            </td>
            <td>
              <a each="{acc in record.customers}" href="/app/admin/accounts/{acc.id}/edit" class="mr1 mb1">{acc.full_name}</a>
            </td>
            <td>
              <a each="{acc in record.professionals}" href="/app/admin/accounts/{acc.id}/edit" class="mr1 mb1">{acc.full_name}</a>
            </td>
            <td>
              <a each="{acc in record.administrators}" href="/app/admin/accounts/{acc.id}/edit" class="mr1 mb1">{acc.full_name}</a>
            </td>
            <td class="nowrap">
              <a class="btn border btn-small mr1 mb1" href="/app/projects/{record.id}" target="_blank">
                <i class="fa fa-pencil"></i>
              </a>
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

  this.updateRecords = (records) => {
    var headers = _.filter(_.keys(records[0]), h => ['customers', 'professionals', 'administrators'].indexOf(h) == -1)
    this.update({headers: headers, records: records})
  }

  this.mixin('admin')
  this.mixin('adminIndex')
  </script>
</r-admin-project-index>
