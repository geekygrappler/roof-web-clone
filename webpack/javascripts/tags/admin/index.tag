import './_admin_form.tag'
import './_tender_template_form.tag'
import './_tender_form.tag'
import './_quote_form.tag'
import './_payment_form.tag'
import './_account_form.tag'
import './_customer_form.tag'
import './_professional_form.tag'
import './_administrator_form.tag'
import './_lead_form.tag'
import './_project_form.tag'
import './_content_page_form.tag'
import './_content_template_form.tag'

//import rowTmp from './_index_row_tmp.js'

<r-admin-index>

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
              <th each="{ attr, i in headers }">{ attr.humanize() }</th>
              <th></th>
          </tr>
        </thead>
        <tbody>
          <tr each="{ record, i in records }">
            <td each="{ attr, i in headers}">
              {record[attr]}
            </td>
            <td>
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

  </script>
</r-admin-index>
