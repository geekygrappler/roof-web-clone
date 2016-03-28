import riot from 'riot'

const VAT = 20

riot.mixin('tenderMixin', {
  warnUnsavedChanges: function () {
    if (!this.saved) return this.ERRORS.CONFIRM_UNSAVED_CHANGES
  },
  init: function () {

    this.preventUnsaved = (e) => {
      e.preventDefault()
      if( this.saved || (!this.saved && window.confirm(this.ERRORS.CONFIRM_UNSAVED_CHANGES)) ) {
        riot.route($(e.currentTarget).attr('href').substr(5), e.currentTarget.title, true)
      }
    }

    this.setUnsaved = () => {
      console.log('unsaved')
      this.saved = false
    }

    this.on('mount', () => {
      this.saved = true
      this.opts.api.tenders.on('update', this.updateTenderTotal)
      window.onbeforeunload = this.warnUnsavedChanges
      $('a[href*="/app/"]', this.root).off('click').on('click',  this.preventUnsaved)
      this.submit = _.wrap(this.submit, (_submit, e) => {
        this.saved = true
        _submit(e)
      })

      $(this.root).bind('input', 'input', this.setUnsaved)
    })

    this.on('unmount', () => {
      $('a[href*="/app/"]', this.root).off('click',  this.preventUnsaved)
      this.opts.api.tenders.off('update', this.updateTenderTotal)
      window.onbeforeunload = null
      $(this.root).unbind('input', 'input', this.setUnsaved)

    })

    this.updateTenderTotal = () => {
      this.tenderTotal()
      this.update()
    }
    
    this.addSection = (e) => {
      e.preventDefault()
      if (_.isEmpty(this.sectionName.value)) {
        return $(e.currentTarget).animateCss('shake')
      }
      let section = {
        id: this.record.document.sections.length + 1,
        name: this.sectionName.value,
        tasks: [],
        materials: []
      }
      this.record.document.sections.push(section)
      this.sectionName.value = null
      this.update()
      // $('[name=searchable_names]').last()[0].focus()
    }
    this.removeSection = (e) => {
      e.preventDefault()
      if (window.confirm(this.ERRORS.CONFIRM_DELETE)) {
        let index = _.findIndex(this.record.document.sections, s => s.id == e.item.id)
        this.record.document.sections.splice(index, 1)
        this.update()
      }
    }
    this.sectionTotal = (section, formatted = false) => {
      let itemTotal = _.reduce(section.tasks, (total, item) => {
        return total + item.price * item.quantity
      }, 0)
      let materialTotal = _.reduce(section.materials, (total, item) => {
        return total + (item.supplied ? item.price * item.quantity : 0)
      }, 0)
      if (formatted) {
        // return this.formatCurrency(itemTotal + (itemTotal * VAT / 100) + materialTotal)
        return this.formatCurrency(itemTotal + materialTotal)
      } else {
        return [itemTotal, materialTotal]
      }
    }
    this.tenderTotal = () => {
      return this.formatCurrency(
        _.reduce(this.record.document.sections, (total, section) => {
          let [itemTotal , materialTotal] = this.sectionTotal(section)
          return (total + itemTotal + (itemTotal * 20 / 100) + materialTotal)
        }, 0)
      )
    }
  }
})
