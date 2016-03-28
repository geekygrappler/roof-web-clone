<r-pagination>
  <div if="{meta.total_pages > 1}" class="center py2">
    <a if="{meta.has_previous_page}" class="btn btn-small bg-blue white" onclick="{parent.prevPage}">Prev</a>
    <select onchange="{parent.gotoPage}" class="field">
      <option each="{i, page in new Array(meta.total_pages)}" selected="{page == meta.current_page}">{page}</option>
    </select>
    <a if="{meta.has_next_page}" class="btn btn-small bg-blue white" onclick="{parent.nextPage}">Next</a>
  </div>
  <script>

  this.on('update', () => {
    if (this.opts.api[this.parent.opts.resource].meta) {
      this.update({meta: this.opts.api[this.parent.opts.resource].meta})
    }
  })
  </script>
</r-pagination>
