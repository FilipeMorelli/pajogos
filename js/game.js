var Game; //variavel global que contem o jogo

(function (window, document, navigator, myApp, $) {
    "use strict"; // modo javascript mais rápido e não aceita erros
    var $window = $(window); // variavel global window
    //objeto Game contem todo o jogo
    Game = {
        humano: {
            paginaModoHumano: null, //contem a pagina que acontecerá o jogo não posso instancia para receber a pagina já que ainda não foi carregada no DOM
            start: function (page) {
                this.paginaModoHumano = page;
                this.gerarMosquito();
                setInterval(this.gerarMosquito, 5000)
            },
            gerarMosquito: function () {
                var mosquito = $('<img class="mosquito" src="img/mosquito.png" width="36" height="36">');
                mosquito.css("top", Game.randomTop(mosquito));
                mosquito.css("left", Game.randomLeft(mosquito));
                mosquito.on("mousedown touchstart", function (e) {
                    e.preventDefault();
                    console.log("Removeu")
                    $(this).remove();
                });
                Game.humano.paginaModoHumano.append(mosquito);
            }
        },
        mosquito: {
            paginaModoMosquito: null,
            start: function (page) {
                this.paginaModoMosquito = page;
            }
        },
        //objetos globais do Game tanto para o modo mosquito e para modo humano
        //retirar 36 pois ele é o tamanho fixo da imagem mosquitp
        randomTop: function (obj) {
            var aleatorio = Math.random() * $window.height();
            if (aleatorio + 36 >= $window.height())
                return $window.height() - obj.height() + "px";
            return aleatorio + "px";
        },
        randomLeft: function (obj) {
            var aleatorio = Math.random() * $window.width();
            if (aleatorio + 36 >= $window.width())
                return $window.width() - obj.width() + "px";
            return aleatorio + "px";
        },
    }
})(window, document, navigator, myApp, Dom7)