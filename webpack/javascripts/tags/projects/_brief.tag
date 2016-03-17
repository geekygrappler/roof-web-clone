let options = require("json!../../data/brief.json")
import './_option_group_input.tag'

<r-project-brief>
  <form name="form" class="edit_project" action="/api/projects/{opts.id}" onsubmit="{submit}">
    <section class="container clearfix">
      <h2 class="mt0">Name of your project</h2>
      <input type="text" id="name" class="block col-12 mb2 field"
      name="name" placeholder="My Home, Swiss Cottage, Jenny's Flat ..."
      value="{project.name}"/>
      <div class="right-align">
        <button class="btn btn-primary {busy: busy}" type="submit">Save</button>
      </div>
    </section>

    <section class="container clearfix">
      <h2>Mission</h2>
      <div class="clearfix border">
        <div each="{options.kind}" class="center col col-6 md-col-4">
          <a class="block p2 bg-lighten-4 black icon-radio--button {active: (name === project.kind)}" onclick="{ setProjectKind }">
            <img class="fixed-height" src="{icon}" alt="{name}">
            <h4 class="m0 caps center truncate icon-radio--name">{name}</h4>
            <input type="radio" name="kind" value="{value}" class="hide" checked="{value === project.kind}">
          </a>
        </div>
      </div>
      <div class="mt2 right-align">
        <button class="btn btn-primary {busy: busy}" type="submit">Save</button>
      </div>
    </section>

    <section class="container clearfix">
      <h2>Helpful details</h2>
      <p class="h2">Description *</p>

      <textarea id="brief.description" name="brief[description]" class="fixed-height block col-12 mb2 field"
      placeholder="Please write outline of your project" required="true"
      oninput="{setValue}">{project.brief.description}</textarea>
      <span if="{errors['brief.description']}" class="inline-error">{errors['brief.description']}</span>

      <div class="clearfix mxn2 mb2 left-align">
        <div class="sm-col sm-col-4 px2">
          <label for="brief[budget]">Budget</label>
          <select id="brief.budget" name="brief[budget]" class="block col-12 mb2 field" onchange="{setValue}">
            <option each="{value, i in options.budget}"
            value="{value}" selected="{value === project.brief.budget}">{value}</option>
          </select>
        </div>
        <div class="sm-col sm-col-4 px2">
          <label for="brief[preferred_start]">Start</label>
          <select id="brief.preferred_start" name="brief[preferred_start]" class="block col-12 mb2 field" onchange="{setValue}">
            <option each="{value, i in options.preferredStart}"
            value="{value}" selected="{value === project.brief.preferred_start}">{value}</option>
          </select>
        </div>
        <div class="sm-col sm-col-4 px2">
          <label for="brief[ownership]">Start</label>
          <select id="brief.ownership" name="brief[ownership]" class="block col-12 mb2 field" onchange="{setValue}">
            <option each="{value, i in options.ownership}"
            value="{value}" selected="{value === project.brief.ownership}">{value}</option>
          </select>
        </div>
      </div>

      <div class="clearfix mxn2 mb2 left-align">
        <div class="sm-col sm-col-6 px2">

          <r-option-group-input record="{project.brief}" name="brief" groups="{ ['plans', 'planning_permission'] }" options="{ options.yesNo }">
          </r-option-group-input>

        </div>
        <div class="sm-col sm-col-6 px2">

          <r-option-group-input  record="{project.brief}" name="brief" groups="{ ['structural_drawings', 'party_wall_agreement'] }" options="{ options.yesNo }">
          </r-option-group-input>

        </div>
      </div>
      <div class="right-align">
        <button class="btn btn-primary {busy: busy}" type="submit">Save</button>
      </div>
    </section>

    <section class="container clearfix">
      <h2>Address</h2>
      <p class="h2">Location of project</p>
      <div class="clearfix left-align">
        <label for="address[street_address]">Street Address</label>
        <input id="address.street_address" class="block col-12 mb2 field"
        type="text" name="address[street_address]" value="{project.address.street_address}"
        oninput="{setValue}"/>
        <div class="clearfix mxn2">
          <div class="col col-6 px2">
            <label for="address[city]">City</label>
            <input id="address.city" class="block col-12 mb2 field"
            type="text" name="address[city]" value="{project.address.city}"
            oninput="{setValue}"/>
          </div>
          <div class="col col-6 px2">
            <label for="address[postcode]">Postcode</label>
            <input id="address.postcode" class="block col-12 mb2 field"
            type="text" name="address[postcode]" value="{project.address.postcode}"
            oninput="{setValue}"/>
          </div>
        </div>
      </div>
      <div class="right-align">
        <button class="btn btn-primary {busy: busy}" type="submit">Save</button>
      </div>
    </section>
  </form>
  <script>
  this.mixin('projectTab')
  this.step = 5
  this.project = {brief: {}, address: {}}
  this.options = options
  this.setProjectKind = (e) => {
    this.project.kind = e.item.value
  }
  this.setValue = (e) => {
    this.dot.str(e.target.id, e.target.value, this.project)
  }
  this.submit = (e) => {
    let project, assetsToAssign
    if (e) e.preventDefault()

      project = this.serializeForm(this.form)

      if (_.isEmpty(project)) {
        $(this.form).animateCss('shake')
        return
      }

      this.update({busy: true})

      this.opts.api.projects.update(opts.id, project)
      .fail(this.errorHandler)
      .then(id => this.update({busy:false}))
  }
  </script>
</r-project-brief>
