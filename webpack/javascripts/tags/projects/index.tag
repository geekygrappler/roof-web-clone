

<r-projects-index>
  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>
  <div class="container">
    <h1 class="px2">Projects <a href="/app/projects/new" class="ml1 h5 btn btn-primary"><i class="fa fa-rocket mr1"></i> New Project</a></h1>
    <ul class="list-reset">
      <li each="{projects}" class="p2">
        <div class="border p2">
          <a href="/app/projects/{id}" class="no-decoration">
            <h3 class="mb3"><img class="kind-ico" src="/images/project_types/{kind}.png" alt="{name}"> {name}</h3>
          </a>
          <div>
            <i class="fa fa-clock-o mr1"></i> updated {fromNow(updated_at)}
          </div>
        </div>
      </li>
    </ul>
    <div class="p1 center mb2">
      <a class="btn btn-small bg-blue white h5 mr1" onclick="{prevPage}">Prev</a>
      <span>{currentPage}</span>
      <a class="btn btn-small bg-blue white h5 ml1" onclick="{nextPage}">Next</a>
    </div>
  </div>
  <script>
  this.currentPage = 1
  this.updateProjects = (projects) => {
    opts.api.projects.cache.index = projects
    this.update({projects})
  }
  this.on('mount', () => {
    opts.api.projects.on('index.success', this.updateProjects)
    opts.api.projects.on('index.fail', this.errorHandler)
    opts.api.projects.index({page: this.currentPage})
  })
  this.on('unmount', () => {
    opts.api.projects.off('index.success', this.updateProjects)
    opts.api.projects.off('index.fail', this.errorHandler)
  })
  this.prevPage = (e) => {
    e.preventDefault()
    this.currentPage = Math.max(this.currentPage - 1, 1)
    this.opts.api.projects.index({page: this.currentPage})
  }
  this.nextPage = (e) => {
    e.preventDefault()
    // this.currentPage = Math.min(this.currentPage + 1, 0)
    this.opts.api.projects.index({page: ++this.currentPage})
  }

  </script>
</r-projects-index>
