import riot from 'riot'
import api from './apis/api'
import 'inflector/lib/inflector'
import './mixins/global'
import './tags/app.tag'

riot.route.base('/app/')
let mount = () => {
  riot.mount('r-app', {api})
  riot.route.start(true)
}
api.sessions.one('check.fail', mount)
api.sessions.one('check.success', () => {
  $('r-app').removeClass('display-none')
  mount()
})
api.sessions.on('signin.success', () => $('r-app').removeClass('display-none'))
api.sessions.on('signup.success', () => $('r-app').removeClass('display-none'))
api.sessions.check()
