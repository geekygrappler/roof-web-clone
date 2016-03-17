<r-header>
  <header class="container">
    <div>
      <nav class="relative clearfix black h5">
        <div class="left">
          <a href="/app/projects" class="btn py2"black><img src="/images/logos/black.svg" class="logo--small" /></a>
        </div>
        <div class="right py1 sm-show mr1" if="{opts.api.currentAccount}">
          <a href="/app/projects" class="btn py2">Projects</a>
          <a href="/app/settings" class="btn py2">Settings</a>
          <a href="/app/signout" class="btn py2">[{opts.api.currentAccount.user_type}] Sign out</a>
        </div>
        <div class="right py1 sm-show mr1" if="{!opts.api.currentAccount}">
          <a href="/pages/about" class="btn py2">About us</a>
          <a href="/#how-it-works" class="btn py2">How it works</a>
          <a href="/app/signin" class="btn py2">Sign in</a>
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
              <ul class="h5 list-reset py1 mb0" if="{opts.api.currentAccount}">
                <li><a href="/app/projects" class="btn block">Projects</a></li>
                <li><a href="/app/settings" class="btn block">Settings</a></li>
                <li><a href="/app/signout" class="btn block">[{opts.api.currentAccount.user_type}] Sign out</a></li>
              </ul>
              <ul class="h5 list-reset py1 mb0" if="{!opts.api.currentAccount}">
                <li><a href="/pages/about" class="btn block">About us</a></li>
                <li><a href="/#how-it-works" class="btn block">How it works</a></li>
                <li><a href="/app/signin" class="btn block">Sign in</a></li>
              </ul>
            </div>
          </div>
        </div>
      </nav>
    </div>
  </header>
</r-header>
