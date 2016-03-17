import riot from 'riot'

riot.mixin('tenderMixin', {
  init: function () {
    this.on('mount', () => {
      this.opts.api.tenders.on('update', this.updateTenderTotal)
    })

    this.on('unmount', () => {
      this.opts.api.tenders.off('update', this.updateTenderTotal)
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
        id: this.tender.document.sections.length + 1,
        name: this.sectionName.value,
        tasks: [],
        materials: []
      }
      this.tender.document.sections.push(section)
      this.sectionName.value = null
      this.update()
      // $('[name=searchable_names]').last()[0].focus()
    }
    this.removeSection = (e) => {
      e.preventDefault()
      let index = _.findIndex(this.tender.document.sections, s => s.id == e.item.id)
      this.tender.document.sections.splice(index, 1)
      this.update()
    }
    this.tenderTotal = () => {

      return _.reduce(this.tender.document.sections, (total, section) => {

        let itemTotal = _.reduce(section.tasks, (total, item) => {
          return total + item.price * item.quantity
        }, 0)
        let materialTotal = _.reduce(section.materials, (total, item) => {
          return total + (item.is_supplied ? item.price * item.quantity : 0)
        }, 0)

        return this.formatCurrency(total + itemTotal + (itemTotal * 20 / 100) + materialTotal)
      }, 0)
    }
  }
})