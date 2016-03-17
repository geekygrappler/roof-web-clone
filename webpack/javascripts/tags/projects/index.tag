<r-projects-index>
  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>
  <div class="container">
    <h1>Projects <a href="/app/projects/new" class="ml1 h5 btn btn-primary"><i class="fa fa-rocket mr1"></i> New Project</a></h1>
    <ul class="list-reset">
      <li each="{projects}" class="p2">
        <div class="border p2">
          <a href="/app/projects/{id}" class="no-decoration">
            <h3>{name}</h3>
          </a>
          <div>
            <i class="fa fa-clock-o mr1"></i> updated {fromNow(updated_at)}
          </div>
          <div if="{opts.api.currentAccount.user_type == 'Administrator'}" class="mt2 table">

              <span class="table-cell mr2">
                <i class="fa fa-user mr1"></i> customers: {_.pluck(_.pluck(customers,'profile'),'first_name')}
              </span>
              <span class="table-cell mr2">
                <i class="fa fa-user-md mr1"></i> adminstrators: {_.pluck(_.pluck(administrators,'profile'),'first_name')}
              </span>
              <span class="table-cell mr2">
                <i class="fa fa-user mr1"></i> professionals: {_.pluck(_.pluck(professionals,'profile'),'first_name')}
              </span>

          </div>
        </div>
      </li>
    </ul>
  </div>
  <script>
  opts.api.projects.on('index.success', projects => {
    opts.api.projects.cache.index = projects
    this.update({projects})
  })
  opts.api.projects.on('index.fail', this.errorHandler)
  opts.api.projects.index()
  </script>
</r-projects-index>
