import from '../../mixins/tender.js'
import '../tenders/_tender_constructor.tag'

<r-quotes-form>
  <r-tender-constructor
        type_class='Quote'
        type_underscore='quotes'
        api='{opts.api}'
        project_id='{opts.project_id}'
        id='{opts.id}'>
  </r-tender-constructor>
</r-quotes-form>
