<r-tender-constructor>
  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>

  <div class="container p2 {readonly: isReadonly()} quote-container">
    <div if='{opts.type_class === "TenderTemplate"}'>
        <h2 class="center mt0 mb2">{opts.id ? 'Editing' : 'Creating'} { opts.resource.singular().humanize() }</h2>

        <h1><input type="text" name="name" value="{ record.name }"
          class="block col-12 field" placeholder="Name" oninput="{setInputValue}"/></h1>

    </div>


    <div if='{opts.type_class === "Quote"}'>
        <div class="clearfix">
          <div class="left mb4 overflow-hidden">
            <h1 class="mb0">{ opts.id ? getTitle() : 'New ' + opts.type_class }</h1>
            <a class="btn btn-small h6 btn-outline orange back-to-project" href="/app/projects/{record.project_id}"><i class="fa fa-chevron-left"></i> Back to Project</a>
          </div>
          <div class="right h5 mt3 align-right">
            <div>Created at: {formatTime(record.created_at)}</div>
            <div if="{record.submitted_at}">Submitted at: {formatTime(record.submitted_at)}</div>
            <div if="{record.accepted_at}">Accepted at: {formatTime(record.accepted_at)}</div>
          </div>
        </div>


        <div if="{currentAccount.isAdministrator}" class="p1 bg-blue white">
        <label for="project_id">Professional</label>
        <input type="hidden" name="professional_id" value="{record.professional_id}">
        <r-typeahead-input resource="professionals" api="{ opts.api }" id="{record.professional_id}" filters="{professionalFilters()}" datum_tokenizer="{['full_name']}"></r-typeahead-input>
        <span if="{errors.professional_id}" class="inline-error">{errors.professional_id}</span>

        <label for="tender_id">Tender</label>
        <input type="hidden" name="tender_id" value="{record.tender_id}">
        <r-typeahead-input resource="tenders" api="{ opts.api }" id="{record.tender_id}" filters="{tenderFilters()}" datum_tokenizer="{['id', 'total_amount']}"></r-typeahead-input>
        <span if="{errors.tender_id}" class="inline-error">{errors.tender_id}</span>
        </div>

        <div if="{record.id}" class="clearfix mb4">
          <div class="sm-col sm-col-6">
            <h4>From</h4>
            <address>
              {record.professional.profile.first_name} {record.professional.profile.last_name}<br>
              <virtual if="{!isAllValuesEmpty(record.professional.address)}">
                {record.professional.address.street_address}<br>
                {record.professional.address.postcode}, {record.professional.address.city}<br>
                {record.professional.address.country}
              </virtual>
            </address>
          </div>
        </div>

    </div>

    <r-tender-filters record="{record}"></r-tender-filters>

    <div class='section-category-affix-holder'>
        <div class='section-category-affix' show='{showFloatingSectionHeader}' if='{currentScrolledSection}'>
            <h3>{currentScrolledSection.section.name}<span if='{currentScrolledSection.currentTask}'> - {currentScrolledSection.currentTask.group}</span></h3>
        </div>
    </div>

    <r-tender-section readonly="{opts.readonly}" each="{ section , i in sections() }" quote={'this'}>
    </r-tender-section>

    <div class="py3">
    <h4 class="right-align m0"><label><input type="checkbox" onchange="{toggleVat}" checked="{record.document.include_vat}" class="mr1">VAT {tenderVat()}</label></h4>
    <h3 class="right-align m0">Total{ record.document.include_vat ? '(Inc. VAT)' : ''}: { tenderTotal }</h3>
    </div>

    <div if='{!currentAccount.isCustomer}'>
        <div class='locked-task-bar py3 clearfix mxn1 border-top'>
          <div class='container'>
            <form class='col col-6 {disabled-container: record.document.sections.length == 0}'>
              <div class="col col-12 px1">
                <r-tender-item-input name="task" auto_focus="{ true }" api="{ opts.api }" icon="tasks" enter='{addTask}' tender='{this}'></r-tender-item-input>
              </div>
              <div class="col col-8 px1 locked-form-margin-top">
                <div class='container'>
                  <select onchange='{changeCurrentSection}' name="sectionSelect">
                    <option each="{ section , i in sections() }" value='{i}'
                            selected='{currentScrolledSection.section.name == section.name}'>{section.name}
                    </option>
                  </select>
                </div>
              </div>
              <div class="col col-4 px1 locked-form-margin-top">
                <button type="button" onclick='{addTask}' class="block col-12 btn btn-primary">
                  <i class="fa fa-puzzle-piece"></i> Add Item
                </button>
              </div>
            </form>
            <form class='col col-6' onsubmit="{ addSection }">
              <div class="col col-12 px1">
                <input type="text" name="sectionName" placeholder="Section name" class="block col-12 field" />
              </div>
              <div class="col col-8 px1 locked-form-margin-top">
                <div class='container'>
                  <select name="sectionTemplate">
                    <option value='-1'>Blank template</option>
                    <option each="{ template, i in tender_templates }" value='{i}'>{template.name}</option>
                  </select>
                </div>
              </div>
              <div class="col col-4 px1 locked-form-margin-top">
                <button type="submit" class="block col-12 btn btn-primary" name='addSectionBtn'>
                  <i class="fa fa-puzzle-piece"></i> Add Section
                </button>
              </div>
            </form>
          </div>
        </div>
    </div>

    <form name="form" onsubmit="{ submit }">
      <div if='{opts.type_class === "Quote"}'>
          <div class="clearfix mxn2">
            <div class="sm-col sm-col-6 px2">
            <label>Insurance Amount</label>

            <select name="insurance_amount" class="block col-12 field mb2" onchange="{setVal}" if="{!currentAccount.isCustomer}">
              <option>Select</option>
              <option each="{_, i in new Array(19)}" key="0" value="{(i+1)}" selected="{record.insurance_amount == (i+1)}">{(i+1) + ' Million'}</option>
            </select>
            <p if="{currentAccount.isCustomer}">{record.insurance_amount ?  record.insurance_amount + ' Million' : 'N/A'}</p>
            </div>

            <div class="sm-col sm-col-6 px2">
            <label>Guarantee Length</label>
            <select name="guarantee_length" class="block col-12 field mb2" onchange="{setVal}" if="{!currentAccount.isCustomer}">
              <option>Select</option>
              <option each="{_, i in new Array(19)}" key="0" value="{(i+1)}" selected="{record.guarantee_length == (i+1)}">{(i+1) + (i > 0 ? ' Years' : ' Year')}</option>
            </select>
            <p if="{currentAccount.isCustomer}">{record.guarantee_length ? record.guarantee_length + ' Years' : 'N/A'} </p>
            </div>
          </div>

          <label>Summary</label>
          <textarea type="text" name="summary" placeholder="Summary" class="block col-12 field mb2" oninput="{setVal}" if="{!currentAccount.isCustomer}">{record.summary}</textarea>
          <p if="{currentAccount.isCustomer}">{record.summary ? record.summary : 'N/A'}</p>

          <div if="{errors}" id="error_explanation" class="left-align">
            <ul>
              <li each="{field, messsages in errors}"> <strong>{field.humanize()}</strong> {messsages} </li>
            </ul>
          </div>

          <div class="right-align">
            <button if="{opts.id && !currentAccount.isProfessional && record.submitted_at}"
            class="btn btn-primary btn-big {busy: busy}" onclick="{acceptQuote}" disabled="{record.accepted_at}">
            {record.accepted_at ? 'Accepted' : 'Accept'} <span if="{record.accepted_at}">{fromNow(record.accepted_at)}</span>
            </button>

            <virtual if="{!currentAccount.isCustomer}">
              <button type="submit" class="btn btn-primary btn-big {busy: busy}">Save</button>
              <a if="{opts.id}" class="btn bg-green white btn-big {busy: busy}" onclick="{submitQuote}">
                {record.submitted_at ? 'Submitted' : 'Submit'} <span if="{record.submitted_at}">{fromNow(record.submitted_at)}</span>
              </a>
            </virtual>
          </div>
      </div>
      <div if='{opts.type_class === "TenderTemplate"}'>
        <div if="{errors}" id="error_explanation" class="left-align">
          <ul>
            <li each="{field, messsages in errors}"> <strong>{field.humanize()}</strong> {messsages} </li>
          </ul>
        </div>

        <button type="submit" class="btn btn-primary btn-big {busy: busy}">Save</button>
      </div>

    </form>
    <div if='{opts.type_class === "TenderTemplate"}'>
      <div if="{record.id}" class="mt4 clearfix">
        <p>When you apply a template to a project, if there isn't Tender on the project it clones itself to project,
          if Tender exists it apply changes to project's tender
        </p>
        <r-typeahead-input resource="projects" api="{ opts.api }" datum_tokenizer="{['name', 'account_email']}"></r-typeahead-input>
      </div>
    </div>
  </div>
  <script>

  this.type = 'Quote'

  this.categories = ['Preparation', 'Structural', 'Plumbing', 'Electrics', 'Carpentry', 'Bespoke carpentry', 'Plastering', 'Decorating', 'Flooring', 'General']

  var _this = this

  this.tags['r-tender-filters'].on('update', this.update)
  this.getTitle = () => {
      // (opts.readonly ? 'Showing' : 'Editing') + ' Quote ' + opts.id
      if (this.opts.type_underscore === 'tender_templates') this.title = this.record.name
      if(this.title) {
        return this.title
      } else {
        if (!this.projectRequest) {
            this.projectRequest = this.opts.api.projects.show(this.record.project_id)
            this.projectRequest.then((project) => {
              var byOrFor = this.currentAccount.isCustomer ?
                ' by ' + (this.record.professional.profile.first_name + ' ' + this.record.professional.profile.last_name) :
                ' for ' + (project.customers[0].profile.first_name + ' ' + project.customers[0].profile.last_name)
              this.title = ' Quote' + byOrFor
              this.update()
              return this.title
            })
        }
      }
   }

    this.headers = {
      task: {name: 3, description: 3, quantity: 1, price: 1, total_cost: 2, actions: 2},
      material: {name: 2, description: 3, supplied: 1, quantity: 1, price: 1, total_cost: 2, actions: 2}
    }

    this.isReadonly = () => {
      return this.opts.readonly
    }

    this.getTenderTemplates = function() {
      this.opts.api.tender_templates.index({serializer: 'TenderTemplate'}).done(function(tender_templates) {
        _this.tender_templates = tender_templates
        _this.update()
      })
    }

    this.setInputValue = (e) => {
      this.record[e.target.name] = e.target.value
    }

    if(this.opts.readonly){
      delete this.headers.task.actions
      this.headers.task.description = 5
      delete this.headers.material.actions
      this.headers.material.name = 3
      this.headers.material.description = 4
    }
    if (this.opts.id) {
      this.on('mount', () => {
        opts.api[this.opts.type_underscore].on('show.fail', this.errorHandler)
        opts.api[this.opts.type_underscore].on('show.success', this.updateQuote)
        opts.api[this.opts.type_underscore].show(opts.id)
        this.getTenderTemplates()
      })
      this.on('unmount', () => {
        opts.api[this.opts.type_underscore].off('show.fail', this.errorHandler)
        opts.api[this.opts.type_underscore].off('show.success', this.updateQuote)
      })
    } else {
      this.record = {project_id: this.opts.project_id, document: {sections: []}}
      this.getTenderTemplates()
      if (this.currentAccount.isProfessional) this.record.professional_id = this.currentAccount.user_id
    }

    this.setVal = (e) => {
      this.record[e.target.name] = e.target.value
    }

    this.submit = (e) => {
      if (e) e.preventDefault()
      this.update({busy: true, errors: null})
      delete this.record['comments_counts']
      _.map(this.record.document.sections, (sec) => {
        delete sec['tasks_by_action']
        delete sec['materials_by_group']
        delete sec['materialTotal']
        delete sec['itemTotal']
        if (_.isEmpty(sec.materials)) {
          sec.materials = null
          delete sec.materials
        }
        if (_.isEmpty(sec.tasks)) {
          sec.tasks = null
          delete sec.tasks
        }
        if (sec.tasks) {
          for (var i = 0, ii = sec.tasks.length; i < ii; i++) delete sec.tasks[i].tags
        }

        return sec
      })

      if (this.opts.id) {
        this.opts.api[this.opts.type_underscore].update(opts.id, this.record)
        .fail(this.errorHandler)
        .then(id => this.update({busy:false}))
      }else{
        this.opts.api[this.opts.type_underscore].create(this.record)
        .fail(this.errorHandler)
        .then(record => {
          this.update({busy:false})
          if (!this.opts.id) {
            this.opts.id = this.record.id = record.id
            if (this.opts.type_underscore === 'quotes') {
              var next = '/app/projects/' + record.project_id + '/' + opts.type_underscore + '/' + record.id
            } else if (this.opts.type_underscore === 'tender_templates') {
              var next = '/app/admin/' + opts.type_underscore + '/' + record.id
            }
            window.history.pushState( {} , '', next )
          }
        })
      }
    }

    this.setSectionOffsets = function(tagName) {
        var sections = this.tags[tagName]
        this.sectionOffsets = {}
        for (var i = 0, ii = sections.length; i < ii; i++) {
            var section = sections[i]
            section.offsetTop = section.root.offsetTop
            this.sectionOffsets[section.offsetTop] = section
            if (tagName === 'r-tender-section') {
                section.sectionOffsets = {}
                this.setSectionOffsets.call(section, 'task')
            }
        }
    }

    this.floatingSectionHeader = this.tags['r-tender-filters'].root
    this.showFloatingSectionHeader = false

    this.on('update', function() {
      if (!this.hasInitSectionOffsets && this.record && this.record.document.sections.length && this.tags['r-tender-section'].length === this.record.document.sections.length) {
        this.setSectionOffsets('r-tender-section')
        this.hasInitSectionOffsets = true
      }
      if (!this.floatingSectionHeaderPosition) {
        this.floatingSectionHeaderPosition = this.floatingSectionHeader.offsetTop
      }
    })

    this.updateQuote = (record) => {
      if(!this.currentAccount.isAdministrator && record.accepted_at) {
        this.opts.readonly = true
      }
      this.id = opts.id = record.id
      this.record = record
      this.update(opts.id, {record: record})
    }

    this.removeUnwantedItems = function() {
        var tender_templates = this.record.tender_templates
        delete this.record['tender_templates']
        return tender_templates
    }


    this.submitQuote = (e) => {
      if (this.opts.id) {
        if (e) e.preventDefault()
        this.update({busy: true})
        this.opts.api[this.opts.type_underscore].submit(this.opts.id, this.record)
        .fail(this.errorHandler)
        .then(id => {
          this.record.submitted_at = new Date()
          this.update({busy:false})
        })
      }
    }

    this.acceptQuote = (e) => {
      if (this.opts.id) {
        if (e) e.preventDefault()
        this.update({busy: true})
        this.opts.api[this.opts.type_underscore].accept(this.opts.id)
        .fail(this.errorHandler)
        .then(id => this.update({busy:false}))
      }
    }

    this.tags['r-typeahead-input'][0].on('itemselected', (item) => {
      this.record.professional_id = item.id
      this.update()
    })
    this.tags['r-typeahead-input'][1].on('itemselected', (item) => {
      this.record.tender_id = item.id
      this.update()
    })

    if (this.record && this.record.project_id) {
        this.professionalFilters = () => {
          return [{name: 'project_id', value: this.record.project_id}]
        }
        this.tenderFilters = () => {
          return [{name: 'project_id', value: this.record.project_id}]
        }

    }

    this.on('update', function() {
        if (!this.uniqueIdentifiers && this.record && this.record.document && this.record.document.sections) {
            this.createNewIdentifiersForSections(this.record.document.sections)
        }
    })

    this.addTask = function() {
        var taskClass = this.tags['task']
        this.currentScrolledSection = this.currentScrolledSection || this.tags['r-tender-section'][0]
        if (!taskClass.currentTask) {
            var value = $(taskClass.query).typeahead('val')
            if (value) {
                taskClass.currentTask = taskClass.getDefaultItem(value)
            }
        }

        if (taskClass.currentTask) {
            var section = this.currentScrolledSection.section
            section.tasks = section.tasks || []
            delete taskClass.currentTask['tags']
            section.tasks.push(this.newTaskReference(taskClass.currentTask))
            this.opts.api[this.opts.type_underscore].update(this.record.id, this.record)
            $('html, body').animate({
                scrollTop: $(this.currentScrolledSection.root).offset().top
            }, 300);
        }
        this.setSectionOffsets('r-tender-section')
        this.currentScrolledSection.updateSectionTotal()
        delete taskClass['currentTask']
    }

    this.newTaskReference = function(item) {
        // this function unbinds the object from previously binded task objects, creating a new object thats individually mutable
        return {
            action: item.action,
            description: item.description,
            group: item.group,
            id: item.id,
            name: item.name,
            price: +item.price,
            quantity: +item.quantity,
            unit : item.unit
        }
    }

    var timer

    this.on('mount', function () {
        document.addEventListener('scroll', function (e) {
            if(timer) {
                window.clearTimeout(timer);
            }
            timer = window.setTimeout(function() {
                _this.handleScroll.call(_this, e)
            }, 100);
        })
        return this.update();
    });

    this.on('unmount', function (e) {
        return this.root.removeEventListener('scroll', function (e) {
            _this.handleScroll.call(_this, e)
        });
    });

    this.findSectionByOffset = function() {
        var current
        for (var key in this.sectionOffsets) {
            if (window.scrollY >= key) {
                current = this.sectionOffsets[key]
            } else {
                break
            }
        }
        return current
    }

    this.findSection = function() {
        if (!this.floatingSectionHeaderPosition) return false
        this.showFloatingSectionHeader = window.scrollY > this.floatingSectionHeaderPosition

        if (this.sectionOffsets && !( 'key1' in this.sectionOffsets)) {
            if (this.showFloatingSectionHeader) {
                var current = this.findSectionByOffset()
                if (current) {
                    current.currentTask = this.findSectionByOffset.call(current)
                    return current
                }
            }
        }
    }

    this.handleScroll = function (e) {
        this.currentScrolledSection = this.findSection()
        return this.update();
    }

    this.changeCurrentSection = function(e){
        if (!this.currentScrolledSection) this.currentScrolledSection = this.tags['r-tender-section'][0]
        var sections = this.tags['r-tender-section']
        this.currentScrolledSection = sections[+this.sectionSelect.value]
        this.currentScrolledSection
    }

    this.mixin('tenderMixin')

  </script>
</r-tender-constructor>