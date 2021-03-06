<r-file-input>

  <input type="file" name="{ opts.name}"
  multiple
  class="absolute col-12 left-0 top-0 bottom-0 center transparent"
  style="height:100%"
  data-accept="{ opts.data_accept }"
  accept="{ opts.accept }"
  ondragover="{ fileDragHover }"
  ondragleave="{ fileDragHover }"
  ondrop="{ fileSelectHandler }">

  <script>
  this.index = 0

  this.fileDragHover = (e) => {
    e.stopPropagation();
    e.preventDefault();
    $('.dropzone', this.parent.root)
    .toggleClass("hover", (e.type === "dragover"))
  }

  this.fileSelectHandler = (e) => {
    // cancel event and hover styling
    this.fileDragHover(e);

    // // fetch FileList object
    var files = e.dataTransfer && e.dataTransfer.files.length > 0 ? e.dataTransfer.files : e.currentTarget.files

    this.uploader.fileupload('add', {
      files: files
    })
  }
  this.on('mount', () =>{

    this.uploader = $('input[type=file]', this.root).fileupload({
      paramName: 'asset[file]',
      url: '/api/assets',
      dropZone: $('.dropzone', this.parent.root),
      add: (e, data) => {
        this.parent.update({busy: true})
        
        // not a new project? then assign assets directly to it
        if (opts.record.id) data.formData = {'asset[project_id]': opts.record.id}

        data.submit()
        .success((result, textStatus, jqXHR) => {

          let files = opts.record[opts.name] || []
          var file = _.last(data.files)
          var reader = new FileReader()
          reader.onload =  (_e) => {
            result.file.thumb.url = _e.target.result
            files.push(result)
            this.parent.update()
            reader = null; // do not leak memory
            file = null;
          }

          if (file.type.startsWith('image')) {
            reader.readAsDataURL(file)
          } else {
            result.file.cover.url = "/images/file-document-icon.png"
            files.push(result)
          }
          opts.record[opts.name] = files
          this.parent.update({busy: false})
        })
        .error((jqXHR, textStatus, errorThrown) => {
          console.error('upload err', textStatus)
        })
      }
    })
  })
  </script>

</r-file-input>
