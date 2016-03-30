import Handlebars from 'handlebars/dist/handlebars'

<r-typeahead-input>
  <div class="relative">
    <form onsubmit="{ preventSubmit }">
      <input name="query" type="text" class="block col-12 mb2 field"
      oninput="{ search }" onkeyup="{ onKey }"
      placeholder="Start typing to search {opts.resource}" autocomplete="off" />
    </form>
  </div>
  <script>
  let selected = false
  this.on('update', () => {
    if (this.opts.id && !selected) {
      selected = true
      this.opts.api[this.opts.resource].index({id: this.opts.id, limit: 1})
      .fail(this.errorHandler)
      .then((records) => {
        this.selected = records[0][this.opts.datum_tokenizer[0]]
        $(this.query).typeahead('val', this.selected)
      })
    }
  })

  // this.request({url: `/api/${this.opts.resource}`}).then((data) => {

    let source = new Bloodhound({
      datumTokenizer: (d) => {
        var token = _.reduce(this.opts.datum_tokenizer, (mem, token) => `${mem} ${d[token]}`)
        return Bloodhound.tokenizers.whitespace(token)
      },
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      sufficient: 1,
      remote: {
        url: `/api/${this.opts.resource}?query=%QUERY`,
        wildcard: '%QUERY',
        prepare: (query, settings) => {
          settings.url = settings.url.replace('%QUERY', query)
          if(this.opts.filters) {
            settings.url += "&" + _.map(this.opts.filters, filter => filter.name + '=' + filter.value).join('&')
          }
          return settings
        },
        transform: (data) => {
          return data[this.opts.resource]
        }
      }
    })

    $(this.query)
    .on('typeahead:notfound', () => {
      $(this.query).typeahead('val', this.selected)
    })
    .on('typeahead:select', (e, suggestion) => {
      this.selectItem(suggestion)
    })
    .typeahead(null, {
      name: this.opts.resource,
      source: source,
      display: this.opts.datum_tokenizer[0],
      limit: 1000,
      templates: {
        empty:`
        <div class="empty-message border-bottom typeahead-item p1">
          unable to find any ${this.opts.resource}
        </div>`
        ,
        suggestion: Handlebars.compile(`
          <div class="border-bottom typeahead-item">
            <a class="cursor-pointer p2">${_.map(this.opts.datum_tokenizer, (t, i) => i == 0 ? '{{'+t+'}}' : '<span class="bg-orange p1 h6">{{'+t+'}}</span>').join(' ')}</a>
          </div>
        `)
      }
    });
  // })

  this.selectItem =  (item) => {
    this.trigger('itemselected', item)
  }

  if (this.opts.auto_focus) {
    this.on('mount', () => {
      _.defer( () => this.query.focus() )
    })
  }
  </script>
</r-typeahead-input>
