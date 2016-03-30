<r-project-tender>

  <h2 class="mt0">Tender</h2>

  <p if="{_.isEmpty(project.tender)}">
    Hmm, it seems we are still working on your tender and it will show up here when it's ready.
    You can speed up the process by creating a tender document and we will be notified about it.
    <div if="{_.isEmpty(project.tender) && !currentAccount.isProfessional}" class="mt2">
      <a class="btn btn-primary" href="/app/projects/{opts.id}/tenders/new">Create a Tender Document</a>
    </div>
  </p>

  <ul class="list-reset mxn1">

    <li if="{project.tender}" class="block p1 sm-col-12 align-top">
      <div class="px2 border">
        <h2 class="inline-block">{ formatCurrency(project.tender.total_amount) }</h2>
        <span class="inline-block align-middle h6 mb1 px1 border pill right mt2">Tender</span>

        <div class="m0 mxn2">
        <r-tender-summary document="{project.tender.document}"></r-tender-summary>
        </div>

        <p class="overflow-hidden m0 mxn2 p1 border-top">
          <a class="btn btn-small" href="/app/projects/{opts.id}/tenders/{project.tender.id}">Open</a>
          <a class="btn btn-small btn-primary" if="{currentAccount.isProfessional}" onclick="{clone}">Clone</a>
        </p>
      </div>
    </li>

  </ul>

  <script>

  this.clone = (e) => {
    e.preventDefault()
    opts.api.quotes.create({
      project_id: this.opts.id,
      tender_id: this.project.tender.id,
      professional_id: this.currentAccount.user_id
    })
    .fail(this.errorHandler)
    .then((quote) => {
      riot.route(`/projects/${quote.project_id}/quotes/${quote.id}`)
    })
  }

  this.mixin('projectTab')
  </script>

</r-project-tender>
