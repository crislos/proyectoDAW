$(window).on('load', function() {
    removeLoader();
});
var removeLoader = function(){
    $(".loader_animation").removeClass("loader_animation");
    $(".loader_circle").fadeOut(400, function(){
        setTimeout(function(){
            $("body").css("overflow", "auto");
            $("#loader").delay(300).fadeOut(400, function(){
                $("#loader").remove();
            });
        }, 300);
    });
}