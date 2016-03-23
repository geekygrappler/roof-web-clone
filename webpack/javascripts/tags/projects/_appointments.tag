import Pikaday from 'pikaday-time/pikaday'

<r-appointment-form>
  <h2 class="center mt0 mb2">Arrange an Appointment</h2>
  <form name="form" class="sm-col-12 left-align" action="/api/appointments" onsubmit="{submit}">

    <input type="hidden" name="project_id" value="{record.project_id}" />
    <input type="hidden" name="host_id" value="{record.host_id}" />
    <input type="hidden" name="host_type" value="{record.host_type}" />
    <input type="hidden" name="attendant_id" value="{record.attendant_id}" />
    <input type="hidden" name="attendant_type" value="{record.attendant_type}" />
    <input class="block col-12 mb2 field"
    type="text" name="time" value="{record.time}" placeholder="Time"/>
    <span if="{errors['time']}" class="inline-error">{errors['time']}</span>
    <textarea class="block col-12 mb2 field"
    type="text" name="description" placeholder="Description" >{record.description}</textarea>
    <span if="{errors['description']}" class="inline-error">{errors['description']}</span>

    <virtual if="{currentAccount.isAdministrator}">
      <label for="host_id">Host</label>
      <select class="block col-12 mb2 field" onchange="{setHost}">
        <option></option>
        <option each="{opts.project.customers}" value="{user_id}:{user_type}" selected="{record.host_id == user_id && record.host_type == user_type}">{profile.first_name} {profile.last_name}</option>
      </select>
      <span if="{errors['host']}" class="inline-error">{errors['host']}</span>
      <span if="{errors['host_id']}" class="inline-error">{errors['host_id']}</span>
      <span if="{errors['host_type']}" class="inline-error">{errors['host_type']}</span>
    </virtual>

    <label for="host_id">Attendand</label>
    <select class="block col-12 mb2 field" onchange="{setAttendant}">
      <option></option>
      <option each="{opts.project.professionals}" value="{user_id}:{user_type}" selected="{record.attendant_id == user_id && record.attendant_type == user_type}">{profile.first_name} {profile.last_name}</option>
    </select>
    <span if="{errors['attendant']}" class="inline-error">{errors['attendant']}</span>
    <span if="{errors['attendant_id']}" class="inline-error">{errors['attendant_id']}</span>
    <span if="{errors['attendant_type']}" class="inline-error">{errors['attendant_type']}</span>

    <button type="submit" class="block col-12 mb2 btn btn-big btn-primary {busy: busy}">Schedule</button>

  </form>

  <script>
  this.on('mount', () => {
    let picker = new Pikaday({
      field: this.time,
      onSelect:  (date) => {
        this.record.time = picker.toString()
        this.update()
      }
    })
  })
  this.record = {
    project_id: opts.project.id,
    host_id: this.currentAccount.user_id,
    host_type: this.currentAccount.user_type,
  }
  this.setHost = (e) => {
    let [id, type] = e.target.value.split(':')
    this.record.host_id = id
    this.record.host_type = type
    this.update()
  }
  this.setAttendant = (e) => {
    let [id, type] = e.target.value.split(':')
    this.record.attendant_id = id
    this.record.attendant_type = type
    this.update()
  }
  this.submit = (e) => {
    e.preventDefault()

    let data = this.serializeForm(this.form)

    if (_.isEmpty(data) || _.isEmpty(data.time)) {
      $(this.form).animateCss('shake')
      return
    }

    this.update({busy: true, errors: null})

    this.opts.api.appointments.create(data)
    .fail(this.errorHandler)
    .then(record => {
      this.update({record: record, busy:false})
      this.closeModal()
    })
  }
  </script>

</r-appointment-form>
