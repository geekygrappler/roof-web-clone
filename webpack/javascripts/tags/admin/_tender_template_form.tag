import from '../../mixins/tender.js'
import '../tenders/_tender_constructor.tag'

<r-admin-tender-template-form>
  <r-tender-constructor
        type_class='TenderTemplate'
        type_underscore='tender_templates'
        id='{opts.id}' 
        api='{opts.api}'
        readonly='{opts.readonly}'>
  </r-tender-constructor>
</r-admin-tender-template-form>
