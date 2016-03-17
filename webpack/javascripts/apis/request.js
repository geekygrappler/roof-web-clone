export default function ({url, type = 'get', data = null}) {
  if (!$.csrfToken) {
    return $.getJSON('/api/accounts/csrf_token.json')
    .then( (d, x, r) => {
      var token = r.getResponseHeader('X-CSRF-Token')
      if (token) {
        $.csrfToken = token
        $('meta[name=csrf-token]').attr('content', token)

        return $.ajax({
          url: url,
          type: type,
          data: data ? type == 'get' ? data : JSON.stringify(data) : null,
          contentType: type == 'get' ? null : 'application/json',
          dataType: 'json',
          beforeSend: function(xhr) {
            xhr.setRequestHeader("X-Csrf-Token", $.csrfToken);
          }
        })
      }
    })
  } else {
    return $.ajax({
      url: url,
      type: type,
      data: data ? type == 'get' ? data : JSON.stringify(data) : null,
      contentType: type == 'get' ? null : 'application/json',
      dataType: 'json',
      beforeSend: function(xhr) {
        // xhr.setRequestHeader("X-Csrf-Token", $('[name=csrf-token]').attr('content'));
        xhr.setRequestHeader("X-Csrf-Token", $.csrfToken);
      }
    })
  }
}
