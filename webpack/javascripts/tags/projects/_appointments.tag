import Pikaday from 'pikaday-time/pikaday'

<r-project-appointments>
  <div class="sm-col-12 px2 border">
    <h3><i class="fa fa-calendar-o"></i> Appointments</h3>


    <a class="h6 btn btn-small btn-primary mb2" onclick="{openAppointmentModal}"><i class="fa fa-calendar-check-o"></i> Arrange Appointment</a>

    <dl each="{appointments}" class="{gray: isPast(time)}">
      <dt class="left">
        <i class="fa fa-{'thumbs-o-up': isPast(time), 'hand-o-right': isFuture(time)}"></i>
      </dt>
      <dd>
        <h4>At {formatTime(time)}</h4>
        <div><strong>Host:</strong> {host.profile.first_name} {host.profile.last_name}</div>
        <div><strong>Attendant:</strong> {attendant.profile.first_name} {attendant.profile.last_name}</div>
        <a if="{isFuture(time)}" class="btn btn-small h6 bg-maroon white mt1" onclick="{cancelAppointment}"><i class="fa fa-ban"></i> Cancel</a>
      </dd>
    </dl>

  </div>

  <script>
  this.on('mount', () => {
    opts.api.appointments.on('create.success', this.addAppointment)
    opts.api.appointments.on('delete.success', this.removeAppointment)
    this.loadResources('appointments', {project_id: this.opts.record.id})
  })

  this.on('unmount', () => {
    opts.api.appointments.off('create.success', this.addAppointment)
    opts.api.appointments.off('delete.success', this.removeAppointment)
  })
  // this.on('update', () => {
  //   if(this.opts.record && this.opts.record.id && !this.appointments) {
  //    this.loadResources('appointments', {project_id: this.opts.record.id})
  //   }
  // })
  this.openAppointmentModal = (e) => {
    e.preventDefault()
    riot.mount('r-modal', {
      content: 'r-appointment-form',
      persisted: false,
      api: opts.api,
      contentOpts: {api: opts.api, project: this.opts.record}
    })
  }
  this.cancelAppointment = (e) => {
    e.preventDefault()
    opts.api.appointments.delete(e.item.id)
    .fail(this.errorHandler)
  }
  this.addAppointment = (record) => {
    let _id = _.findIndex(this.appointments, r => r.id == record.id)
    if (_id === -1) {
      this.appointments.push(record)
      this.update()
    }
  }

  this.removeAppointment = (id) => {
    let _id = _.findIndex(this.appointments, r => r.id == id)
    if(_id > -1) {
      this.appointments.splice(_id, 1)
      this.update()
    }
  }
  </script>
</r-project-appointments>

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

    <div if="{currentAccount.isAdministrator}" class="bg-blue white p1">
      <label for="host_id">Host</label>
      <select class="block col-12 mb2 field" onchange="{setHost}">
        <option></option>
        <option each="{opts.project.customers}" value="{user_id}:{user_type}" selected="{record.host_id == user_id && record.host_type == user_type}">{profile.first_name} {profile.last_name}</option>
      </select>
      <span if="{errors['host']}" class="inline-error">{errors['host']}</span>
      <span if="{errors['host_id']}" class="inline-error">{errors['host_id']}</span>
      <span if="{errors['host_type']}" class="inline-error">{errors['host_type']}</span>
    </div>

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
