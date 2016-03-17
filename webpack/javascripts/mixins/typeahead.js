import _ from 'underscore'

riot.mixin('typeaheadMixin', {

  init: function () {
    this.search = _.debounce(() => {
      if (this.query.value) {
        this.request({
          type: this.apiMethod,
          url: this.apiPath,
          data: {query: this.query.value}
        })
        .then((data) => {
          this.update({data: data})
          this.scrollTo()
        })
      } else {
        this.update({data: null})
      }
    }, 200)
  },
  onKey: function (e) {
    let cursorTop

    if (e.target.value && this.data && this.data.length > 0) {
      switch (e.code) {
        case "ArrowDown":
          if (this.index + 1 < this.data.length) this.index++
          cursorTop = this.getCursorTop()
          if (cursorTop > this.list.scrollTop + this.list.clientHeight) this.list.scrollTop = cursorTop

        break;
        case "ArrowUp":
          if (this.index - 1 > -1) this.index--
          cursorTop = this.getCursorTop()
          if (cursorTop < this.list.scrollTop) this.list.scrollTop = cursorTop

        break;
        case "Enter":
        if (this.index >= 0) {
          this.selectItem({item: this.data[this.index]})

        }
        break;
      }
    } else if (e.target.value) {
      if (e.code == "Enter") {
        this.selectItem({
          item: this.getDefaultItem(e.target.value)
        })

      }
    }
  },
  isCursor: function (item) {
    return this.cursorId && item[this.identifier] && this.cursorId === item[this.identifier]
  },
  moveCursor: function (e) {
    let cursorId = e.item[this.identifier]
    this.update({cursorId: cursorId, index: _.findIndex(this.data, {[this.identifier]: cursorId})})
  },
  selectItem: function (e) {
    this.query.value = null
    // console.log(e.item)
    this.trigger('itemselected', e.item)
    this.update({data: null, index: -1})
  },
  getCursorTop: function () {
    this.update({cursorId: this.data[this.index][this.identifier]})
    return $('.cursor', this.root).position().top
  },
  scrollTo: function () {
    let $list = $(this.list)
    let sTop = $list.height() + $list.offset().top
    if ( sTop > document.body.scrollTop) $('body, html').animate({scrollTop: sTop})
  }
})
