<r-comments>
  <h3>Comments</h3>

  <blockquote each="{opts.item.comments}" class="clearfix m0 p1 border-left mb1">
    {text}
    <a class="btn btn-small border-red red right" onclick="{remove}" if="{account.id == currentAccount.id}">
      <i class="fa fa-trash-o"></i>
    </a>
    <div class="h5 right-align mt1"><strong>{account.name}</strong> <span class="italic">{fromNow(date)}</span></div>
  </blockquote>


  <form name="form" onsubmit="{submit}" class="mt2">
    <textarea class="block col-12 mb2 field" name="text" placeholder="Leave your comment"></textarea>
    <button class="btn btn-primary">Comment</button>
  </form>
  <script>
  this.submit = (e) =>{
    e.preventDefault()
    this.opts.item.comments = this.opts.item.comments || []
    this.opts.item.comments.push({
      text: this.text.value,
      account: {id: this.currentAccount.id, name: `${this.currentAccount.profile.first_name} ${this.currentAccount.profile.last_name}`},
      date: new Date(),
      id: this.opts.item.comments.length + 1
    })
    this.text.value = null
    this.update()
  }
  this.remove = (e) => {
    e.preventDefault()
    var _id = _.findIndex(this.opts.item.comments, c => c.id == e.item.id)
    if (_id > -1) {
      this.opts.item.comments.splice(_id, 1)
      this.update()
    }
  }
  </script>
</r-comments>

<r-tender-item>
  <li class="relative">
    <div if="{opts.border_cleaner}" class="border-cleaner absolute"></div>
    <div class="clearfix animate p1 border-bottom">
      <div if="{ parent.headers.name }" class="sm-col sm-col-{ parent.headers.name } mb1 sm-mb0">
        <input type="text" name="name" value="{ display_name || name }"
        class="fit field inline-input align-left col-12" oninput="{ inputname }" />
        <hr class="sm-hide">
      </div>

      <div if="{ parent.headers.quantity }" class="col sm-col-{ parent.headers.quantity } col-3 center">
        <input type="number" name="quantity" value="{ quantity }" min="0"
        class="fit field inline-input center" oninput="{ input }" />
      </div>

      <div if="{ parent.headers.price }" class="col sm-col-{ parent.headers.price } col-{parent.opts.name == 'task' ? 3 : 2} center">
        <input type="number" name="price" value="{ parent.opts.name == 'task' ? price / 100 : (supplied ? price / 100 : 0) }"
        disabled="{ parent.opts.name == 'material' && !supplied }" step="1" min="0" class="fit field inline-input center" oninput="{ input }" />
      </div>

      <div if="{ parent.headers.total_cost }" class="col sm-col-{ parent.headers.total_cost } col-3 center">
        { this.formatCurrency(parent.opts.name == 'task' ? (price * quantity) : (supplied ? price * quantity : '0')) }
      </div>

      <div if="{ parent.headers.supplied }" class="col sm-col-{ parent.headers.supplied } col-1 center">
        <input if="{ parent.opts.name == 'material'}" type="checkbox" name="supplied"
        checked="{ supplied }" class="align-middle" onchange="{ input }" />
      </div>

      <div if="{ parent.headers.actions }" class="col sm-col-{ parent.headers.actions } col-2 center">
        <a href="#" class="btn btn-small border-red red" onclick="{ removeItem }"><i class="fa fa-trash-o"></i></a>
        <a href="#" class="btn btn-small border" onclick="{ openComments }"><i class="fa fa-comment-o"></i></a>
      </div>
    </div>
  </li>

  <script>
  this.on('mount', () => {
    // $('.animate', this.root).animateCss('bounceIn')
  })

  this.input = (e) => {
    e.item[e.target.name] = e.target.type === 'checkbox' ? e.target.checked : (e.target.name === 'price' ? parseInt(e.target.value) * 100 : parseInt(e.target.value))
    this.update()
    this.opts.api.tenders.trigger('update')
  }
  this.inputname = (e) => {
    e.item.display_name = e.target.value
    this.update()
    this.opts.api.tenders.trigger('update')
  }

  this.removeItem = (e) => {
    e.preventDefault()
    if (window.confirm(this.ERRORS.CONFIRM_DELETE)) {
    // $('.animate', this.root).one($.animationEnd, () => {
      this.parent.opts.onitemremoved(e, this.parent.opts.name)
    // } ).animateCss('bounceOut')
    }
  }

  this.openComments = (e) => {
    e.preventDefault()
    // console.log(this.parent.parent.section)
    riot.mount('r-modal', {
      content: 'r-comments',
      persisted: false,
      api: opts.api,
      contentOpts: {api: opts.api, commentable: this.parent.parent.record, item: e.item}
    })
  }
  </script>
</r-tender-item>
