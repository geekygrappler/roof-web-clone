import riot from 'riot'
import api from './apis/api'
import 'inflector/lib/inflector'
import './mixins/global'
import './mixins/admin'
import './tags/app.tag'

riot.route.base('/app/')
let mount = () => {
  riot.mount('r-app', {api: api, app: {}})
  riot.route.start(true)
}
let showApp = () => {
  setTimeout(() => $('r-app').removeClass('display-none'), 0)
}
api.sessions.one('check.fail', mount)
api.sessions.one('check.success', () => {
  mount()
  showApp()
})
api.sessions.on('signin.success', showApp)
api.registrations.on('signup.success', showApp)
api.sessions.check()
