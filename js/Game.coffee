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

class Game
  constructor: (paginaContent) ->
    @vida = 100 #vida do jogador
    @dificuldade = 0;
    @addVida(0) #mostrar vida na tela
    @$window = $(window) #variavel que comtem o objeto window
    @pontosJogo = $(".modo-humano-page .pontos") #variavel que comtem a classe que mostra a pontuação
    @loopGerarConteudo = null; #comtem ou vai conter o setInterval
    @iniciaPontuacaoModoMosquito() #caso nao tenha iniciado a pontuacao modo mosquito
    @iniciaPontuacaoModoHumano() #caso nao tenha iniciado a pontuacao modo humano
    @inic
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
  addPontosHumano: (pontos) ->
    @dificuldade += pontos
    @pontosJogo.text(parseInt(@pontosJogo.text()) + pontos)

  addPontosMosquito: (pontos) ->
    @dificuldade += pontos
    @pontosJogo.text(parseInt(@pontosJogo.text()) + pontos)

  getDificuldade: ->
    parseInt(@dificuldade)

  getPontosHumano: ->
    parseInt(@pontosJogo.text())

  getPontosMosquito: ->
    parseInt(@pontosJogo.text())

  zeraDificuldade: ->
    @dificuldade = 0

  iniciaPontuacaoModoMosquito: ->
    if !localStorage.getItem('pontuacao-modo-mosquito')?
      @setPontuacaoModoMosquito(0)

  getPontuacaoModoMosquito: ->
    localStorage.getItem('pontuacao-modo-mosquito')

  setPontuacaoModoMosquito: (pts) ->
    localStorage.setItem('pontuacao-modo-mosquito', pts)

  iniciaPontuacaoModoHumano: ->
    if !localStorage.getItem('pontuacao-modo-humano')?
      @setPontuacaoModoHumano(0)

  getPontuacaoModoHumano: ->
    localStorage.getItem('pontuacao-modo-humano')

  setPontuacaoModoHumano: (pts) ->
    localStorage.setItem('pontuacao-modo-humano', pts)

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
    @addPontosHumano(1)
    @addVida(1) #Adicionar vida ou não
    mosquito.remove()
  reproduzir: () ->
    @aparecer(1)
    @infectar()
  infectar: () ->
    if @addVida(-5) <= 0
      @gameOver()
  gerarInimigo: ->
    @loop = setInterval =>
      if @getDificuldade() == 0
        @aparecer(1)
      else
        @aparecer(Math.ceil(@getDificuldade() * 1.01 / 10)) # apos cada 5 pontos aumenta o numero de mosquitos!
    , 2500
  gameOver: (obj) ->
    mainView.router.load(url: "game-over-humano.html");
    clearInterval(@loop) # encerar o loop para gerar inimigo


#Jogo no modo mosquito
class Humano extends Game
  aparecer: () ->
  sumir: () ->
  morrer: () ->
  proteção: () ->


mosquito = null

mensagens = [
  "<h2>O que é a Dengue?</h2>A dengue é uma doença viral transmitida pelo mosquito Aedes aegypti. No Brasil, foi identificada pela primeira vez em 1986. Estima-se que 50 milhões de infecções por dengue ocorram anualmente no mundo.",
  "<h2>Quais são os sintomas da Dengue?</h2>A infecção por dengue pode ser assintomática, leve ou causar doença grave, levando à morte. Normalmente, a primeira manifestação da dengue é a febre alta (39° a 40°C), de início abrupto, que geralmente dura de 2 a 7 dias, acompanhada de dor de cabeça, dores no corpo e articulações, prostração, fraqueza, dor atrás dos olhos, erupção e coceira na pele. Perda de peso, náuseas e vômitos são comuns. Na fase febril inicial da doença pode ser difícil diferenciá-la. A forma grave da doença inclui dor abdominal intensa e contínua, vômitos persistentes, sangramento de mucosas, entre outros sintomas.",
  "<h2>Como a Dengue pode ser transmitida?</h2>A principal forma de transmissão é pela picada dos mosquitos Aedes aegypti. Há registros de transmissão vertical (gestante - bebê) e por transfusão de sangue.",
  "<h2>Qual o tratamento para a Dengue?</h2>Não existe tratamento específico para dengue. O tratamento é feito para aliviar os sintomas Quando aparecer os sintomas, é importante procurar um serviço de saúde mais próximo, fazer repouso e ingerir bastante líquido. Importante não tomar medicamentos por conta própria.",
  "<h2>Como prevenir?</h2>Ainda não existe vacina ou medicamentos contra dengue. Portanto, a única forma de prevenção é acabar com o mosquito, mantendo o domicílio sempre limpo, eliminando os possíveis criadouros. Roupas que minimizem a exposição da pele durante o dia, quando os mosquitos são mais ativos, proporcionam alguma proteção às picadas e podem ser adotadas principalmente durante surtos.",
  "<h2>O que é o Chikungunya?</h2>A Febre Chikungunya é uma doença transmitida pelos mosquitos Aedes aegypti e Aedes albopictus. No Brasil, a circulação do vírus foi identificada pela primeira vez em 2014. Chikungunya significa \"aqueles que se dobram\" em swahili, um dos idiomas da Tanzânia. Refere-se à aparência curvada dos pacientes que foram atendidos na primeira epidemia documentada, na Tanzânia, localizada no leste da África, entre 1952 e 1953.",
  "<h2>Quais são os sintomas da Chikungunya?</h2>Os principais sintomas são febre alta de início rápido, dores intensas nas articulações dos pés e mãos, além de dedos, tornozelos e pulsos. Pode ocorrer ainda dor de cabeça, dores nos músculos e manchas vermelhas na pele. Não é possível ter chikungunya mais de uma vez. Depois de infectada, a pessoa fica imune pelo resto da vida. Os sintomas iniciam entre dois e doze dias após a picada do mosquito. O mosquito adquire o vírus CHIKV ao picar uma pessoa infectada, durante o período em que o vírus está presente no organismo infectado. Cerca de 30% dos casos não apresentam sintomas.",
  "<h2>Como é feito o tratamento da Chikungunya?</h2>Não existe vacina ou tratamento específico para Chikungunya. Os sintomas são tratados com medicação para a febre (paracetamol) e as dores articulares (antiinflamatórios). Não é recomendado usar o ácido acetil salicílico (AAS) devido ao risco de hemorragia. Recomenda-se repouso absoluto ao paciente, que deve beber líquidos em abundância.",
  "<h2>Como prevenir a Chikungunya?</h2>Assim como a dengue, é fundamental que as pessoas reforcem as medidas de eliminação dos criadouros de mosquitos nas suas casas e na vizinhança. Quando há notificação de caso suspeito, as Secretarias Municipais de Saúde devem adotar ações de eliminação de focos do mosquito nas áreas próximas à residência e ao local de atendimento dos pacientes. ",
  "<h2>O que é o Zica?</h2>O Zika é um vírus transmitido pelo Aedes aegypti e identificado pela primeira vez no Brasil em abril de 2015. O vírus Zika recebeu a mesma denominação do local de origem de sua identificação em 1947, após detecção em macacos sentinelas para monitoramento da febre amarela, na floresta Zika, em Uganda.",
  "<h2>Quais são os sintomas da Zica?</h2>Cerca de 80% das pessoas infectadas pelo vírus Zika não desenvolvem manifestações clínicas. Os principais sintomas são dor de cabeça, febre baixa, dores leves nas articulações, manchas vermelhas na pele, coceira e vermelhidão nos olhos. Outros sintomas menos frequentes são inchaço no corpo, dor de garganta, tosse e vômitos. No geral, a evolução da doença é benigna e os sintomas desaparecem espontaneamente após 3 a 7 dias. No entanto, a dor nas articulações pode persistir por aproximadamente um mês. Formas graves e atípicas são raras, mas quando ocorrem podem, excepcionalmente, evoluir para óbito, como identificado no mês de novembro de 2015, pela primeira vez na história.",
  "<h2>Como a Zica é transmitida?</h2>O principal modo de transmissão descrito do vírus é pela picada do Aedes aegypti. Outras possíveis formas de transmissão do vírus Zika precisam ser avaliadas com mais profundidade, com base em estudos científicos. Não há evidências de transmissão do vírus Zika por meio do leite materno, assim como por urina, saliva e sêmen. Conforme estudos aplicados na Polinésia Francesa, não foi identificada a replicação do vírus em amostras do leite, assim como a doença não pode ser classificada como sexualmente transmissível. Também não há descrição de transmissão por saliva.",
  "<h2>Qual o tratamento para o Zica?</h2>Não existe tratamento específico para a infecção pelo vírus Zika. Também não há vacina contra o vírus. O tratamento recomendado para os casos sintomáticos é baseado no uso de acetaminofeno (paracetamol) ou dipirona para o controle da febre e manejo da dor. No caso de erupções pruriginosas, os anti-histamínicos podem ser considerados.Não se recomenda o uso de ácido acetilsalicílico (AAS) e outros anti-inflamatórios, em função do risco aumentado de complicações hemorrágicas descritas nas infecções por outros flavivírus. Os casos suspeitos devem ser tratados como dengue, devido à sua maior frequência e gravidade conhecida.",
]

myApp.onPageInit "modo-humano", modoMosquito = (page) ->
    mosquito = null
    mosquito = new Mosquito $(".modo-humano")
    mosquito.gerarInimigo()

myApp.onPageInit "game-over-humano", (page) ->

  pts = mosquito.getPontosHumano() #pega a pontuacao atual do jogo

  #verifica se vai ter recorde ou nao
  if parseInt(pts) > parseInt(mosquito.getPontuacaoModoHumano())
    mosquito.setPontuacaoModoHumano(pts);


  $(".pontuacao-atual").text(pts)
  $(".recorde").text(mosquito.getPontuacaoModoHumano())
  $(".mensagem").html(mensagens[Math.floor(Math.random() * mensagens.length)]);
  mosquito = null #mata o processo do jogo



myApp.onPageInit "game-over-mosquito", (page) ->

  pts = mosquito.getPontos() #pega a pontuacao atual do jogo

  #verifica se vai ter recorde ou nao
  if parseInt(pts) > parseInt(mosquito.getPontuacaoModoHumano())
    mosquito.setPontuacaoModoHumano(pts);

  $(".pontuacao-atual").text(pts)
  $(".recorde").text(mosquito.getPontuacaoModoHumano())
  $(".mensagem").html(mensagens[Math.floor(Math.random() * mensagens.length)]);
  mosquito = null #mata o processo do jogo
