<r-tabs>
  <div name="tab"></div>

  <script>
  this.navigate = (e) => {
    if (e) {
      e.preventDefault()
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
