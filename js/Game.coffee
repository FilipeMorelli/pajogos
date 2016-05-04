"use strict"

unloadEvent = (e) ->
  confirmationMessage = "Você realmente deseja sair da página?"
  (e || window.event).returnValue = confirmationMessage

window.addEventListener "beforeunload" , unloadEvent

try
  myApp = new Framework7
    material: true
    swipePanel: 'left'
    swipePanelActiveArea: 56
catch
  alert "Ocorreu um erro no carregamento da página!\n Será atualizada."
  window.location.reload()

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
    @addVida(0) #mostrar vida na tela
    @$window = $(window) #variavel que comtem o objeto window
    @pontosJogo = $(".modo-humano-page .pontos") #variavel que comtem a classe que mostra a pontuação
    @loopGerarConteudo = null; #comtem ou vai conter o setInterval
    if paginaContent?
      @paginaContent = paginaContent #@paginaContent = null; #contem a pagina que acontecerá o jogo não posso instancia para receber a pagina já que ainda não foi carregada no DOM
    else
      alert "Deu Problema Sério"

#OBS nao necessariamente somente adicionar por exemplo se passarmos o valor -5 subtraira -5 do total de pontos
#vida do jogador
  addVida: (qtde) ->
    @vida += qtde
    $("#vida").text(@vida)
    @vida

#adiciona pontos para o jogador
  addPontos: (pontos) ->
    @pontosJogo.text(parseInt(@pontosJogo.text()) + pontos)

  getPontos: ->
    parseInt(@pontosJogo.text())

#gera numero aleatorio no eixo x
  randomTop: (height) ->
    aleatorio = Math.random() * @$window.height() + 56 # 56 area do navbar
    if aleatorio + height >= @$window.height()
      "#{@$window.height() - height}px";
    else
      "#{aleatorio}px";

#gera numero aleatorio no eixo Y
  randomLeft: (width) ->
    aleatorio = Math.random() * @$window.width()
    if aleatorio + width >= @$window.width()
      "#{@$window.width() - width}px"
    else
      "#{aleatorio}px"



#criar Classe mosquito

#Jogo no modo Humano
class Mosquito extends Game
  loop: null # contem set interval do objeto
  aparecer: (num) ->
    $this = @ # para ativar o evento de clique para diferenciar o this da classe e o this do objeto jquery $(this)
    while num > 0 and @addVida(0) > 0
#mosquito = $('<img class="mosquito" src="img/mosquito.png" n1="197px" n2="-169px" n3="200px" n4="0px">')
      mosquito = null
      mosquito = $('<img class="mosquito" src="img/mosquito.png">')
      mosquito.css 'top' , $this.randomTop(36)
      mosquito.css 'left' , $this.randomLeft(36)
      mosquito.on 'mousedown touchstart', (e) ->
        e.preventDefault()
        $this.morrer($(@))
      $this.paginaContent.append(mosquito)
      $this.sumir(mosquito)
      num--
  sumir: (mosquito) ->
    setTimeout =>
      if mosquito.parents('html').length == 1
        mosquito.remove()
        @reproduzir()
    , 2500
  morrer: (mosquito) ->
    @addPontos(1)
    @addVida(1) #Adicionar vida ou não
    mosquito.remove()
  reproduzir: () ->
    @aparecer(1)
    @infectar()
  infectar: () ->
    if @addVida(-5) <= 0
      mainView.router.load(url: "game-over.html");
  gerarInimigo: ->
    @loop = setInterval =>
      if @getPontos() == 0
        @aparecer(1)
      else
        @aparecer(Math.ceil(@getPontos() * 1.01 / 10)) # apos cada 5 pontos aumenta o numero de mosquitos!
    , 2500


#Jogo no modo mosquito
class Humano extends Game
  aparecer: () ->
  sumir: () ->
  morrer: () ->
  proteção: () ->


mosquito = null
myApp.onPageInit "modo-humano", (page) ->
  mosquito = new Mosquito $(".modo-humano")
  mosquito.gerarInimigo()
  #mosquito.aparecer();

  #Game.humano.start($(".modo-humano"));
  $(".pause-continue-game").on "click", (e) ->
    $this = $(@)
    e.preventDefault()
    mosquito.pauseContinueJogo();
  return;


myApp.onPageBeforeRemove "modo-humano", (page) ->
  mosquito = null