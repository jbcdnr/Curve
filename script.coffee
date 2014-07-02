WIDTH = 600
HEIGHT = 600
ANGLE = Math.PI / 30
SPEED = 5
SIZE = 4
PERIOD = 50
BORDER = 5

context = null
window.onload = ->
  context = document.getElementById('canvas').getContext('2d')
  startGame()

drawCirc = (pos, radius, color) ->
  context.beginPath()
  context.arc(pos.e(1), pos.e(2), radius, 0, 2 * Math.PI, false)
  context.fillStyle = color
  context.fill()

clearCanvas = ->
  context.clearRect(0, 0, WIDTH, HEIGHT)

Directions = Left: -1, None: 0, Right: 1

class Player
  @id = 0
  
  constructor: (@left, @right, @color) ->
    @isAlive = true
    @position = Vector.create([0, 0])
    @speed = Vector.create([1, 0])
    @dir = Directions.None
    @dirs = [left: false, right: false]
    @id = Player.id++

  init: ->
    @position = Vector.create([Math.random() * WIDTH, Math.random() * HEIGHT])
    @speed = Vector.create([Math.random() - 0.5, Math.random() - 0.5]).toUnitVector()
    document.addEventListener "keydown", (e) =>
      @dirs.left = true if String.fromCharCode(e.keyCode) is @left
      @dirs.right = true if String.fromCharCode(e.keyCode) is @right
      @dir = if @dirs.left and not @dirs.right then Directions.Left else if @dirs.right and not @dirs.left then Directions.Right else Directions.None
    document.addEventListener "keyup", (e) =>
      @dirs.left = false if String.fromCharCode(e.keyCode) is @left
      @dirs.right = false if String.fromCharCode(e.keyCode) is @right
      @dir = if @dirs.left and not @dirs.right then Directions.Left else if @dirs.right and not @dirs.left then Directions.Right else Directions.None

  move: ->
    if @isAlive
      @speed = @speed.rotate(@dir * ANGLE, Vector.create([0,0])) if @dir isnt Directions.None
      @position = @position.add(@speed.multiply(SPEED))
    @isAlive = (game.field.filter (point, i) => (i < game.field.length - 10 or point.color isnt @color ) and point.pos.distanceFrom(@position) < 2 * SIZE).length is 0 and
      @position.e(1) > BORDER and @position.e(2) > BORDER and @position.e(1) < WIDTH - BORDER and @position.e(2) < HEIGHT - BORDER

game = 
  players: [new Player('Q', 'W', '#3498db'), new Player('O', 'P', '#c0392b')]
  field: []

refresh = ->
  for player in game.players when player.isAlive
    player.move()
    game.field.push { pos: player.position, color: player.color }
  clearCanvas()
  drawCirc(point.pos, SIZE, point.color, context) for point in game.field
  setTimeout refresh, PERIOD


startGame = ->
  player.init() for player in game.players
  setTimeout refresh, PERIOD
