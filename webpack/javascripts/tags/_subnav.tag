<r-subnav>
  <aside class="sm-col sm-col-3 px2">
    <ul class="list-reset border-left border-top border-right rounded">
      <li each="{ opts.links }">
        <a href="{ href }" class="btn block border-bottom { 'bg-yellow': parent.opts.active_tab_name ? name == parent.opts.active_tab_name : tag == parent.opts.tab }" title="{name.humanize()}" name="{tag}" onclick="{push}">
        { name.humanize() }
        </a>
      </li>
    </ul>
  </aside>
  <script>
  this.push = (e) => {
    history.pushState(null, e.target.title, e.target.href)
  }
  </script>
</r-subnav>
