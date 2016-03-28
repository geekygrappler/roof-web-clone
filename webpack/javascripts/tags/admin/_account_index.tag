<r-admin-account-index>

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
              {record.email}
            </td>
            <td>
              <a href="/app/admin/{record.user_type.plural().toLowerCase()}/{record.user_id}/edit">{record.user_id}</a>
            </td>
            <td>
              <a onclick="{impersonate}">Impersonate {record.user_type}</a>
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
    <div class="center py2">
      <a class="btn btn-small bg-blue white" onclick="{prevPage}">Prev</a> <span class="ml1 mr1 px1 inline-block border">{opts.page}</span> <a class="btn btn-small bg-blue white" onclick="{nextPage}">Next</a>
    </div>
  </div>
  <script>
  this.mixin('admin')
  this.mixin('adminIndex')
  this.impersonate = (e) => {
    e.preventDefault()
    this.opts.api.sessions.impersonate({id: e.item.record.id})
  }

  </script>
</r-admin-account-index>
