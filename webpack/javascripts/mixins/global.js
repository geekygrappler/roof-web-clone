import request from '../apis/request'

riot.mixin({
  ERRORS: {
    0: 'Hmm, something not right, you may try again later or contact with us.',
    401: 'Hmm, are you sure given email and password are correct?',
    403: 'Hmm, are you sure you are allowed to do that?',
    404: 'Whops 404! Whatever you are looking for is not found!',
    500: 'Ops!, something went wrong at our end, try again later.',
  },
  initialize: function () {
    if (this.parent && this.parent.opts.api) this.opts.api = this.parent.opts.api
  },
  request: request,
  serializeForm: function (form) {
    return $(form).serializeJSON()
  },
  errorHandler: function (xhr) {
    this.update({busy: false})
    switch(xhr.status) {
    case 422:
      this.update({errors: xhr.responseJSON.errors})
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
  }
})
