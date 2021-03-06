import './_header.tag'
import './_subnav.tag'
import './tabs.tag'
import './auth.tag'
import './_invitation_accept.tag'
import './modal.tag'
import './_pagination.tag'
import './_dialog.tag'

import './projects/_file_input.tag'
import './projects/_files_input_with_preview.tag'
import './projects/index.tag'
import './projects/brief.tag'
import './projects/show.tag'

import './tenders/tender.tag'
import './quotes/quote.tag'
import './leads/lead.tag'

import './settings.tag'

import './admin/index.tag'

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
  riot.route('forgot-password', () => {
    if (opts.api.currentAccount) return riot.route(opts.api.authenticatedRoot)
    riot.mount('r-modal', {
      content: 'r-auth',
      persisted: true,
      api: opts.api,
      contentOpts: {tab: 'r-forgot-password', api: opts.api}
    })
  })
  riot.route('reset-password?..', (token) => {
    if (opts.api.currentAccount) return riot.route(opts.api.authenticatedRoot)
    riot.mount('r-modal', {
      content: 'r-auth',
      persisted: true,
      api: opts.api,
      contentOpts: {tab: 'r-reset-password', api: opts.api}
    })
  })

  riot.route('leads/new..', () => {
    // console.log(riot.route.query())
    riot.mount(this.content, 'r-lead', {api: opts.api, query: riot.route.query()})
    riot.mount('r-leads-form', {api: opts.api, query: riot.route.query()})
    $('r-app').removeClass('display-none')
  })
  riot.route('projects', () => {
    riot.mount(this.content, 'r-projects-index', {api: opts.api})
  })
  riot.route('projects/page/*', (page) => {
    riot.mount(this.content, 'r-projects-index', {api: opts.api, page: page})
  })
  riot.route(`projects/search/*/page/*`, ( query, page) => {
    riot.mount(this.content, 'r-projects-index', {api: opts.api, page: page, query: decodeURIComponent(query)})
  })
  riot.route('projects/new', () => {
    riot.mount(this.content, 'r-projects-brief', {api: opts.api})
  })
  riot.route('projects/*', (id) => {
    riot.route(`/projects/${id}/overview`, 'Overview', true)
  })
  riot.route('projects/*/payments', (id) => {
    riot.mount(this.content, 'r-projects-show', {
      api: opts.api,
      id: id,
      tab: `r-project-quotes`,
      activeTabName: 'payments',
      contentOpts: {
        id: id,
        tab: 'payments'
      }
    })
  })
  riot.route('projects/*/*', (id, tab) => {
    riot.mount(this.content, 'r-projects-show', {
      api: opts.api,
      id: id,
      tab: `r-project-${tab}`,
      activeTabName: tab,
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
      readonly: (this.currentAccount && this.currentAccount.isProfessional)
    })
  })
  riot.route('projects/*/quotes/new', (project_id) => {
    riot.mount(this.content, 'r-quotes-form', {
      api: opts.api,
      project_id: project_id
    })
  })

  riot.route('projects/*/quotes/*/payments', (project_id, quote_id) => {
    riot.mount(this.content, 'r-projects-show', {
      api: opts.api,
      id: project_id,
      tab: `r-project-quotes`,
      contentOpts: {
        id: project_id,
        tab: 'payments',
        quote_id: quote_id
      }
    })
  })
  riot.route('projects/*/quotes/*/payments/*', (project_id, quote_id, id) => {
    riot.mount(this.content, 'r-projects-show', {
      api: opts.api,
      id: project_id,
      tab: `r-project-quotes`,
      contentOpts: {
        id: project_id,
        tab: 'payments',
        payment_id: id,
        quote_id: quote_id
      }
    })
  })
  riot.route('projects/*/quotes/*', (project_id, id) => {
    // console.log(this.currentAccount)
    riot.mount(this.content, 'r-quotes-form', {
      api: opts.api,
      project_id: project_id,
      id: id,
      readonly: (this.currentAccount && this.currentAccount.isCustomer)
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

  // if (this.currentAccount && this.currentAccount.isAdministrator) {
  //this.mixin('admin')

    _.each(['content/',''], (ns) => {
      riot.route(`admin/${ns}*`, (resource) => {
        this.renderAdminIndex(ns, resource, {resource: resource, api: opts.api, page: 1})
      })
      riot.route(`admin/${ns}*/page/*`, (resource, page) => {
        this.renderAdminIndex(ns, resource, {resource: resource, api: opts.api, page: page})
      })
      riot.route(`admin/${ns}*/page/*/order/*`, (resource, page, order) => {
        this.renderAdminIndex(ns, resource, {resource: resource, api: opts.api, page: page, order: order.split(',')})
      })
      riot.route(`admin/${ns}*/search/*/page/*`, (resource, query, page) => {
        this.renderAdminIndex(ns, resource, {resource: resource, api: opts.api, page: page, query: decodeURIComponent(query)})
      })
      riot.route(`admin/${ns}*/search/*/page/*/order/*`, (resource, query, page, order) => {
        this.renderAdminIndex(ns, resource, {resource: resource, api: opts.api, page: page, query: decodeURIComponent(query), order: order.split(',')})
      })

      riot.route(`admin/${ns}*/new`, (resource) => {
        //this.renderAdminIndex(ns, resource, {resource: resource, api: opts.api, page: 1})
        this.renderAdminForm(ns, resource, {})
      })
      riot.route(`admin/${ns}*/*/edit`, (resource, id) => {
        //this.renderAdminIndex(ns, resource, {resource: resource, api: opts.api, page: 1})
        if(resource === 'projects') {
          riot.route(`/admin/projects/${id}/edit/overview`, 'Overview', true)
        } else {
          this.renderAdminForm(ns, resource, {item: {id: id}})
        }
      })

      riot.route(`admin/projects/*/edit/*`, (id, tab) => {
        //this.renderAdminIndex(ns, resource, {resource: resource, api: opts.api, page: 1})
        this.renderAdminForm('', 'projects', {tab: `r-admin-project-form-${tab}`, item: {id: id}})
      })

      riot.route(`admin/projects/*/*/new`, (project_id, resource) => {
        //this.renderAdminIndex(ns, resource, {resource: resource, api: opts.api, page: 1})
        this.renderAdminForm('', resource, {project_id: project_id})
      })
      // riot.route(`admin/${ns}*/*`, (resource, id) => {
      //   resource = `${ns}${resource}`
      //   riot.mount(this.content, 'r-admin-show', {resource: resource, api: opts.api, id: id})
      // })
    })
  // }

  riot.route(() => {
    riot.route(`/projects`, 'Projects', true)
  })

  this.mixin('admin')

  </script>
</r-app>
