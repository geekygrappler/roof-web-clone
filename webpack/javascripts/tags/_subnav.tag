<r-subnav>
  <aside class="sm-col sm-col-3 px2">
    <ul class="list-reset border-left border-top border-right rounded">
      <li each="{ opts.links }">
        <a href="{ href }" class="btn block border-bottom { 'bg-yellow': tag == parent.opts.tab }" title="{name.humanize()}" name="{tag}">
        { name.humanize() }
        </a>
      </li>
    </ul>
  </aside>
</r-subnav>
