import './_header.tag'
import './_subnav.tag'
import './tabs.tag'
import './auth.tag'
import './_invitation_accept.tag'
import './modal.tag'

import './projects/_file_input.tag'
import './projects/_files_input_with_preview.tag'
import './projects/index.tag'
import './projects/brief.tag'
import './projects/show.tag'

import './tenders/tender.tag'
import './quotes/quote.tag'

import './settings.tag'

<r-app>
  <yield from="header" />

  <div name="content"></div>

  <script>
  this.on('mount', () => {
    this.opts.api.sessions.on('signin.success', this.update)
    this.opts.api.sessions.on('signout.success', this.update)
    this.opts.api.registrations.on('signup.success', this.update)
  })
  this.on('unmount', () => {
    this.opts.api.sessions.off('signin.success', this.update)
    this.opts.api.sessions.off('signout.success', this.update)
    this.opts.api.registrations.off('signup.success', this.update)
  })

  riot.route('signout', () => {
    this.opts.api.sessions.signout()
  })
  riot.route('signin', () => {
    if (opts.api.currentAccount) return riot.route(opts.api.authenticatedRoot)
    riot.mount('r-modal', {
      content: 'r-auth',
      persisted: true, api:
      opts.api,
      contentOpts: {tab: 'r-signin', api: opts.api}
    })
  })
  riot.route('signup', () => {
    if (opts.api.currentAccount) return riot.route(opts.api.authenticatedRoot)
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
  riot.route('projects/*', (id) => {
    riot.route(`/projects/${id}/overview`, 'Overview', true)
  })
  riot.route('projects/*/*', (id, tab) => {
    riot.mount(this.content, 'r-projects-show', {
      api: opts.api,
      id: id,
      tab: `r-project-${tab}`,
      contentOpts: {
        id: id
      }
    })
  })
  riot.route('projects/*/tenders/new', (project_id) => {
    riot.mount(this.content, 'r-tenders-form', {
      api: opts.api,
      project_id: project_id
    })
  })
  riot.route('projects/*/tenders/*', (project_id, id) => {
    riot.mount(this.content, 'r-tenders-form', {
      api: opts.api,
      project_id: project_id,
      id: id,
      readonly: (opts.api.currentAccount && opts.api.currentAccount.isProfessional)
    })
  })
  riot.route('projects/*/quotes/new', (project_id) => {
    riot.mount(this.content, 'r-quotes-form', {
      api: opts.api,
      project_id: project_id
    })
  })
  riot.route('projects/*/quotes/*', (project_id, id) => {

    riot.mount(this.content, 'r-quotes-form', {
      api: opts.api,
      project_id: project_id,
      id: id,
      readonly: (opts.api.currentAccount && opts.api.currentAccount.isCustomer)
    })
  })

  riot.route('invitations/accept/*', (token) => {
    opts.api.invitationToken = token
    riot.mount('r-modal', {
      content: 'r-auth',
      persisted: true,
      api: opts.api,
      contentOpts: {tab: 'r-invitation-accept', api: opts.api}
    })
  })

  riot.route('settings', () => {
    riot.route(`/settings/profile`, 'Profile', true)
  })
  riot.route('settings/*', (tab) => {
    riot.mount(this.content, 'r-settings', {
      api: opts.api,
      tab: `r-settings-${tab}`
    })
  })

  </script>
</r-app>
