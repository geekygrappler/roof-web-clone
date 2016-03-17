<r-project-quotes>

  <h2 class="mt0">Quotes</h2>

  <p if="{_.isEmpty(project.tender) && _.isEmpty(quotes)}">
    Hmm, it seems we are still working on your tender and it will show up here when it's ready.
    You can speed up the process by creating a tender document and we will be notified about it.
    <a class="mt2 btn btn-primary" href="/app/projects/{opts.id}/tenders/new">Create a Tender Document</a>
  </p>

  <p if="{_.isEmpty(project.tender) && !_.isEmpty(quotes)}">
    Here is the <a href="/app/projects/{opts.id}/tenders/${project.tender.id}">Tender Document</a> we've prepared for you.
    Actual <strong>quotes</strong> from Professionals will appear here when they submit them.
  </p>

  <ul class="list-reset">

    <li if="{project.tender}" class="inline-block p1 col-4 align-top">
      <div class="px2 border">
        <h2 class="inline-block">{ formatCurrency(project.tender.total_amount) }</h2>
        <span class="inline-block align-middle h6 mb1 px1 border pill">Tender</span>
        <p class="overflow-hidden m0 mxn2 p1 bg-yellow">
          <a class="btn btn-small bg-darken-2" href="/app/projects/{opts.id}/tenders/{project.tender.id}">Show</a>
          <a class="btn btn-small bg-darken-2" if="{opts.api.currentAccount.user_type != 'Customer'}" onclick="{parent.clone}">Clone</a>
        </p>
      </div>
    </li>

    <li each="{quotes}" class="inline-block p1 col-4 align-top">
      <div class="px2 border">
        <h2 class="inline-block">{ formatCurrency(total_amount) }</h2>
        <span class="inline-block align-middle h6 mb1 px1 border pill">Quote</span>
        <p class="overflow-hidden m0 mxn2 p1 bg-yellow">
          <a class="btn btn-small bg-darken-2" href="/app/projects/{opts.id}/quotes/${id}">Show</a>
        </p>
      </div>
    </li>
  </ul>

  <script>
  this.mixin('projectTab')
  opts.api.quotes.on('index.fail', this.errorHandler)
  opts.api.quotes.on('index.success', tenders => this.update({tenders}))
  opts.api.quotes.on('create.success', quote => {
    this.quotes.push(quote)
    this.update()
  })
  opts.api.quotes.index({project_id: opts.id})
  this.clone = (e) => {
    e.preventDefault()
    opts.api.quotes.create({project_id: opts.id, tender_id: project.tender.id})
  }
  </script>
</r-project-quotes>
