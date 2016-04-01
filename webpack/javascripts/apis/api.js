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
let resources = [
  'customers', 'professionals', 'administrators',

  'leads',
  'accounts',
  'projects',
  'payments',
  'quotes',
  'tenders',
  'tender_templates',
  'materials',
  'tasks',
  'appointments',
  'assets',
  'comments',

  'content/templates',
  'content/pages'
]
resources.forEach((api) =>{
  apis[api] = riot.observable()
  apis[api].cache = {}

  apis[api].new = function () {
    return request({
      url: `/api/${api}/new`,
    })
    .fail((xhr) => {
      apis[api].trigger('new.fail', xhr)
      return xhr
    })
    .then((data) => {
      apis[api].trigger('new.success', data)
      return data
    })
  }

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
      if(data.meta) {
        apis[api].meta = data.meta
        data = data[api]
      }
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
    url: '/api/auth/sign_in'
  })
  .fail((xhr) => {
    apis.sessions.trigger('check.fail', xhr)
  })
  .then((data) => {
    $.csrfToken = null
    if (data.account) {
        apis.currentAccount = new Account(data.account)
        apis.currentAccount.impersonating = data.impersonator_id ? true : false
        //riot.route(apis.authenticatedRoot)
        apis.sessions.trigger('check.success', data.account)
        return data.account
    } else {
      apis.currentAccount = new Account(data)
      //riot.route(apis.authenticatedRoot)
      apis.sessions.trigger('check.success', data)
      return data
    }
  })
}
apis.sessions.signin = function (creds) {
  return request({
    type: 'post',
    url: '/api/auth/sign_in',
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
    url: '/api/auth/sign_out',
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
apis.sessions.impersonate = function (data) {
  return request({
    type: 'post',
    url: '/api/auth/impersonate',
    data: data
  })
  .fail((xhr) => apis.sessions.trigger('impersonate.fail', xhr))
  .then(() => {
    $.csrfToken = null
    apis.currentAccount = null
    delete apis.currentAccount
    apis.sessions.trigger('impersonate.success')
    window.location.href = "/app"
  })
}
apis.sessions.stopImpersonate = function () {
  return request({
    type: 'delete',
    url: '/api/auth/impersonate'
  })
  .fail((xhr) => apis.sessions.trigger('stop_impersonate.fail', xhr))
  .then(() => {
    $.csrfToken = null
    apis.currentAccount = null
    delete apis.currentAccount
    apis.sessions.trigger('stop_impersonate.success')
    window.location.href = "/app"
  })
}

apis.registrations.signup = function (data) {
  return request({
    type: 'post',
    url: '/api/auth',
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
apis.registrations.update = function (id, data) {
  return request({
    type: 'put',
    url: '/api/auth',
    data: {account: data}
  })
  .fail((xhr) => apis.registrations.trigger('update.fail', xhr))
  .then((id) => {
    //riot.route(apis.authenticatedRoot)
    apis.registrations.trigger('update.success', apis.currentAccount.id)
    return apis.currentAccount
  })
}

apis.quotes.submit = function (id, data) {
  return request({
    url: `/api/quotes/${id}/submit`,
    type: 'put',
    data: {quote: data}
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

apis.payments.approve = function (id, data) {
  return request({
    url: `/api/payments/${id}/approve`,
    type: 'put',
    data: {payment: data}
  })
  .fail((xhr) => {
    apis.payments.trigger('approve.fail', xhr)
    return xhr
  })
  .then(() => {
    apis.payments.trigger('approve.success', id)
    return id
  })
}
apis.payments.refund = function (id) {
  return request({
    url: `/api/payments/${id}/refund`,
    type: 'post'
  })
  .fail((xhr) => {
    apis.payments.trigger('refund.fail', xhr)
    return xhr
  })
  .then(() => {
    apis.payments.trigger('refund.success', id)
    return id
  })
}
apis.payments.pay = function (id, token) {
  return request({
    url: `/api/payments/${id}/pay`,
    type: 'post',
    data: {token: token}
  })
  .fail((xhr) => {
    apis.payments.trigger('pay.fail', xhr)
    return xhr
  })
  .then(() => {
    apis.payments.trigger('pay.success', id)
    return id
  })
}
apis.payments.cancel = function (id) {
  return request({
    url: `/api/payments/${id}/cancel`,
    type: 'delete'
  })
  .fail((xhr) => {
    apis.payments.trigger('cancel.fail', xhr)
    return xhr
  })
  .then(() => {
    apis.payments.trigger('cancel.success', id)
    return id
  })
}


export default apis
