(function() {
    if (jQuery('.spec-wrapper').length) {
        var decider = jQuery('.invite-decider'), createSpecForm = jQuery('.create-spec-form');
        decider.delegate('input', 'click', function(e) {
            if (e.currentTarget.value && e.currentTarget.value === 'yes') {
                jQuery('.spec-pro-fields').show();
                decider.hide();
            }
        });
        jQuery('.spec-form-inputs').delegate('.pro-file-upload-btn', 'click', function(e) {
            jQuery(e.currentTarget).prev().find('input').click();
        });

        createSpecForm.submit(function(e) {
            createSpecForm.hide();
            jQuery('.speca-loader').show();
        });
    };
})();


