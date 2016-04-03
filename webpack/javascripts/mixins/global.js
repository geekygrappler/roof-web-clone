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
    'CONFIRM_DELETE': 'Are you sure to delete?',
    'CONFIRM_UNSAVED_CHANGES': 'You have unsaved changes!, if you click OK they will be lost, click cancel to keep them.'
  },
  init: function () {
    if (this.parent && this.parent.opts.api) this.opts.api = this.parent.opts.api
    if (this.opts.api) this.currentAccount = this.opts.api.currentAccount
    this.on('mount', this.initDomPlugins)
    this.showAuthModal = this.showAuthModal || this._showAuthModal
  },
  request: request,
  dot: new dot('.', true), // allow overrides!
  serializeForm: function (form, options = {parseAll: true}) {
    return $(form).serializeJSON(options)
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
    case 412: //InvalidAuthenticityToken
      $.csrfToken = null
      //window.reload()
      console.log('InvalidAuthenticityToken', xhr)
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
  filename: function (url) {
    let names = url.split('/')
    return names[names.length - 1]
  },
  formatCurrency: function (number) {
    return numeral(number / 100).format('$0,0.00');
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
      if (!$(e.currentTarget).attr('target')) {
        e.preventDefault()
        riot.route($(e.currentTarget).attr('href').substr(5), e.currentTarget.title)
      }
    })
  },
  _showAuthModal: function () {
    riot.mount('r-modal', {
      content: 'r-auth',
      persisted: true,
      api: this.opts.api,
      contentOpts: {tab: 'r-signup', api: this.opts.api}
    })
  },
  preventSubmit: function (e) { e.preventDefault() },
  isAllValuesEmpty: function (data) {
    return _.isEmpty(_.compact(_.values(data)))
  },
  loadResources: function(resource, options = {}) {
    // BUGYY!!!!
    // let key = `index.${resource}:${JSON.stringify(options)}`
    // if (this.opts.api[resource].cache[key]) {
    //   this[resource] = this.opts.api[resource].cache[key]
    //   this.update()
    // } else {
      this.opts.api[resource].index(options).then(data => {
        // this[resource] = this.opts.api[resource].cache[key] = data
        this[resource] = data
        this.update()
      })
    // }
  },
  updateReset: function () {
    this.update({busy: false, errors: null})
  },
  closeModal: function () {
    $('r-modal')[0] && $('r-modal')[0]._tag && $('r-modal')[0]._tag.close()
  },
  gaSend: function () {
    var params = Array.prototype.slice.call(arguments)
    params.unshift('send')
    console.log(params)
    //ga.apply(ga, params)
  },
  sendGALeadConfirmationConversion: function () {
    var google_conversion_id = 913725911;
    var google_conversion_language = "en";
    var google_conversion_format = "3";
    var google_conversion_color = "ffffff";
    var google_conversion_label = "VbuCCK7d7WIQ17PZswM";
    var google_remarketing_only = false;
    return $.getScript('//www.googleadservices.com/pagead/conversion.js').then( () => {
      var image = new Image()
      image.src = '//www.googleadservices.com/pagead/conversion/913725911/?label=VbuCCK7d7WIQ17PZswM&amp;guid=ON&amp;script=0'
      return image
    })
  }
})
