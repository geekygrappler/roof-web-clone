import './_file_input.tag'
import './_files_input_with_preview.tag'

<r-project-docs>
  <h2 class="mt0">Documents and Photos</h2>
  <div class="clearfix mxn2">
    <div class="sm-col sm-col-12 px2 mb2">
      <p class="h2">Upload plans, documents, site photos or any other files about your project</p>

      <r-files-input-with-preview name="assets" record="{project}"></r-files-input-with-preview>

    </div>
  </div>
  <script>
  this.mixin('projectTab')
  </script>
</r-project-docs>
