<r-tabs>
  <div name="tab" class="px2 sm-p0"></div>

  <script>
  this.navigate = (e) => {
    if (e) {
      e.preventDefault()
      e.stopImmediatePropagation()
      this.opts.tab = e.target.name
      history.pushState(null, e.target.title, e.target.href)
    }
    let options = _.extend(opts.content_opts || opts.contentOpts || {}, {
      navigate: this.navigate,
      api: opts.api
    })
    riot.mount(this.tab, opts.tab, options)
  }
  this.navigate()

  </script>
</r-tabs>
