<r-tabs>
  <div name="tab"></div>

  <script>
  this.navigate = (e) => {
    if (e) {
      e.preventDefault()
      this.opts.tab = e.target.name
      history.pushState(null, e.target.title, e.target.href)
    }
    riot.mount(this.tab, this.opts.tab, {
      navigate: this.navigate,
      api: opts.api
    })
  }
  this.navigate()

  </script>
</r-tabs>
