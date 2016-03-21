(function (window, document, navigato, myApp, $, DataBase, Game) {

    myApp.onPageInit('modo-mosquito', function (page) {
        Game.mosquito.start($(".modo-mosquito"));
    });

})(window, document, navigator, myApp, Dom7, DataBase, Game)