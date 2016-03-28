import riot from 'riot'

riot.mixin('projectTab', {
  init: function () {
    let project,
        opts = this.opts,
        project_id = opts.project_id || opts.id

    this.updateProject = project => {
      this.update({project})
    }
    this.on('mount', () => {
      // subscribe projects api updates
      opts.api.projects.on('show.fail', this.errorHandler)
      opts.api.projects.on('show.success', this.updateProject)
      // check if cached value set and display if not fetch fresh
      // if (opts.api.projects.cache.index) {
      //   project = _.find(opts.api.projects.cache.index, p => p.id == project_id)
      //   if (project) {
      //     opts.api.projects.trigger('show.success', project)
      //   }else {
      //     opts.api.projects.show(project_id)
      //   }
      // } else {
        opts.api.projects.show(project_id)
      // }
    })

    this.on('unmount', () => {
      // subscribe projects api updates
      opts.api.projects.off('show.fail', this.errorHandler)
      opts.api.projects.off('show.success', this.updateProject)
    })
  }
})
