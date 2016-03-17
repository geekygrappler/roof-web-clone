import riot from 'riot'

riot.mixin('projectTab', {
  init: function () {
    let project,
        opts = this.opts,
        project_id = opts.project_id || opts.id
    // subscribe projects api updates
    opts.api.projects.on('show.fail', this.errorHandler)
    opts.api.projects.on('show.success', project => this.update({project}))
    // check if cached value set and display if not fetch fresh
    if (opts.api.projects.cache.index) {
      project = _.find(opts.api.projects.cache.index, p => p.id == project_id)
      if (project) {
        opts.api.projects.trigger('show.success', project)
      }else {
        opts.api.projects.show(project_id)
      }
    } else {
      opts.api.projects.show(project_id)
    }
  }
})
