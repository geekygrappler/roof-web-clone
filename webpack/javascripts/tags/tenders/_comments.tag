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
