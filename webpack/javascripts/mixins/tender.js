import riot from 'riot'

const VAT = 20

riot.mixin('tenderMixin', {
  warnUnsavedChanges: function () {
    if (!this.saved) return this.ERRORS.CONFIRM_UNSAVED_CHANGES
  },
  init: function () {

    this.includeVat = false

    this.preventUnsaved = (e) => {
      e.preventDefault()
      if( this.saved || (!this.saved && window.confirm(this.ERRORS.CONFIRM_UNSAVED_CHANGES)) ) {
        riot.route($(e.currentTarget).attr('href').substr(5), e.currentTarget.title, true)
      }
    }

    this.setUnsaved = () => {
      this.saved = false
    }

    this.on('mount', () => {
      this.saved = true
      this.opts.api[this.opts.type_underscore].on('update', this.updateTenderTotal)
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
      this.opts.api[this.opts.type_underscore].off('update', this.updateTenderTotal)
      window.onbeforeunload = null
      $(this.root).unbind('input', 'input', this.setUnsaved)

    })

    this.updateTenderTotal = () => {
      //this.tenderTotal()
      this.update({tenderTotal: this.calcTenderTotal()})
      //this.tenderTotal = this.calcTenderTotal()
    }

    this.sections = () => {
      var filterSection = this.tags['r-tender-filters'].section
      return filterSection ? _.filter(this.record.document.sections, (section) => section.id == filterSection): this.record.document.sections
    }

    this.findSectionsInTemplate = (id) => {
      for (var i = 0, ii = this.tenderTemplates; i < ii; i++) {
        if (this.tenderTemplates[i].id = id) {
          return this.tenderTemplates[i]
        }
      }
    }

    this.addSection = (e) => {
      var selectedTemplateIndex = +this.sectionTemplate.value
      e.preventDefault()
      if (_.isEmpty(this.sectionName.value) && selectedTemplateIndex === -1) {
        return $(e.currentTarget).animateCss('shake')
      }
      if (selectedTemplateIndex === -1) {
        var sections = [{
          id: this.record.document.sections.length + 1,
          name: this.sectionName.value,
          tasks: []
        }]
      } else {
        var sections = this.tender_templates[selectedTemplateIndex].document.sections
      }
      this.record.document.sections = this.record.document.sections.concat(sections)
      if (!_.isEmpty(this.sectionName.value) && sections.length > 1) {
        this.record.document.sections[this.record.document.sections.length - 1].name = this.sectionName.value
      }
      this.sectionName.value = null
      this.update()
      this.submit()
      this.currentScrolledSection = this.tags['r-tender-section'][this.tags['r-tender-section'].length - 1]
      $('html, body').animate({
        scrollTop: $(this.currentScrolledSection.root).offset().top
      }, 300);
      this.setSectionOffsets('r-tender-section')
      this.updateTenderTotal()
      // $('[name=searchable_names]').last()[0].focus()
    }
    this.removeSection = (e) => {
      e.preventDefault()
      if (window.confirm(this.ERRORS.CONFIRM_DELETE)) {
        var index = _.findIndex(this.record.document.sections, s => s.id == e.item.section.id)
        if (index > -1) {
          this.record.document.sections.splice(index, 1)
          this.update()
          this.submit()
        }
      }
      this.setSectionOffsets('r-tender-section')
      this.updateTenderTotal()
    }
    this.calcSectionTotal = (section, formatted = false) => {

      var filterAction = this.tags['r-tender-filters'].action

      var tasks = _.isString(filterAction) ? _.filter(section.tasks, task => task.action == filterAction) : section.tasks

      let itemTotal = _.reduce(tasks, (total, item) => {
        return total + item.price * item.quantity
      }, 0)
      let materialTotal = (filterAction == 'Materials' || !filterAction) ? _.reduce(section.materials, (total, item) => {
        return total + (item.supplied ? item.price * item.quantity : 0)
      }, 0) : 0
      section.itemTotal = itemTotal
      section.materialTotal = materialTotal

      if (formatted) {
        // return this.formatCurrency(itemTotal + (itemTotal * VAT / 100) + materialTotal)
        return this.formatCurrency(itemTotal + materialTotal)
      } else {
        return [itemTotal, materialTotal]
      }
    }
    this.tenderVat = () => {
      // console.log('tenderVat')
      return this.formatCurrency( this.record.document.include_vat ?
        _.reduce(this.record.document.sections, (total, section) => {
          var [itemTotal , materialTotal] = section.itemTotal ?
            [section.itemTotal, section.materialTotal] :
            this.calcSectionTotal(section)

          return (total + (itemTotal * 20 / 100))
        }, 0) : 0 )
    }
    this.calcTenderTotal = () => {

      return this.formatCurrency(
        _.reduce(this.sections(), (total, section) => {
          var [itemTotal , materialTotal] = section.itemTotal ?
            [section.itemTotal, section.materialTotal] :
            this.calcSectionTotal(section)

          return (total + itemTotal + materialTotal + (this.record.document.include_vat ? (itemTotal * 20 / 100) : 0))
        }, 0)
      )
    }
    this.toggleVat = (e) => {
      this.record.document.include_vat = !this.record.document.include_vat
      this.tenderTotal = this.calcTenderTotal()
    }
    // let's try autosave
    this.opts.api[this.opts.type_underscore].on('update', () => {
      this.submit()
    })
  }
})
