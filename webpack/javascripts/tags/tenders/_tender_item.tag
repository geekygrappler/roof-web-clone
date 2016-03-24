<r-comments>
  <h3>Comments</h3>

  <blockquote each="{comments}" class="clearfix m0 p1 border-left mb1">
    {text}
    <a class="btn btn-small border-red red right" onclick="{delete}" if="{account_id == currentAccount.id}">
      <i class="fa fa-trash-o"></i>
    </a>
    <div class="h5 right-align mt1"><strong>{account.profile.first_name} {account.profile.last_name}</strong> <span class="italic">{fromNow(created_at)}</span></div>
  </blockquote>


  <form name="form" onsubmit="{create}" class="mt2">
    <input type="hidden" name="account_id" value="{currentAccount.id}" >
    <input type="hidden" name="commentable_id" value="{this.opts.item.id}" >
    <input type="hidden" name="commentable_type" value="{this.opts.item.action ? 'Task' : 'Material'}" >
    <textarea class="block col-12 mb2 field" name="text" placeholder="Leave your comment"></textarea>
    <button class="btn btn-primary {busy: busy}" disabled="{busy}">Comment</button>
  </form>
  <script>
  this.on('mount', () => {
    this.opts.api.comments.on('create.success', this.addComment)
    this.opts.api.comments.on('create.fail', this.errorHandler)
    this.opts.api.comments.on('delete.success', this.removeComment)
    this.opts.api.comments.on('delete.fail', this.errorHandler)
    this.loadResources('comments', {commentable_id: this.opts.item.id, commentable_type: this.opts.item.action ? 'Task' : 'Material'})
  })
  this.on('unmount', () => {
    this.opts.api.comments.off('create.success', this.addComment)
    this.opts.api.comments.off('create.fail', this.errorHandler)
    this.opts.api.comments.off('delete.success', this.removeComment)
    this.opts.api.comments.off('delete.fail', this.errorHandler)
  })

  this.create = (e) =>{
    e.preventDefault()

    let data = this.serializeForm(this.form)

    if (_.isEmpty(data)) {
      $(this.form).animateCss('shake')
      return
    }

    this.update({busy: true, errors: null})

    this.opts.api.comments.create(data)
  }
  this.delete = (e) => {
    e.preventDefault()
    this.opts.api.comments.delete(e.item.id)
  }

  this.addComment = (comment) => {
    this.text.value = null
    var _id = _.findIndex(this.comments, c => c.id == comment.id)
    if (_id === -1) {
      this.comments.push(comment)
    }
    this.updateReset()
  }
  this.removeComment = (id) => {
    var _id = _.findIndex(this.comments, c => c.id == id)
    if (_id > -1) {
      this.comments.splice(_id, 1)
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
        <input type="number" name="quantity" value="{ quantity }" step="1" min="0"
        class="fit field inline-input center" oninput="{ input }" />
      </div>

      <div if="{ parent.headers.price }" class="col sm-col-{ parent.headers.price } col-{parent.opts.name == 'task' ? 3 : 2} center">
        <input type="number" name="price" value="{ parent.opts.name == 'task' ? price / 100 : (supplied ? price / 100 : 0) }"
        disabled="{ parent.opts.name == 'material' && !supplied }" step="1" min="0" class="fit field inline-input center" oninput="{ input }" />
      </div>

      <div if="{ parent.headers.total_cost }" class="col sm-col-{ parent.headers.total_cost } col-3 center">
        <input type="number" value="{parent.opts.name == 'task' ? (price / 100 * quantity) : (supplied ? price / 100 * quantity : '0')}"
        step="1" min="0" class="fit field inline-input center" oninput="{ inputTotalCost }" >
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
    e.item[e.target.name] = e.target.type === 'checkbox' ? e.target.checked : (e.target.name === 'price' ? (parseInt(e.target.value) || 0) * 100 : (parseInt(e.target.value) || 0))
    //this.update()
    this.opts.api.tenders.trigger('update')
  }
  this.inputname = (e) => {
    e.item.display_name = e.target.value
    this.update()
    this.opts.api.tenders.trigger('update')
  }
  this.inputTotalCost = (e) => {
    //$('[name=price]', this.root).val()
    e.item.price = e.target.value * 100 / e.item.quantity
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
