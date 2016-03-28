import Handlebars from 'handlebars/dist/handlebars'

const rowTmp = Handlebars.compile(
  '<tr>' +
    '{{#each headers}}' +
    '<td>' +
      '{{valueOf .. this}}' +
    '</td>' +
    '{{/each}}' +
    '<td>' +
      '<button class="btn border btn-small mr1 mb1" data-open-record>' +
        '<i class="fa fa-pencil"></i>' +
      '</button>' +
      '<button class="btn btn-small border-red red mb1" data-destroy-record>' +
        '<i class="fa fa-trash-o"></i>' +
      '</button>' +
    '</td>' +
  '</tr>'
)

Handlebars.registerHelper('isObject', function(data) {
  return _.isObject(data)
})

Handlebars.registerHelper('valueOf', function(data, attr) {
  var val = data.record[attr]
  var tmp = ''
  if (_.isObject(val)) {
    tmp = '<div data-disclosure>' +
      '<a class="btn btn-small h5" data-handle>Expand</a>' +
      '<pre data-details>' +
        JSON.stringify(val, null, 2) +
      '</pre>' +
    '</div>'
  } else {
    tmp = val
  }
  return new Handlebars.SafeString(tmp)
})

export default rowTmp
