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

import './_account_index.tag'
import './_project_index.tag'
import './_payment_index.tag'
import './_quote_index.tag'
import './_tender_index.tag'
import './_tender_template_index.tag'
import './_material_index.tag'
import './_task_index.tag'
import './_user_index.tag'



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
              <th each="{ attr, i in headers }" class="nowrap">{ attr.humanize() }</th>
              <th></th>
          </tr>
        </thead>
        <tbody>
          <tr each="{ record, i in records }">
            <td each="{ attr, i in headers}">
              {record[attr]}
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
</r-admin-index>
