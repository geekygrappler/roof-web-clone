<r-modal>

  <div name="body" class="black modal-body out">
    <div class="fixed left-0 top-0 right-0 bottom-0 z4 overflow-auto bg-darken-4">
      <div class="relative sm-col-6 sm-px3 px1 py3 mt4 mb4 mx-auto bg-white modal-container">
        <a if="{!opts.persisted}" class="absolute btn btn-small right-0 top-0 mr1 mt1" onclick="{close}">
          <i class="fa fa-times"></i>
        </a>
        <div name="content"></div>
      </div>
    </div>
  </div>

  <script>
  riot.mount(this.content, this.opts.content, this.opts.contentOpts)

  // auth modal? let's auto close it when it's done
  if(this.opts.content == 'r-auth') {
    this.opts.api.sessions.on('signin.success', () => this.close())
    this.opts.api.registrations.on('signup.success', () => this.close())
  }

  this.close = (e) => {
    if (e) e.preventUpdate = true
    $(this.body)
    .on('transitionend', this.unmount.bind(true))
    .addClass('out')
  }

  this.on('mount', () => {
    document.body.classList.add('overflow-hidden')
    setTimeout(() => {
      $(this.body).removeClass('out')
    }, 100)
  })

  this.on('unmount', () => {
    $('body').removeClass('overflow-hidden')
  })
  </script>
</r-modal>
