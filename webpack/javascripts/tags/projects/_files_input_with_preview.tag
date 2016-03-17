<r-files-input-with-preview>
  <div class="relative">

    <r-file-input name="{ opts.name }" record="{ opts.record }" data-accept="{ opts.data_accept }" accept="{ opts.accept }"></r-file-input>

    <div class="border center dropzone">
      <i class="fa fa-plus fa-2x mt3"></i>
      <p>Drag and drop your documents here or click to select</p>
      <div class="clearfix upload-previews">

        <div each="{ asset, index in opts.record[opts.name] }"
          class="sm-col sm-col-4 p1 rounded center thumb animated bounceIn">
          <div class="border p1 truncate overflow-hidden">
              <a class="cursor-zoom" href="{ asset.file.url }" target="_blank">
              <img src="{ asset.content_type.indexOf('image') > -1 ? asset.file.thumb.url : asset.file.cover.url }" class="fixed-height"/>
              </a>
              <br><a class="btn btn-small" onclick="{ destroy }" ><i class="fa fa-times"></i></a>
          </div>
        </div>

      </div>
    </div>
  </div>

  <script>
  this.destroy = (e) => {
    let index = e.item.index
    let assets = opts.record[opts.name]
    let id = assets[index].id

    this.request({
      type:'delete',
      url: `/api/assets/${id}`
    })
    .fail(() => { $(e.target).parents('.thumb').animateCss('shake') })
    .then(() => {
        $(e.target)
        .parents('.thumb')
        .one($.animationEnd, (e) => {
          assets.splice(index, 1)
          $(e.target).remove()
        })
        .animateCss('bounceOut')
      })
  }
  this.on('update', this.parent.update)
  </script>

</r-files-input-with-preview>
