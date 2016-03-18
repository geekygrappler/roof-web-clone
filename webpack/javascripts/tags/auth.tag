import './_signup.tag'
import './_signin.tag'

<r-auth>
  <r-tabs tab="{opts.tab}" api="{opts.api}"></r-tabs>
  <script>
  this.on('mount', () => $('r-app').addClass('display-none') )
  opts.api.sessions.on('signin.success', () => $('r-app').removeClass('display-none'))
  opts.api.sessions.on('signup.success', () => $('r-app').removeClass('display-none'))
  </script>
</r-auth>
