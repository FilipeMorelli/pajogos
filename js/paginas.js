(function (window, document, navigato, myApp, $, DataBase, Game) {
    
    myApp.onPageInit('modo-humano', function (page) {
        Game.humano.start($(".modo-humano"));
    });
    
    myApp.onPageBack("modo-humano", function(page){
       Game.humano.pausarGerarMosquito();
    });
    
    myApp.onPageInit('modo-mosquito', function (page) {
        //Game.mosquito.start($(".modo-mosquito"));
    });

})(window, document, navigator, myApp, Dom7, DataBase, Game)