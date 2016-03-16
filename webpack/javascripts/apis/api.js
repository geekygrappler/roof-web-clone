import riot from 'riot'
import request from './request'

let apis = {
  unauthenticatedRoot: '/',
  authenticatedRoot: '/projects',
  sessions: riot.observable(),
  registrations: riot.observable(),
  passwords: riot.observable()
}
let resources = ['projects']
resources.forEach((api) =>{
  apis[api] = riot.observable()

  apis[api].index = function (data) {
    return request({
      url: `/api/${api}`,
      data: {[api.singular()]: data}
    })
    .fail((xhr) => apis[api].trigger('index.fail', xhr))
    .then((data) => apis[api].trigger('index.success', data))
  }

  apis[api].show = function (id) {
    return request({url: `/api/${api}/${id}`})
    .fail((xhr) => apis[api].trigger('show.fail', xhr))
    .then((data) => apis[api].trigger('show.success', data))
  }

  apis[api].create = function (data) {
    return request({
      url: `/api/${api}`,
      type: 'post',
      data: {[api.singular()]: data}
    })
    .fail((xhr) => apis[api].trigger('create.fail', xhr))
    .then((data) => apis[api].trigger('create.success', data))
  }

  apis[api].update = function (id, data) {
    return request({
      url: `/api/${api}/${id}`,
      type: 'put',
      data: {[api.singular()]: data}
    })
    .fail((xhr) => apis[api].trigger('update.fail', xhr))
    .then((data) => apis[api].trigger('update.success', id))
  }

  apis[api].delete = function (id) {
    return request({url: `/api/${api}/${id}`, type: 'delete'})
    .fail((xhr) => apis[api].trigger('delete.fail', xhr))
    .then((data) => apis[api].trigger('delete.success', id))
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
    apis.currentAccount = data
    riot.route(apis.authenticatedRoot)
    apis.sessions.trigger('check.success', data)
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
    apis.currentAccount = data
    riot.route(apis.authenticatedRoot)
    apis.sessions.trigger('signin.success', data)
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
    apis.currentAccount = data
    riot.route(apis.authenticatedRoot)
    apis.registrations.trigger('signup.success', data)
  })
}

export default apis
