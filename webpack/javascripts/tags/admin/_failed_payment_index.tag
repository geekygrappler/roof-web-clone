<r-admin-failed-payment-index>

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
              {record.id}
            </td>
            <td>
              {record.name}
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
</r-admin-failed-payment-index>
