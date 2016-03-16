'use strict';

$.fn.disclosure =  function (show) {
  return this.each(function() {
    var $element = $(this);
    $element.isActive = false;
    $element.details = $element.find('[data-details]');
    $element.handle = $element.find('[data-handle]');
    $element.hide = function () {
      $element.details.toggleClass('display-none', true);
    };
    $element.show = function () {
      $element.details.toggleClass('display-none', false);
    };
    ($element.handle.length > 0 ? $element.handle : $element).on('click', function (e) {
      // bad for turbolinks
      // e.stopPropagation();
      $element.isActive = !$element.isActive;
      if ($element.isActive) {
        $element.show();
      } else {
        $element.hide();
      }
    }.bind($element));
    if (!show) {
      $element.hide();
    } else {
      $element.isActive = true;
    }
  });
};
