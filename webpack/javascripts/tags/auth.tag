import './_signup.tag'
import './_signin.tag'

<r-auth>
  <r-tabs tab="{opts.tab}" api="{opts.api}"></r-tabs>
  <script>
  this.on('mount', () => $('r-app').addClass('display-none'))
  this.on('unmount', () => $('r-app').removeClass('display-none'))
  </script>
</r-auth>
