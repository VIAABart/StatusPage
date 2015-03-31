$(document).ready(function() {
    update_status_rows();
    $.get("/motd", function(data) {
        $('#content').prepend(data).fadeIn(1000);
    },
        'html')
});

$(function() {
  $("#refresh").click(function(evt) { 
      update_status_rows();
      set_refresh_date();
  });
});

$.ajaxSetup ({  
    cache: false,
    timeout: 10000 
});

// fetch data from the server 
function update_status_rows() {
    LoadSpinner();
    $('#status-rows').fadeOut(100);
    $('#loading').fadeIn(100);
    $.get("/stats", function(data,status) {
        $('#status-rows').html(data).fadeIn(1000);
        },
        'html')
        .done(function( data ) {
            $('#loading').fadeOut(500);
        	spinner.stop();
    });
}

function set_refresh_date() {
    var date = new Date().toISOString();
    jQuery("span.timeago").timeago('update', date);
}

jQuery(document).ready(function($) {
    var date = new Date().toISOString();
    document.getElementById("refresh_date").title = date;
    jQuery("span.timeago").timeago();
});

var spinner;
 
function LoadSpinner() {
    var opts = {
        lines: 12, // The number of lines to draw
        length: 8, // The length of each line
        width: 4, // The line thickness
        radius: 18, // The radius of the inner circle
        corners: 0.1, // Corner roundness (0..1)
        rotate: 12, // The rotation offset
        direction: 1, // 1: clockwise, -1: counterclockwise
        color: '#000', // #rgb or #rrggbb or array of colors
        speed: 1.2, // Rounds per second
        trail: 36, // Afterglow percentage
        shadow: false, // Whether to render a shadow
        hwaccel: false, // Whether to use hardware acceleration
        className: 'spinner', // The CSS class to assign to the spinner
        zIndex: 2e9, // The z-index (defaults to 2000000000)
        top: '50%', // Top position relative to parent
        left: '50%' // Left position relative to parent
    };
	target = document.getElementById('loading');
	$('#loading').fadeIn();
	spinner = new Spinner(opts).spin(target);
}