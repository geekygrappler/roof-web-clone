import '../../mixins/project_tab'
import './_overview.tag'
import './_brief.tag'
import './_docs.tag'
import './_appointments.tag'
import './_team.tag'
import './_payment_form.tag'
import './_quotes.tag'
import './_tender.tag'

<r-projects-show>
  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>
  <div class="container">
    <div class="py3 px2">
      <div class="clearfix mxn2">

        <r-subnav links="{subnavLinks}" tab="{opts.tab}" active_tab_name="{opts.activeTabName}"></r-subnav>
        <div class="sm-col sm-col-9 sm-px2">
            <r-tabs tab="{opts.tab}" api="{opts.api}" content_opts="{opts.contentOpts}"></r-tabs>
        </div>

      </div>
    </div>
  </div>
  <script>

  this.subnavLinks = [
    {href: `/app/projects/${opts.id}/overview`, name: 'overview', tag: 'r-project-overview'},
    {href: `/app/projects/${opts.id}/brief`, name: 'brief', tag: 'r-project-brief'},
    {href: `/app/projects/${opts.id}/docs`, name: 'docs', tag: 'r-project-docs'},
    {href: `/app/projects/${opts.id}/team`, name: 'team', tag: 'r-project-team'},
    {href: `/app/projects/${opts.id}/tender`, name: 'tender', tag: 'r-project-tender'},
    {href: `/app/projects/${opts.id}/quotes`, name: 'quotes', tag: 'r-project-quotes'},
    {href: `/app/projects/${opts.id}/payments`, name: 'payments', tag: 'r-project-quotes'}
  ]
  if(this.currentAccount && this.currentAccount.isProfessional) {
    this.subnavLinks = [
      {href: `/app/projects/${opts.id}/overview`, name: 'overview', tag: 'r-project-overview'},
      {href: `/app/projects/${opts.id}/docs`, name: 'docs', tag: 'r-project-docs'},
      {href: `/app/projects/${opts.id}/team`, name: 'team', tag: 'r-project-team'},
      {href: `/app/projects/${opts.id}/tender`, name: 'tender', tag: 'r-project-tender'},
      {href: `/app/projects/${opts.id}/quotes`, name: 'quotes', tag: 'r-project-quotes'},
      {href: `/app/projects/${opts.id}/payments`, name: 'payments', tag: 'r-project-quotes'}
    ]
  }
  </script>
</r-projects-show>
