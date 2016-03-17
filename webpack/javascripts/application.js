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
api.sessions.one('check.success', mount)
api.sessions.check()
