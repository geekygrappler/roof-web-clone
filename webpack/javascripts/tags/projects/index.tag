

<r-projects-index>
  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>
  <div class="container">
    <h1 class="px2">Projects <a href="/app/projects/new" class="ml1 h5 btn btn-primary"><i class="fa fa-rocket mr1"></i> New Project</a></h1>
    <form class="px2" onsubmit="{ search }">
      <input type="text" name="query" class="block mb2 col-12 field" placeholder="Search { opts.resource }" />
    </form>
    <ul class="list-reset">
      <li each="{projects}" class="p2">
        <div class="border p2">
          <a href="/app/projects/{id}" class="no-decoration">
            <h3 class="mb3"><img class="kind-ico" src="/images/project_types/{kind}.png" alt="{name}"> {name}</h3>
          </a>
          <div class="mb1">
            <i class="fa fa-clock-o mr1"></i> updated {fromNow(updated_at)}
          </div>
          <div class="clearfix">
            <div class="sm-col sm-col-3 ">
              <span each="{acc in customers}" class="px1 border border-yellow mr1 mb1 h6 inline-block truncate">{acc.full_name}</span>
            </div>
            <div class="sm-col sm-col-3 ">
              <span each="{acc in shortlist}" class="px1 border border-orange mr1 mb1 h6 inline-block truncate">{acc.full_name}</span>
            </div>
            <div class="sm-col sm-col-3">
              <span each="{acc in professionals}" class="px1 border border-red mr1 mb1 h6 inline-block truncate">{acc.full_name} *</span>
            </div>
            <div class="sm-col sm-col-3 ">
              <span each="{acc in administrators}" class="px1 border border-blue mr1 mb1 h6 inline-block truncate">{acc.full_name}</span>
            </div>
          </div>
        </div>
      </li>
    </ul>
    <r-pagination></r-pagination>
  </div>
  <script>
  this.opts.page = this.opts.page || 1
  this.opts.resource = 'projects'

  this.updateProjects = (projects) => {
    opts.api.projects.cache.index = projects
    this.update({projects})
  }
  this.on('mount', () => {
    opts.api.projects.on('index.success', this.updateProjects)
    opts.api.projects.on('index.fail', this.errorHandler)
    opts.api.projects.index({page: this.opts.page, query: this.opts.query})
  })
  this.on('unmount', () => {
    opts.api.projects.off('index.success', this.updateProjects)
    opts.api.projects.off('index.fail', this.errorHandler)
  })
  this.prevPage = (e) => {
    e.preventDefault()
    this.opts.page = Math.max(this.opts.page - 1, 1)
    // this.opts.api[opts.resource].index({page: this.opts.page})
    if(this.opts.query) {
      riot.route(`/projects/search/${this.opts.query}/page/${this.opts.page}`)
    } else {
      riot.route(`/projects/page/${this.opts.page}`)
    }
  }
  this.nextPage = (e) => {
    e.preventDefault()
    // this.opts.page = Math.min(this.opts.page + 1, 0)
    // this.opts.api[opts.resource].index({page: ++this.opts.page})
    if(this.opts.query) {
      riot.route(`/projects/search/${this.opts.page}/page/${++this.opts.page}`)
    } else {
      riot.route(`/projects/page/${++this.opts.page}`)
    }
  }
  this.gotoPage = (e) => {
    if(this.opts.query) {
      riot.route(`/projects/search/${this.opts.query}/page/${e.target.value}`)
    } else {
      riot.route(`/projects/page/${e.target.value}`)
    }
  }
  this.search = (e) => {
    e.preventDefault()
    // this.opts.api[opts.resource].index({query: this.query.value, page: (this.currentPage = 1)})
    riot.route(`/projects/search/${this.query.value}/page/1`)
  }

  </script>
</r-projects-index>
