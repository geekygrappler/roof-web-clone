import request from '../apis/request'
import dot from 'dot-object'
import moment from 'moment'
import numeral from 'numeral/numeral'
import language from 'numeral/languages/en-gb'
numeral.language('en-gb', language)
numeral.language('en-gb')

riot.mixin({
  ERRORS: {
    0: 'Hmm, something not right, you may try again later or contact with us.',
    401: 'Hmm, are you sure given email and password are correct?',
    403: 'Hmm, are you sure you are allowed to do that?',
    404: 'Whops 404! Whatever you are looking for is not found!',
    500: 'Ops!, something went wrong at our end, try again later.',
    'ASSET_ASSIGNMENT': 'We got your brief, but unfortunately your files lost on the way to us',
    'BLANK': 'cannot be blank',
    'CONFIRM_DELETE': 'Are you sure to delete this file?'
  },
  init: function () {
    if (this.parent && this.parent.opts.api) this.opts.api = this.parent.opts.api
    if (this.opts.api) this.currentAccount = this.opts.api.currentAccount
    this.on('mount', this.initDomPlugins)
    this.showAuthModal = this.showAuthModal || this._showAuthModal
  },
  request: request,
  dot: new dot('.', true), // allow overrides!
  serializeForm: function (form) {
    return $(form).serializeJSON({parseAll: true})
  },
  errorHandler: function (xhr) {
    this.update({busy: false})
    switch(xhr.status) {
    case 422:
      this.update({errors: (xhr.responseJSON.errors || xhr.responseJSON.error || xhr.responseJSON)})
      break;
    case 401:
      this.showAuthModal()
      break;
    case 403:
      alert(this.ERRORS[403])
      break;
    case 404:
      alert(this.ERRORS[404])
      break;
    case 500:
      alert(this.ERRORS[500])
      break;
    default:
      alert(this.ERRORS[0])
      break;
    }
    return xhr
  },
  formatCurrency: function (number) {
    return numeral(number).format('$0,0.00');
  },
  formatTime: function(time) {
    return moment(time).format('MM Do YY')
  },
  fromNow: function (time) {
    return moment(time).fromNow()
  },
  initDomPlugins: function () {
    $('[data-disclosure]', this.root).disclosure(this.showDisclosures)
    $('a[href*="/app/"]', this.root).on('click', function (e) {
      e.preventDefault()
      riot.route($(e.currentTarget).attr('href').substr(5), e.currentTarget.title, true)
    })
  },
  _showAuthModal: function () {
    riot.mount('r-modal', {
      content: 'r-auth',
      persisted: false,
      api: this.opts.api,
      contentOpts: {tab: 'r-signup', api: this.opts.api}
    })
  },
  preventSubmit: function (e) { e.preventDefault() },
  isAllValuesEmpty: function (data) {
    return _.isEmpty(_.compact(_.values(data)))
  },
  openForm: function (formTag, e, resource) {
    return riot.mount('r-modal', {
      content: formTag,
      persisted: false,
      api: this.opts.api,
      classes: 'sm-col-12 sm-px3 px1',
      contentOpts: {
        resource: this.opts.resource || resource,
        id: e.item && (e.item.id || e.item.record && e.item.record.id),
        api: this.opts.api,
        attributes: []
      }
    })
  },
  loadResources: function(resource) {
    if (this.opts.api[resource].cache.index) {
      this[resource] = this.opts.api[resource].cache.index
      this.update()
    } else {
      this.opts.api[resource].index().then(data => {
        this[resource] = this.opts.api[resource].cache.index = data
        this.update()
      })
    }
  },
  updateReset: function () {
    this.update({busy: false, errors: null})
  }
})
