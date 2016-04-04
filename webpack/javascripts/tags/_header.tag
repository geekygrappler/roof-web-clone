let links = require("json!../data/header.json")

<r-admin-menu>
  <r-typeahead-input if="{currentAccount.isAdministrator}" resource="accounts" api="{ opts.api }" id="{currentAccount.impersonating ?  currentAccount.user_id : null}" datum_tokenizer="{['email']}"></r-typeahead-input>
  <div class="relative inline-block" data-disclosure>
    <button type="button" class="btn bg-blue white">
      Menu &#9662;
    </button>
    <div data-details class="fixed top-0 right-0 bottom-0 left-0"></div>
    <div data-details class="absolute left-0 mt1 nowrap black bg-blue white rounded z4">
      <a each="{items}" href="{href}" class="btn block">{title}</a>
    </div>
  </div>
  <script>
  this.items = links['AdministratorLinks']
  this.tags['r-typeahead-input'].on('itemselected', (item) => {
    this.opts.api.sessions.impersonate({id: item.id})
  })
  </script>
</r-admin-menu>

<r-header>
  <header class="{
    'bg-red': currentAccount && currentAccount.impersonating && currentAccount.isProfessional,
    'bg-yellow': currentAccount && currentAccount.impersonating && currentAccount.isCustomer,
    'bg-blue': currentAccount && currentAccount.impersonating && currentAccount.isAdministrator
  }">
    <div class="container">
      <nav class="relative clearfix black h5">
        <div class="left">
          <a href="/app/projects" class="btn py2"black><img src="/images/logos/black.svg" class="logo--small" /></a>
        </div>
        <div class="right py1 sm-show mr1">
          <r-admin-menu if="{currentAccount.isAdministrator}"></r-admin-menu>
          <virtual if="{currentAccount.impersonating}">
            <span class="btn py2 silver cursor-default">{currentAccount.email}</span>
            <a class="btn btn-narrow" onclick="{stopImpersonate}">STOP</a>
          </virtual>
          <span if="{!currentAccount.impersonating}" class="btn py2 silver cursor-default">{currentAccount.user_type[0]}</span>
          <a each="{items}" href="{href}" class="btn py2">{title}</a>
        </div>
        <div class="right sm-hide py1 mr1">
          <div class="inline-block" data-disclosure>
            <div data-details class="fixed top-0 right-0 bottom-0 left-0"></div>
            <a class="btn py2 m0">
              <span class="md-hide">
                <i class="fa fa-bars"></i>
              </span>
            </a>
            <div data-details class="absolute left-0 right-0 nowrap bg-white black mt1">
              <ul  class="h5 list-reset py1 mb0">
                <li each="{items}"><a href="{href}" class="btn block">{title}</a></li>
              </ul>
            </div>
          </div>
        </div>
      </nav>
    </div>
  </header>
  <script>
  this.stopImpersonate = (e) => {
    e.preventDefault()
    this.opts.api.sessions.stopImpersonate()
  }
  this.items = links[opts.api.currentAccount ? opts.api.currentAccount.user_type : 'Guest']
  </script>
</r-header>
