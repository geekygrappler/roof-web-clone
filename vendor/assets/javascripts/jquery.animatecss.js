$.animationEnd = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend'
$.fn.extend({
    animateCss: function (animationName) {
        $(this).addClass('animated ' + animationName).one($.animationEnd, function() {
            $(this).removeClass('animated ' + animationName);
        });
    }
});
