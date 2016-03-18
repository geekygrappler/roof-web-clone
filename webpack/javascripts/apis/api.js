import riot from 'riot'
import request from './request'

let apis = {
  unauthenticatedRoot: '/',
  authenticatedRoot: '/projects',
  sessions: riot.observable(),
  registrations: riot.observable(),
  passwords: riot.observable(),
  invitations: riot.observable()
}
class Account {
  constructor(account) {
    _.extend(this, account)
  }

  get isCustomer() {
    return this.user_type === 'Customer'
  }
  get isProfessional() {
    return this.user_type === 'Professional'
  }
  get isAdministrator() {
    return this.user_type === 'Administrator'
  }
}
let resources = ['projects', 'leads', 'tenders', 'quotes', 'appointments']
resources.forEach((api) =>{
  apis[api] = riot.observable()
  apis[api].cache = {}

  apis[api].index = function (data) {
    return request({
      url: `/api/${api}`,
      data: data
    })
    .fail((xhr) => {
      apis[api].trigger('index.fail', xhr)
      return xhr
    })
    .then((data) => {
      apis[api].trigger('index.success', data)
      return data
    })
  }

  apis[api].show = function (id) {
    return request({url: `/api/${api}/${id}`})
    .fail((xhr) => {
      apis[api].trigger('show.fail', xhr)
      return xhr
    })
    .then((data) => {
      apis[api].trigger('show.success', data)
      return data
    })
  }

  apis[api].create = function (data) {
    return request({
      url: `/api/${api}`,
      type: 'post',
      data: {[api.singular()]: data}
    })
    .fail((xhr) => {
      apis[api].trigger('create.fail', xhr)
      return xhr
    })
    .then((data) => {
      apis[api].trigger('create.success', data)
      return data
    })
  }

  apis[api].update = function (id, data) {
    return request({
      url: `/api/${api}/${id}`,
      type: 'put',
      data: {[api.singular()]: data}
    })
    .fail((xhr) => {
      apis[api].trigger('update.fail', xhr)
      return xhr
    })
    .then(() => {
      apis[api].trigger('update.success', id)
      return id
    })
  }

  apis[api].delete = function (id) {
    return request({url: `/api/${api}/${id}`, type: 'delete'})
    .fail((xhr) => {
      apis[api].trigger('delete.fail', xhr)
      return xhr
    })
    .then(() => {
      apis[api].trigger('delete.success', id)
      return id
    })
  }
})

apis.sessions.check = function () {
  return request({
    type: 'get',
    url: '/api/accounts/sign_in'
  })
  .fail((xhr) => {
    apis.sessions.trigger('check.fail', xhr)
  })
  .then((data) => {
    $.csrfToken = null
    apis.currentAccount = new Account(data)
    //riot.route(apis.authenticatedRoot)
    apis.sessions.trigger('check.success', data)
    return data
  })
}
apis.sessions.signin = function (creds) {
  return request({
    type: 'post',
    url: '/api/accounts/sign_in',
    data: {account: creds}
  })
  .fail((xhr) => apis.sessions.trigger('signin.fail', xhr))
  .then((data) => {
    $.csrfToken = null
    apis.currentAccount = new Account(data)
    //riot.route(apis.authenticatedRoot)
    apis.sessions.trigger('signin.success', data)
    return data
  })
}
apis.sessions.signout = function (creds) {
  return request({
    type: 'delete',
    url: '/api/accounts/sign_out',
    data: {account: creds}
  })
  .fail((xhr) => apis.sessions.trigger('signout.fail', xhr))
  .then(() => {
    $.csrfToken = null
    apis.currentAccount = null
    delete apis.currentAccount
    apis.sessions.trigger('signout.success')
    window.location.href = apis.unauthenticatedRoot
  })
}
apis.registrations.signup = function (data) {
  return request({
    type: 'post',
    url: '/api/accounts',
    data: {account: data}
  })
  .fail((xhr) => apis.registrations.trigger('signup.fail', xhr))
  .then((data) => {
    $.csrfToken = null
    apis.currentAccount = new Account(data)
    //riot.route(apis.authenticatedRoot)
    apis.registrations.trigger('signup.success', data)
    return data
  })
}
apis.quotes.submit = function (id) {
  return request({
    url: `/api/quotes/${id}/submit`,
    type: 'put'
  })
  .fail((xhr) => {
    apis.quotes.trigger('update.fail', xhr)
    return xhr
  })
  .then(() => {
    apis.quotes.trigger('update.success', id)
    return id
  })
}
apis.quotes.accept = function (id) {
  return request({
    url: `/api/quotes/${id}/accept`,
    type: 'put'
  })
  .fail((xhr) => {
    apis.quotes.trigger('update.fail', xhr)
    return xhr
  })
  .then(() => {
    apis.quotes.trigger('update.success', id)
    return id
  })
}

apis.invitations.invite = function (data) {
  return request({
    url: `/api/invitations/invite`,
    type: 'post',
    data: {invitation: data}
  })
  .fail((xhr) => {
    apis.invitations.trigger('invite.fail', xhr)
    return xhr
  })
  .then((data) => {
    apis.invitations.trigger('invite.success', data)
    return data
  })
}
apis.invitations.accept = function (data) {
  return request({
    url: `/api/invitations/accept`,
    type: 'post',
    data: {invitation: data}
  })
  .fail((xhr) => {
    apis.invitations.trigger('accept.fail', xhr)
    return xhr
  })
  .then((data) => {
    $.csrfToken = null
    apis.currentAccount = new Account(data.invitee)
    apis.invitations.trigger('accept.success', data)
    apis.registrations.trigger('signup.success', data.invitee)
    return data
  })
}


export default apis
