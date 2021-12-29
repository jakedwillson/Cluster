$(function () {
    $('.list-group-item > .show-menu').on('click', function(event) {
        event.preventDefault();
        $(this).closest('li').toggleClass('open');
    });
});