import riot from 'riot'

riot.mixin('teamTab', {
  init: function () {
    this.isPast = (time) => {
      return new Date(time.split(' ')[0]) < new Date()
    }
    this.isFuture = (time) => {
      return new Date(time.split(' ')[0]) >= new Date()
    }

    this.getName = function () {
      return this.id !== this.currentAccount.id ? this.fullName() : 'You'
    }
    this.fullName = function () {
      return `${this.profile.first_name} ${this.profile.last_name}`
    }

    this.submit = (e) => {

      e.preventDefault()

      let data = this.serializeForm(this.form)

      if (_.isEmpty(data)) {
        $(this.form).animateCss('shake')
        return
      }

      this.update({busy: true, errors: null})

      this.opts.api.invitations.invite(data)
      .fail(this.errorHandler)
      .then(invitation => {
        this.update({busy:false})
        this.form.reset()
      })

    }
  }
})
