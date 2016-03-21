var Game; //variavel global que contem o jogo

(function (window, document, navigator, myApp, $) {
    "use strict"; // modo javascript mais rápido e não aceita erros
    var $window = $(window); // variavel global window
    var loop; // comtem ou vai conter o setInterval
    //objeto Game contem todo o jogo
    Game = {
        humano: {
            paginaModoHumano: null, //contem a pagina que acontecerá o jogo não posso instancia para receber a pagina já que ainda não foi carregada no DOM
            start: function (page) {
                this.paginaModoHumano = page; //adquire a pagina
                this.criarMosquito(); // Chama A função cria mosquito
                this.gerarMosquito(); // loop por tempo para gerar mosquitos
            },
            criarMosquito: function () {
                var mosquito = $('<img class="mosquito" src="img/mosquito.png">'); // cria um objeto mosquito
                mosquito.css("top", Game.randomTop(mosquito)); // insere a posição y
                mosquito.css("left", Game.randomLeft(mosquito)); // insere a posição x
                // Evento caso ele toque no objeto mosquito
                mosquito.on("mousedown touchstart", function (e) {
                    e.preventDefault();
                    console.log("Removeu")
                    $(this).remove();
                });
                Game.humano.paginaModoHumano.append(mosquito); // coloca mosquito no DOM
            },
            pausarGerarMosquito: function () {
                clearInterval(loop); // paussa ou para o loop de gerar mosquitos
            },
            gerarMosquito: function () {
                loop = setInterval(this.criarMosquito, 2500); // loop de gerar mosquitos
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