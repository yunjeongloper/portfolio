(function($) {

    $.mobilemenu = function(options) {

        var settings = $.extend({
            menu: '#mobilemenu',
            trigger: '#mobilemenu button.trigger'
        }, options);

        $(settings.menu).remove();

        $(settings.trigger).click(function() {
            if (!$(this).hasClass('active')) {
                $(this).addClass('active');
                $(settings.menu).addClass('active');
                return $('body').css('overflow', 'hidden');
            } else {
                $(this).removeClass('active');
                $(settings.menu).removeClass('active');
                return $('body').css('overflow', 'auto');
            }
        });

    };

}(jQuery));