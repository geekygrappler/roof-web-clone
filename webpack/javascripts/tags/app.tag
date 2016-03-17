import './_header.tag'
import './tabs.tag'
import './auth.tag'
import './modal.tag'
import './projects/index.tag'
import './projects/brief.tag'

<r-app>
  <yield from="header" />

  <div name="content"></div>

  <script>
  this.opts.api.sessions.on('signin.success', this.update)
  this.opts.api.sessions.on('signout.success', this.update)
  this.opts.api.registrations.on('signup.success', this.update)
  riot.route('signout', () => {
    this.opts.api.sessions.signout()
  })
  riot.route('signin', () => {
    if (opts.api.currentAccount) return riot.route(this.authenticatedRoot)
    riot.mount('r-modal', {
      content: 'r-auth',
      persisted: true, api:
      opts.api,
      contentOpts: {tab: 'r-signin', api: opts.api}
    })
  })
  riot.route('signup', () => {
    if (opts.api.currentAccount) return riot.route(this.authenticatedRoot)
    riot.mount('r-modal', {
      content: 'r-auth',
      persisted: true,
      api: opts.api,
      contentOpts: {tab: 'r-signup', api: opts.api}
    })
  })
  riot.route('projects', () => {
    riot.mount(this.content, 'r-projects-index', {api: opts.api})
  })
  riot.route('projects/new', () => {
    riot.mount(this.content, 'r-projects-brief', {api: opts.api})
  })
  </script>
</r-app>
