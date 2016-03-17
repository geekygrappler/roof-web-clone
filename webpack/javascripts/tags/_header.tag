let links = require("json!../data/header.json")

<r-admin-menu>
  <div class="relative inline-block" data-disclosure>
    <button type="button" class="btn btn-primary">
      Menu &#9662;
    </button>
    <div data-details class="fixed top-0 right-0 bottom-0 left-0"></div>
    <div data-details class="absolute left-0 mt1 nowrap black bg-yellow rounded">
      <a each="{items}" href="{href}" class="btn block">{title}</a>
    </div>
  </div>
  <script>
  this.items = links['AdministratorLinks']
  </script>
</r-admin-menu>

<r-header>
  <header class="container">
    <div>
      <nav class="relative clearfix black h5">
        <div class="left">
          <a href="/app/projects" class="btn py2"black><img src="/images/logos/black.svg" class="logo--small" /></a>
        </div>
        <div class="right py1 sm-show mr1">
          <r-admin-menu if="{opts.api.currentAccount.isAdministrator}"></r-admin-menu>
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
  this.items = links[opts.api.currentAccount ? opts.api.currentAccount.user_type : 'Guest']
  </script>
</r-header>
