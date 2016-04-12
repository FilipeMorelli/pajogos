myApp = new Framework7
  material: true
  pushState: true
  swipePanel: 'left'
  swipePanelActiveArea: 56


# Export selectors engine
$ = Dom7;

# Add view
mainView = myApp.addView '.view-main',
  dynamicNavbar: true # Because we use fixed-through navbar we can enable dynamic navbar

# Configurar ajaxSetup
Dom7.ajaxSetup
  beforeSend: ->
    myApp.showIndicator()
  ,
  complete: ->
    myApp.hideIndicator()

class Database
  #contrutor da classe
  constructor: ->
    @name = "ZikaGame"
    @version = "1.0"
    @displayName = "ZikaGame"
    @maxSize = 65536
    @db = openDatabase(@name, @version, @displayName, @maxSize);

  #executa sql
    #1 - query select * from
    #2 - (result) -> console.log result
    #3 - paremetros em vetor e na order [1,50,"filipe"]
    #database.sqlExecute("select * from aluno", (result) ->console.log result)
  sqlExecute: (query, func, parameters = null) ->
    @db.transaction (transaction) ->
      transaction.executeSql query, parameters, (transaction, result) ->
        func(result)
      , (transaction, error) ->
        alert error.message

class Game extends Database
  constructor: (paginaContent) ->
    @vida = 100 #vida do jogador
    @window = $(window) #variavel que comtem o objeto window
    @pontosJogo = $(".pontos") #variavel que comtem a classe que mostra a pontuação
    @loopGerarConteudo = null; #comtem ou vai conter o setInterval
    if paginaContent?
      @paginaContent = paginaContent #@paginaContent = null; #contem a pagina que acontecerá o jogo não posso instancia para receber a pagina já que ainda não foi carregada no DOM
    else
      alert "Deu Problema Sério"

#OBS nao necessariamente somente adicionar por exemplo se passarmos o valor -5 subtraira -5 do total de pontos
  #vida do jogador
  addVida: (qtde) ->
    @vida += qtde

  #adiciona pontos para o jogador
  addPontos: (pontos) ->
    @pontosJogo.text(parseInt(@pontosJogo.text()) + pontos)

  #gera numero aleatorio no eixo x
  randomTop: (height) ->
    aleatorio = Math.random() * @window.heigth() + 56; # 56 area do navbar
    if aleatorio + height >= @window.height()
      "#{@window.height() - height}px";
    else
      "#{aleatorio}px";

  #gera numero aleatorio no eixo Y
  randomLeft: (width) ->
    aleatorio = Math.random * @window.width();
    if aleatorio + width >= @window.width()
      "#{@window.width() - width}px"
    else
      "#{aleatorio}px"

  #controla o fluxo do jogo como pausar e continuar
  pauseContinueJogo: ->
    clearInterval(@loopGerarConteudo); # paussa ou para de gerar conteudo por exemplo mosquitos
    @paginaContent.toggleClass("pause-background");


#criar Classe mosquito

#Jogo no modo Humano
class Mosquito extends Game
  constructor: () ->
  aparecer: () ->
  sumir: () ->
  morrer: () ->
  reproduzir: () ->
  infectar: () ->

#Jogo no modo mosquito
class Humano extends Game
  constructor: () ->
  aparecer: () ->
  sumir: () ->
  morrer: () ->
  proteção: () ->




myApp.onPageInit "modo-humano", (page) ->
  game = new Game($(".modo-humano"));
  #Game.humano.start($(".modo-humano"));
  $(".pause-continue-game").on "click", (e) ->
    $this = $(@)
    e.preventDefault()
    if $this.hasClass("pause-game")
      $this.addClass('continue-game').removeClass('pause-game')
      #Game.humano.pauseGerarMosquito()
    else
      $this.addClass('pause-game').removeClass('continue-game')
    #Game.humano.gerarMosquito()
  return;