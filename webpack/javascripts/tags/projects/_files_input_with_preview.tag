<r-files-input-with-preview>
  <div class="relative">

    <r-file-input name="{ opts.name }" record="{ opts.record }" data-accept="{ opts.data_accept }" accept="{ opts.accept }"></r-file-input>

    <div class="border center dropzone {busy: busy}">
      <i class="fa fa-plus fa-2x mt3"></i>
      <p>Drag and drop your documents here or click to select</p>
    </div>
    <div class="clearfix upload-previews mxn1">

      <div each="{ asset, index in opts.record[opts.name] }"
        class="sm-col col-6 sm-col-4 p1 rounded center thumb animated bounceIn">
        <div class="border p1 truncate overflow-hidden">
            <a class="cursor-zoom" href="{ asset.file.url }" target="_blank">
            <img src="{ thumbUrl(asset) }"/>
            </a>
            <br><span>{filename(asset.file.url)}</span>
            <br><a class="btn btn-small" onclick="{ destroy }" ><i class="fa fa-times"></i></a>
        </div>
      </div>

    </div>
  </div>

  <script>
  this.thumbUrl = (asset) => {
    if (asset.file_processing) {
      asset.file.cover.url = "/images/file-document-icon.png"
      asset.file.thumb.url = "/images/file-document-icon.png"
    }
    return asset.content_type.indexOf('image') > -1 ? asset.file.thumb.url : asset.file.cover.url
  }
  this.destroy = (e) => {
    if (window.confirm(this.ERRORS.CONFIRM_DELETE)) {

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
  }
  this.on('update', this.parent.update)
  </script>

</r-files-input-with-preview>
