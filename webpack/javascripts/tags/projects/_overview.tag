<r-project-overview>
  <h2 class="mt0">{ project.name }</h2>
  <hr>

  <h3>Description</h3>
  <p>{ project.brief.description }</p>

  <div class="clearfix mxn1">
    <div class="sm-col sm-col-6 px1">
      <h3>Budget</h3>
      <p if="{ project.brief.budget }">{ project.brief.budget }</p>
      <p if="{ !project.brief.budget && !currentAccount.isProfessional}">
        You have not set a project budget yet (<a href="/app/projects/{ project.id }/brief">add one</a>)
      </p>
    </div>

    <div class="sm-col sm-col-6 px1">
      <h3>Preferred Start date</h3>
      <p if="{ project.brief.preferred_start }">{ project.brief.preferred_start }</p>
      <p if="{ !project.brief.preferred_start && !currentAccount.isProfessional}">
        You have not defined a start date yet (<a href="/app/projects/{ project.id }/brief">set now</a>)
      </p>
    </div>
  </div>

  <h3>Address</h3>
    <address if="{ !isAllValuesEmpty(project.address) }" class="mb3">
      { project.address.street_address }
      { project.address.city }, { project.address.postcode }
    </address>
    <p if="{ isAllValuesEmpty(project.address) && !currentAccount.isProfessional}">
      You have not defined the address yet (<a href="/app/projects/{ project.id }/brief">fix now</a>)
    </p>
  </div>

  <script>
  this.mixin('projectTab')
  </script>
</r-project-overview>
