//var Game; //variavel global que contem o jogo

(function (window, document, navigator, myApp, $) {
    "use strict"; // modo javascript mais rápido e não aceita erros
    var $window = $(window); // variavel global window
    var loop; // comtem ou vai conter o setInterval
    //objeto Game contem todo o jogo
    var Game = {
        humano: {
            paginaModoHumano: null, //contem a pagina que acontecerá o jogo não posso instancia para receber a pagina já que ainda não foi carregada no DOM
            start: function (page) {
                this.paginaModoHumano = page; //adquire a pagina
                this.criarMosquito(); // Chama A função cria mosquito
                this.gerarMosquito(); // loop por tempo para gerar mosquitos
            },
            criarMosquito: function () {
                var mosquito = $('<img class="mosquito" src="img/mosquito.png">'); // cria um objeto mosquito
                mosquito.css("top", Game.randomTop(36)); // insere a posição y
                mosquito.css("left", Game.randomLeft(36)); // insere a posição x
                // Evento caso ele toque no objeto mosquito
                mosquito.on("click touchstart", function (e) {
                    e.preventDefault();
                    Game.humano.addPonto(1);
                    $(this).remove();
                });
                Game.humano.paginaModoHumano.append(mosquito); // coloca mosquito no DOM
                setTimeout(function(){
                    if(mosquito.parents('html').length == 1){
                        /*
                        Ao inves de ter somente reduzir um no ponto
                        tera que diminuir no coração
                        que depois terei que fazer
                        */
                        Game.humano.addPonto(-1);
                        mosquito.remove();
                    }
                },5000);
            },
            addPonto: function(pontos){
                $(".pontos").text(parseInt($(".pontos").text()) + pontos)
            },
            pausarGerarMosquito: function () {
                clearInterval(loop); // paussa ou para o loop de gerar mosquitos
                this.paginaModoHumano.addClass("pause-background");
            },
            gerarMosquito: function () {
                loop = setInterval(this.criarMosquito, 2500); // loop de gerar mosquitos
                this.paginaModoHumano.removeClass("pause-background");
            }
        },
        mosquito: {
            paginaModoMosquito: null,
            start: function (page) {
                this.paginaModoMosquito = page;
            }
        },
        //objetos globais do Game tanto para o modo mosquito e para modo humano
        //retirar 36 pois ele é o tamanho fixo da imagem mosquito
        //56 tamanho do navbar
        randomTop: function (height) {
            var aleatorio = Math.random() * $window.height() + 56;
            if (aleatorio + height >= $window.height())
                return $window.height() - height + "px";
            return aleatorio + "px";
        },
        randomLeft: function (width) {
            var aleatorio = Math.random() * $window.width();
            if (aleatorio + width >= $window.width())
                return $window.width() - width + "px";
            return aleatorio + "px";
        },
    }
    
    /* Paginas */
    myApp.onPageInit('modo-humano', function (page) {
        Game.humano.start($(".modo-humano"));
        
        $(".pause-continue-game").on("click", function(e){
            e.preventDefault();
            var $this = $(this);
            if($this.hasClass('pause-game')){
                $this.addClass('continue-game').removeClass('pause-game')
                Game.humano.pausarGerarMosquito();
            } else {
                $this.addClass('pause-game').removeClass('continue-game')
                Game.humano.gerarMosquito();
            }
            
        });
    });
    
    myApp.onPageBack("modo-humano", function(page){
       Game.humano.pausarGerarMosquito();
    });
    
    myApp.onPageInit('modo-mosquito', function (page) {
        //Game.mosquito.start($(".modo-mosquito"));
    });
    
})(window, document, navigator, myApp, Dom7)