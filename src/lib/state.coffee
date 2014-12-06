config = require './config.coffee'

class State
  preload: ->
    @game.stage = $.extend @game.stage, config.stage
    
    @game.load.image imageName, path for imageName, path of config.images

  create: ->
    @setUpGame()

    @createCharacter()

    @createWorld()

  update: ->
    @character.body.velocity.y = 450 if @character.body.velocity.y == 0
    @character.isCharacterOnGround = false

    @game.physics.arcade.collide @character, @normalPads, @steadyBoy
    @game.physics.arcade.collide @character, @speedPads, @speedUp
    @game.physics.arcade.collide @character, @slowPads, @slowDown

    console.log @character.isCharacterOnGround

    if @cursors.right.isDown and @character.isCharacterOnGround
      @character.jump()

    if @cursors.left.isDown and @character.isCharacterOnGround
      @character.switchGravity()

  render: ->
    @game.debug.text(@character.body.velocity, 32, 32)

  test: ->
    console.log 'test1'

  speedUp: (character) ->
    character.isCharacterOnGround = true
    character.body.velocity.y += 30 if character.body.velocity.y <= 1000

  slowDown: (character) ->
    character.isCharacterOnGround = true
    character.body.velocity.y -= 20 if character.body.velocity.y >= 300

  steadyBoy: (character) ->
    character.isCharacterOnGround = true
    character.body.velocity.y += 10 if character.body.velocity.y <= 650
    character.body.velocity.y -= 10 if character.body.velocity.y >= 650

  createCharacter: ->
    @character = @game.add.sprite 220, 0, 'pixel'
    
    @characters.add @character

    @game.physics.enable @character, Phaser.Physics.ARCADE

    @character.body.bounce.x = 0
    @character.body.collideWorldBounds = true
    @character.body.setSize 50, 50
    @character.isSwitchingGravity = false
    @character.body.gravity.x = 4000
    @character.body.gravity.y = 0
    @character.anchor.setTo 0.5, 0.5
    @character.tint = 0xFF6BD1
    @character.isCharacterOnGround = false
    @character.isCharacterGravityInverted = @isCharacterGravityInverted
    @character.switchGravity = @switchGravity
    @character.jump = @jump

    @game.camera.follow @character, Phaser.Camera.FOLLOW_PLATFORMER

  createWorld: ->
    @walls = @game.add.group()
    @speedPads = @game.add.group()
    @slowPads = @game.add.group()
    @normalPads = @game.add.group()

    @speedPads.enableBody = true
    @slowPads.enableBody = true
    @normalPads.enableBody = true

    @walls.add @speedPads
    @walls.add @slowPads
    @walls.add @normalPads

    numberOfPads = 20000 / 200

    @addPads(numberOfPads)

    @normalPads.setAll('body.immovable', true)
    @speedPads.setAll('body.immovable', true)
    @slowPads.setAll('body.immovable', true)

    @normalPads.setAll('tint', 0xB0FF87)
    @speedPads.setAll('tint', 0x9BD3FF)
    @slowPads.setAll('tint', 0xFFBC8E)

  isCharacterOnGround: =>
    @character.body.onWall()

  isCharacterGravityInverted: =>
    @character.body.gravity.x < 0

  switchGravity: =>
    @character.body.gravity.x = -@character.body.gravity.x

  jump: =>
    if @isCharacterGravityInverted()
      @character.body.velocity.x = 1000

    else
      @character.body.velocity.x = -1000

  setUpGame: ->
    @game.world.setBounds 0, 0, 540, 20000
    @game.time.desiredFps = 60
    @game.physics.startSystem Phaser.Physics.ARCADE
    @cursors = @game.input.keyboard.createCursorKeys()
    @characters = @game.add.group()

  addPads: (numberOfPads) ->
    addedLeftPads = 0
    addedRightPads = 0
    padTypes = [@normalPads, @speedPads, @slowPads]

    until addedLeftPads == numberOfPads
      @game.add.sprite(0, (addedLeftPads * 200), 'wall', 0, @game.rnd.pick(padTypes))
      addedLeftPads += 1
    until addedRightPads == numberOfPads
      @game.add.sprite(490, (addedRightPads * 200), 'wall', 0, @game.rnd.pick(padTypes))
      addedRightPads += 1

module.exports = State
