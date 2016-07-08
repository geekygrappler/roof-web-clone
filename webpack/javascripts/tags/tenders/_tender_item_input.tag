import Handlebars from 'handlebars/dist/handlebars'

<r-tender-item-input>
  <div class="relative">
    <form onsubmit="{ preventSubmit }">
      <input name="query" type="text" class="block col-12 field"
      oninput="{ search }" onkeyup="{ onkey }"
      placeholder="Start typing to add {opts.name}" autocomplete="off" />
    </form>
  </div>
  <script>

  //this.request({url: `/api/${this.opts.name.plural()}`}).then((data) => {
    let source = new Bloodhound({
      datumTokenizer:  function (d) {
        return Bloodhound.tokenizers.whitespace(`${d.action} ${d.group} ${d.name} ${d.tags && d.tags.join(' ')}`)
      },
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      // local: data[this.opts.name.plural()],
      sufficient: 10,
      remote: {
        url: `/api/${this.opts.name.plural()}?query=%QUERY`,
        wildcard: '%QUERY',
        transform:  (data) => {
          return data[this.opts.name.plural()]
        }
      }
    })


    $(this.query)
    .on('typeahead:notfound', (e) => {
      this.addDefaultItem()
    })
    .on('typeahead:render', (e, suggestions) => {

        delete this['currentTask']

        // reversing the list too so that it starts at the bottom when typeahead is above input,
        // unfortunately this doesnt work due to the typeahead:select method adding the wrong data to the element
        // var lis = document.querySelectorAll('.tt-dataset > .tt-suggestion');
        // var contents = [].map.call(lis, function (li) {
        //     return li.innerHTML;
        // }).reverse().forEach(function (content, i) {
        //     lis[i].innerHTML = content;
        // });

        $('.tt-menu').css('top', '').css('bottom', '100%')
        // .scrollTop(400)
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
  //})

  this.onkey  = (e) => {
    if (e.keyCode === 13) {
        this.addDefaultItem()
        this.opts.enter.apply(this.opts.tender)
        $(this.query).typeahead('val', '')
    }
  }

  this.addDefaultItem = () => {
    var val = $(this.query).typeahead('val')
    if (val) {
      this.selectItem(this.getDefaultItem(val))
    }
  }

  this.selectItem =  (item) => {
    $(this.query).typeahead('val', item.name)
    this.currentTask = item
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
      this.currentTask = item
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
