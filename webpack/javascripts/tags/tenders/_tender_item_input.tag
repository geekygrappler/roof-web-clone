import Handlebars from 'handlebars/dist/handlebars'

<r-tender-item-input>
  <div class="relative">
    <form onsubmit="{ preventSubmit }">
      <input name="query" type="text" class="block col-12 field"
      oninput="{ search }" onkeyup="{ onKey }"
      placeholder="Search and add {modelName}" autocomplete="off" />
    </form>
    <i class="fa fa-{ opts.icon } absolute right-0 top-0 p1"></i>
  </div>
  <script>

  this.request({url: `/api/${this.opts.name.plural()}`}).then((data) => {

    let source = new Bloodhound({
      datumTokenizer:  function (d) {
        return Bloodhound.tokenizers.whitespace(`${d.action} ${d.group} ${d.name} ${d.tags && d.tags.join(' ')}`)
      },
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      local: data,
      sufficient: 10,
      remote: {
        url: `/api/${this.opts.name.plural()}?query=%QUERY`,
        wildcard: '%QUERY'
      }
    })

    $(this.query)
    .on('typeahead:notfound', (e) => {
      this.selectItem(
        this.getDefaultItem($(this.query).typeahead('val'))
      )
    })
    .on('typeahead:select', (e, suggestion) => {
      this.selectItem(suggestion)
    })
    .typeahead(null, {
      name: this.opts.name.plural(),
      source: source,
      display: 'name',
      limit: 10,
      templates: {
        empty:`
        <div class="empty-message border-bottom typeahead-item p1">
          unable to find any ${opts.name} that match the current query, hit enter to add in Other category
        </div>`
        ,
        suggestion: Handlebars.compile(`
          <div class="border-bottom typeahead-item">
            <a class="cursor-pointer p2"><span class="bg-orange p1">{{action}}</span> {{name}}</a>
          </div>
        `)
      }
    });
  })

  this.selectItem =  (item) => {
    $(this.query).typeahead('val', null)
    this.trigger('itemselected', item)
  }

  this.getDefaultItem = (name) => {
    let item
    if (opts.name === 'task') {
      item = {
        name: name,
        action: 'Other',
        group: 'Other',
        quantity: 1,
        price: 0,
        unit: 'unitless'
      }
    } else if (opts.name === 'material') {
      item = {
        name: name,
        quantity: 1,
        price: 0,
        supplied: false
      }
    }
    return item
  }

  if (this.opts.auto_focus) {
    this.on('mount', () => {
      _.defer( () => this.query.focus() )
    })
  }
  </script>
</r-tender-item-input>
