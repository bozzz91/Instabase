// This is a manifest file that'll be compiled into application.js.
//
// Any JavaScript file within this directory can be referenced here using a relative path.
//
// You're free to add application-wide JavaScript to this file, but it's generally better 
// to create separate JavaScript files as needed.
//
//= require jquery
//= require_tree .
//= require_self

if (typeof jQuery !== 'undefined') {
	(function($) {
		$(document).ajaxStart(function(){
			$('#spinner').fadeIn();
		}).ajaxStop(function(){
			$('#spinner').fadeOut();
		});
	})(jQuery);
}

function openDialog(text, refresh, width) {
    $("#dialog").text(text).dialog({
        modal: true,
        width: width,
        buttons: {
            'Ok': function() {
                $(this).dialog("close");
                if (refresh) {
                    window.location.reload();
                }
            }
        }
    });
}