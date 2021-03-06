// Generated by CoffeeScript 1.10.0
(function() {
  "use strict";
  var $, Game, Humano, Mosquito, error, mainView, mensagensFinais, mensagensIniciais, modoMosquito, mosquito, myApp, unloadEvent,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  unloadEvent = function(e) {
    var confirmationMessage;
    confirmationMessage = "Você realmente deseja sair da página?";
    return (e || window.event).returnValue = confirmationMessage;
  };

  window.addEventListener("beforeunload", unloadEvent);

  try {
    myApp = new Framework7({
      material: true,
      swipePanel: 'left',
      swipePanelActiveArea: 56
    });
  } catch (error) {
    alert("Ocorreu um erro no carregamento da página!\n Será atualizada.");
    window.location.reload();
  }

  $ = Dom7;

  mainView = myApp.addView('.view-main', {
    dynamicNavbar: true
  });

  Dom7.ajaxSetup({
    beforeSend: function() {
      return myApp.showIndicator();
    },
    complete: function() {
      return myApp.hideIndicator();
    }
  });

  Game = (function() {
    function Game(paginaContent) {
      this.vida = 100;
      this.dificuldade = 0;
      this.addVida(0);
      this.$window = $(window);
      this.pontosJogo = $(".modo-humano-page .pontos");
      this.loopGerarConteudo = null;
      this.iniciaPontuacaoModoMosquito();
      this.iniciaPontuacaoModoHumano();
      if (paginaContent != null) {
        this.paginaContent = paginaContent;
      } else {
        alert("Deu Problema Sério");
      }
    }

    Game.prototype.addVida = function(qtde) {
      this.vida += qtde;
      $("#vida").text(this.vida);
      return this.vida;
    };

    Game.prototype.addPontosHumano = function(pontos) {
      this.dificuldade += pontos;
      return this.pontosJogo.text(parseInt(this.pontosJogo.text()) + pontos);
    };

    Game.prototype.addPontosMosquito = function(pontos) {
      this.dificuldade += pontos;
      return this.pontosJogo.text(parseInt(this.pontosJogo.text()) + pontos);
    };

    Game.prototype.getDificuldade = function() {
      return parseInt(this.dificuldade);
    };

    Game.prototype.getPontosHumano = function() {
      return parseInt(this.pontosJogo.text());
    };

    Game.prototype.getPontosMosquito = function() {
      return parseInt(this.pontosJogo.text());
    };

    Game.prototype.zeraDificuldade = function() {
      return this.dificuldade = 0;
    };

    Game.prototype.iniciaPontuacaoModoMosquito = function() {
      if (localStorage.getItem('pontuacao-modo-mosquito') == null) {
        return this.setPontuacaoModoMosquito(0);
      }
    };

    Game.prototype.getPontuacaoModoMosquito = function() {
      return localStorage.getItem('pontuacao-modo-mosquito');
    };

    Game.prototype.setPontuacaoModoMosquito = function(pts) {
      return localStorage.setItem('pontuacao-modo-mosquito', pts);
    };

    Game.prototype.iniciaPontuacaoModoHumano = function() {
      if (localStorage.getItem('pontuacao-modo-humano') == null) {
        return this.setPontuacaoModoHumano(0);
      }
    };

    Game.prototype.getPontuacaoModoHumano = function() {
      return localStorage.getItem('pontuacao-modo-humano');
    };

    Game.prototype.setPontuacaoModoHumano = function(pts) {
      return localStorage.setItem('pontuacao-modo-humano', pts);
    };

    Game.prototype.randomTop = function(height) {
      var aleatorio;
      aleatorio = Math.random() * this.$window.height() + 56;
      if (aleatorio + height >= this.$window.height()) {
        return (this.$window.height() - height) + "px";
      } else {
        return aleatorio + "px";
      }
    };

    Game.prototype.randomLeft = function(width) {
      var aleatorio;
      aleatorio = Math.random() * this.$window.width();
      if (aleatorio + width >= this.$window.width()) {
        return (this.$window.width() - width) + "px";
      } else {
        return aleatorio + "px";
      }
    };

    return Game;

  })();

  Mosquito = (function(superClass) {
    extend(Mosquito, superClass);

    function Mosquito() {
      return Mosquito.__super__.constructor.apply(this, arguments);
    }

    Mosquito.prototype.loop = null;

    Mosquito.prototype.aparecer = function(num) {
      var $this, animation, mosquito, results;
      $this = this;
      results = [];
      while (num > 0 && this.addVida(0) > 0) {
        mosquito = null;
        mosquito = $('<img class="mosquito" src="img/mosquito.png">');
        mosquito.css('top', $this.randomTop(36));
        mosquito.css('left', $this.randomLeft(36));
        animation = ['direita', 'nada', 'esquerda', 'nada', 'descer', 'nada', 'subir', 'nada', 'zigzag_descendo', 'nada', 'zigzag_sobe', 'nada', 'zigzag_aleatorio', 'nada', 'perto', 'nada', 'longe'];
        mosquito.addClass(animation[Math.floor(Math.random() * animation.length)]);
        mosquito.on('mousedown touchstart', function(e) {
          e.preventDefault();
          $(this).attr("src", "img/mosquito-morto.png");
          $(this).attr("class", "mosquito");
          return $this.morrer($(this));
        });
        $this.paginaContent.append(mosquito);
        $this.sumir(mosquito);
        results.push(num--);
      }
      return results;
    };

    Mosquito.prototype.sumir = function(mosquito) {
      return setTimeout((function(_this) {
        return function() {
          if (mosquito.parents('html').length === 1) {
            mosquito.remove();
            return _this.reproduzir();
          }
        };
      })(this), 2500);
    };

    Mosquito.prototype.morrer = function(mosquito) {
      this.addPontosHumano(1);
      this.addVida(1);
      return setTimeout((function(_this) {
        return function() {
          return mosquito.remove();
        };
      })(this), 250);
    };

    Mosquito.prototype.reproduzir = function() {
      this.aparecer(1);
      return this.infectar();
    };

    Mosquito.prototype.infectar = function() {
      if (this.addVida(-2) <= 0) {
        return this.gameOver();
      }
    };

    Mosquito.prototype.gerarInimigo = function() {
      return this.loop = setInterval((function(_this) {
        return function() {
          if (_this.getDificuldade() === 0) {
            return _this.aparecer(1);
          } else {
            return _this.aparecer(Math.ceil(_this.getDificuldade() * 1.01 / 10));
          }
        };
      })(this), 2500);
    };

    Mosquito.prototype.gameOver = function() {
      mainView.router.load({
        url: "game-over-humano.html"
      });
      return clearInterval(this.loop);
    };

    return Mosquito;

  })(Game);

  Humano = (function(superClass) {
    extend(Humano, superClass);

    function Humano() {
      return Humano.__super__.constructor.apply(this, arguments);
    }

    Humano.prototype.aparecer = function() {};

    Humano.prototype.sumir = function() {};

    Humano.prototype.morrer = function() {};

    Humano.prototype.proteção = function() {};

    return Humano;

  })(Game);

  mosquito = null;

  mensagensIniciais = ["Mate a maior quantidade de mosquitos", "Faça a maior pontuação", "Não deixe mosquitos escaparem", "Não deixe seu coração chegar a 0", "Consiga a maior pontuação"];

  mensagensFinais = ["<h2>O que é a Dengue?</h2>A dengue é uma doença viral transmitida pelo mosquito Aedes aegypti. No Brasil, foi identificada pela primeira vez em 1986. Estima-se que 50 milhões de infecções por dengue ocorram anualmente no mundo.", "<h2>Quais são os sintomas da Dengue?</h2>A infecção por dengue pode ser assintomática, leve ou causar doença grave, levando à morte. Normalmente, a primeira manifestação da dengue é a febre alta (39° a 40°C), de início abrupto, que geralmente dura de 2 a 7 dias, acompanhada de dor de cabeça, dores no corpo e articulações, prostração, fraqueza, dor atrás dos olhos, erupção e coceira na pele. Perda de peso, náuseas e vômitos são comuns. Na fase febril inicial da doença pode ser difícil diferenciá-la. A forma grave da doença inclui dor abdominal intensa e contínua, vômitos persistentes, sangramento de mucosas, entre outros sintomas.", "<h2>Como a Dengue pode ser transmitida?</h2>A principal forma de transmissão é pela picada dos mosquitos Aedes aegypti. Há registros de transmissão vertical (gestante - bebê) e por transfusão de sangue.", "<h2>Qual o tratamento para a Dengue?</h2>Não existe tratamento específico para dengue. O tratamento é feito para aliviar os sintomas Quando aparecer os sintomas, é importante procurar um serviço de saúde mais próximo, fazer repouso e ingerir bastante líquido. Importante não tomar medicamentos por conta própria.", "<h2>Como prevenir?</h2>Ainda não existe vacina ou medicamentos contra dengue. Portanto, a única forma de prevenção é acabar com o mosquito, mantendo o domicílio sempre limpo, eliminando os possíveis criadouros. Roupas que minimizem a exposição da pele durante o dia, quando os mosquitos são mais ativos, proporcionam alguma proteção às picadas e podem ser adotadas principalmente durante surtos.", "<h2>O que é o Chikungunya?</h2>A Febre Chikungunya é uma doença transmitida pelos mosquitos Aedes aegypti e Aedes albopictus. No Brasil, a circulação do vírus foi identificada pela primeira vez em 2014. Chikungunya significa \"aqueles que se dobram\" em swahili, um dos idiomas da Tanzânia. Refere-se à aparência curvada dos pacientes que foram atendidos na primeira epidemia documentada, na Tanzânia, localizada no leste da África, entre 1952 e 1953.", "<h2>Quais são os sintomas da Chikungunya?</h2>Os principais sintomas são febre alta de início rápido, dores intensas nas articulações dos pés e mãos, além de dedos, tornozelos e pulsos. Pode ocorrer ainda dor de cabeça, dores nos músculos e manchas vermelhas na pele. Não é possível ter chikungunya mais de uma vez. Depois de infectada, a pessoa fica imune pelo resto da vida. Os sintomas iniciam entre dois e doze dias após a picada do mosquito. O mosquito adquire o vírus CHIKV ao picar uma pessoa infectada, durante o período em que o vírus está presente no organismo infectado. Cerca de 30% dos casos não apresentam sintomas.", "<h2>Como é feito o tratamento da Chikungunya?</h2>Não existe vacina ou tratamento específico para Chikungunya. Os sintomas são tratados com medicação para a febre (paracetamol) e as dores articulares (antiinflamatórios). Não é recomendado usar o ácido acetil salicílico (AAS) devido ao risco de hemorragia. Recomenda-se repouso absoluto ao paciente, que deve beber líquidos em abundância.", "<h2>Como prevenir a Chikungunya?</h2>Assim como a dengue, é fundamental que as pessoas reforcem as medidas de eliminação dos criadouros de mosquitos nas suas casas e na vizinhança. Quando há notificação de caso suspeito, as Secretarias Municipais de Saúde devem adotar ações de eliminação de focos do mosquito nas áreas próximas à residência e ao local de atendimento dos pacientes. ", "<h2>O que é o Zica?</h2>O Zika é um vírus transmitido pelo Aedes aegypti e identificado pela primeira vez no Brasil em abril de 2015. O vírus Zika recebeu a mesma denominação do local de origem de sua identificação em 1947, após detecção em macacos sentinelas para monitoramento da febre amarela, na floresta Zika, em Uganda.", "<h2>Quais são os sintomas da Zica?</h2>Cerca de 80% das pessoas infectadas pelo vírus Zika não desenvolvem manifestações clínicas. Os principais sintomas são dor de cabeça, febre baixa, dores leves nas articulações, manchas vermelhas na pele, coceira e vermelhidão nos olhos. Outros sintomas menos frequentes são inchaço no corpo, dor de garganta, tosse e vômitos. No geral, a evolução da doença é benigna e os sintomas desaparecem espontaneamente após 3 a 7 dias. No entanto, a dor nas articulações pode persistir por aproximadamente um mês. Formas graves e atípicas são raras, mas quando ocorrem podem, excepcionalmente, evoluir para óbito, como identificado no mês de novembro de 2015, pela primeira vez na história.", "<h2>Como a Zica é transmitida?</h2>O principal modo de transmissão descrito do vírus é pela picada do Aedes aegypti. Outras possíveis formas de transmissão do vírus Zika precisam ser avaliadas com mais profundidade, com base em estudos científicos. Não há evidências de transmissão do vírus Zika por meio do leite materno, assim como por urina, saliva e sêmen. Conforme estudos aplicados na Polinésia Francesa, não foi identificada a replicação do vírus em amostras do leite, assim como a doença não pode ser classificada como sexualmente transmissível. Também não há descrição de transmissão por saliva.", "<h2>Qual o tratamento para o Zica?</h2>Não existe tratamento específico para a infecção pelo vírus Zika. Também não há vacina contra o vírus. O tratamento recomendado para os casos sintomáticos é baseado no uso de acetaminofeno (paracetamol) ou dipirona para o controle da febre e manejo da dor. No caso de erupções pruriginosas, os anti-histamínicos podem ser considerados.Não se recomenda o uso de ácido acetilsalicílico (AAS) e outros anti-inflamatórios, em função do risco aumentado de complicações hemorrágicas descritas nas infecções por outros flavivírus. Os casos suspeitos devem ser tratados como dengue, devido à sua maior frequência e gravidade conhecida."];

  myApp.onPageInit("modo-humano", modoMosquito = function(page) {
    mosquito = null;
    mosquito = new Mosquito($(".modo-humano"));
    return myApp.addNotification({
      message: mensagensIniciais[Math.floor(Math.random() * mensagensIniciais.length)],
      button: {
        text: 'Começar!'
      },
      onClose: function() {
        return setTimeout(function() {
          return mosquito.gerarInimigo();
        }, 500);
      }
    });
  });

  myApp.onPageInit("game-over-humano", function(page) {
    var pts;
    pts = mosquito.getPontosHumano();
    if (parseInt(pts) > parseInt(mosquito.getPontuacaoModoHumano())) {
      mosquito.setPontuacaoModoHumano(pts);
    }
    $(".pontuacao-atual").text(pts);
    $(".recorde").text(mosquito.getPontuacaoModoHumano());
    $(".mensagem").html(mensagensFinais[Math.floor(Math.random() * mensagensFinais.length)]);
    return mosquito = null;
  });

  myApp.onPageInit("game-over-mosquito", function(page) {
    var pts;
    pts = mosquito.getPontos();
    if (parseInt(pts) > parseInt(mosquito.getPontuacaoModoHumano())) {
      mosquito.setPontuacaoModoHumano(pts);
    }
    $(".pontuacao-atual").text(pts);
    $(".recorde").text(mosquito.getPontuacaoModoHumano());
    $(".mensagem").html(mensagensFinais[Math.floor(Math.random() * mensagensFinais.length)]);
    return mosquito = null;
  });

}).call(this);

//# sourceMappingURL=Game.js.map
