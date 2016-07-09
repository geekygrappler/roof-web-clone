import from '../../mixins/tender.js'
import './_tender_item_input.tag'
import './_tender_item.tag'
import './_tender_item_group.tag'
import './_tender_section.tag'
import './_tender_filters.tag'
import './_area_calculator.tag'

<r-tenders-form class='tenders-form'>
  <yield to="header">
    <r-header api="{opts.api}"></r-header>
  </yield>

  <div class="container p2 {readonly: opts.readonly}">
    <h1> { opts.id ? (opts.readonly ? 'Showing' : 'Editing') + ' Tender ' + opts.id : 'New Tender' }</h1>

    <a class="mb1 btn btn-small h6 btn-outline orange" href="/app/projects/{project.id}">
      <i class="fa fa-chevron-left"></i> Back to Project
    </a>
    <r-tender-filters record="{record}"></r-tender-filters>
    <div class='section-category-affix-holder'>
        <div class='section-category-affix' show='{affixPointShow}'>
            <h3>{currentScrolledSection.section.name} - <span>{currentScrolledSectionTask.group}</span></h3>
        </div>
    </div>

    <r-tender-section each="{ section , i in sections() }" no-reorder></r-tender-section>

    <div class="py3">
    <h2 class="right-align m0"><label><input type="checkbox" onchange="{toggleVat}" checked="{record.document.include_vat}" class="mr1">VAT {tenderVat()}</label></h2>
    <h1 class="right-align m0">Estimated total{ record.document.include_vat ? '(Inc. VAT)' : ''}: { tenderTotal }</h2>
    </div>

    <form name="form" onsubmit="{ submit }" class="right-align">
      <div if="{errors}" id="error_explanation" class="left-align">
        <ul>
          <li each="{field, messsages in errors}"> <strong>{field.humanize()}</strong> {messsages} </li>
        </ul>
      </div>

      <button if="{!currentAccount.isProfessional}" type="submit" class="btn btn-primary btn-big {busy: busy}">Save</button>
      <a if="{currentAccount.isProfessional}" onclick="{cloneTender}" class="btn btn-primary btn-big {busy: busy}">Clone</a>
    </form>
  </div>
  <script>

  this.type = 'Tender'

    this.headers = {
      task: {name: 3, description: 4, quantity: 3, actions: 2},
      material: {name: 3, description: 4, quantity: 3, actions: 2}
    }

    this.tags['r-tender-filters'].on('update', this.update)

    if(opts.readonly) {
      delete this.headers.task.actions
      this.headers.task.name = 5
      delete this.headers.material.actions
      this.headers.material.name = 5
    }

    if(opts.api.currentAccount.isAdministrator) {
      this.headers = {
        task: {name: 3, description: 3, quantity: 1, price: 1, total_cost: 2, actions: 2},
        material: {name: 2, description: 3,  supplied: 1, quantity: 1, price: 1, total_cost: 2, actions: 2}
      }
    }

    if (opts.id) {
      this.on('mount', () => {
        opts.api.projects.on('show.success', this.updateTenderFromProject)
        opts.api.tenders.on('show.success', this.updateTender)
      })
      this.on('unmount', () => {
        opts.api.projects.off('show.success', this.updateTenderFromProject)
        opts.api.tenders.off('show.success', this.updateRecord)
      })
    } else {
      this.record = {project_id: this.opts.project_id, document: {sections: []}}
    }

    this.submit = (e) => {
      if (e) e.preventDefault()

      this.update({busy: true, errors: null})

      _.map(this.record.document.sections, (sec) => {
        if (_.isEmpty(sec.tasks)) {
          sec.tasks = null
          delete sec.tasks
        }
        return sec
      })

      if (this.opts.id) {
        this.opts.api.tenders.update(opts.id, this.record)
        .fail(this.errorHandler)
        .then(id => this.update({busy:false}))
      }else{
        this.opts.api.tenders.create(this.record)
        .fail(this.errorHandler)
        .then(record => {
          this.update({busy:false})
          this.opts.id = record.id
          window.location.href = `/app/projects/${record.project_id}/tenders/${record.id}`
        })
      }
    }

    this.addTask = function() {
        var taskClass = this.tags['task']
        if (!this.currentScrolledSection ) this.currentScrolledSection = this.tags['r-tender-section'][0]
        if (!taskClass.currentTask) {
            var value = $(taskClass.query).typeahead('val')
            if (value) {
                taskClass.currentTask = taskClass.getDefaultItem(value)
            }
        }

        if (taskClass.currentTask) {
            if (!this.currentScrolledSection.section.tasks) this.currentScrolledSection.section.tasks = []
            this.currentScrolledSection.section.tasks.push(taskClass.currentTask)
            this.update()
            $('html, body').animate({
                scrollTop: $(this.currentScrolledSection.root).offset().top
            }, 300);
        }
    }

    this.updateTenderFromProject = (project) => {
      this.tenderTemplates = project.tender_templates
      this.update({record: project.tender})
    }
    this.updateRecord = (record) => {
      this.update({record: record})
    }
    this.cloneTender = (e) => {
      e.preventDefault()
      opts.api.quotes.create({
        project_id: this.record.project_id,
        tender_id: this.record.id,
        professional_id: this.currentAccount.user_id
      })
      .then((quote) => {
        riot.route(`/projects/${this.record.project_id}/quotes/${quote.id}`)
      })
    }

    var _this = this

    this.on('mount', function () {
        document.addEventListener('scroll', function (e) {
            _this.handleScroll.call(_this, e)
        })
        return this.update();
    });

    this.on('unmount', function (e) {
        return this.root.removeEventListener('scroll', function (e) {
            _this.handleScroll.call(_this, e)
        });
    });

    this.findSection = function(tagName) {
        var sections = this.tags[tagName]
        var smallest = sections[0]
        for (var i = 0, ii = sections.length; i < ii; i++) {
            var section = sections[i]
            section.offset = section.root.childNodes[0].getBoundingClientRect()
            var top = section.offset.top
            if (top > -800 && top < 1) {
                section.top = top
                if (smallest && smallest.top <= section.top) var smallest = section
            }
        }
        return smallest

    }

    this.changeCurrentSection = function(e){
        if (!this.currentScrolledSection) this.currentScrolledSection = this.tags['r-tender-section'][0]
        var sections = this.tags['r-tender-section']
        this.currentScrolledSection = sections[+this.sectionSelect.value]
        this.currentScrolledSection
    }

    this.affixPoint = this.tags['r-tender-filters'].root
    this.affixPointShow = false

    this.handleScroll = function (e) {
        var offset = this.affixPoint.getBoundingClientRect()
        this.affixPointShow = offset.bottom < 0 ? true : false
        this.currentScrolledSection = this.findSection.call(this, 'r-tender-section')
        this.currentScrolledSectionTask = this.findSection.call(this.currentScrolledSection, 'task')
        this.currentScrolledSectionMaterial = this.findSection.call(this.currentScrolledSection, 'material')
        return this.update();
    }

    this.mixin('tenderMixin')
    this.mixin('projectTab')
  </script>
</r-tenders-form>
