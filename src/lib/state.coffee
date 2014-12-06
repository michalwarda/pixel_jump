config = require './config.coffee'

class State
  preload: ->
    @game.stage = $.extend @game.stage, config.stage
    
    @game.load.image imageName, path for imageName, path of config.images

  create: ->
    @setUpGame()

    @createCharacter()
    @createCharacter2()

    @createWorld()

  update: ->
    @character.body.velocity.y = 450 if @character.body.velocity.y == 0
    @character.isCharacterOnGround = false

    @character2.body.velocity.y = 450 if @character2.body.velocity.y == 0
    @character2.isCharacterOnGround = false

    @game.physics.arcade.collide @characters, @normalPads, @steadyBoy
    @game.physics.arcade.collide @characters, @speedPads, @speedUp
    @game.physics.arcade.collide @characters, @slowPads, @slowDown

    if @character.body.position.y > @character2.body.position.y
      @game.camera.follow @character, Phaser.Camera.FOLLOW_PLATFORMER
    else
      @game.camera.follow @character2, Phaser.Camera.FOLLOW_PLATFORMER

    if @cursors.jump.isDown and @character.isCharacterOnGround
      @jump(@character)

    if @cursors.switch.isDown and @character.isCharacterOnGround
      @switchGravity(@character)

    if @cursors2.jump.isDown and @character2.isCharacterOnGround
      @jump(@character2)

    if @cursors2.switch.isDown and @character2.isCharacterOnGround
      @switchGravity(@character2)

    if @game.camera.view.y > @character.body.position.y + 200 and !(@character2.body.position.y == 0)
      @resetGame()
      @increaseScore(@character2)
      console.log 'Score:'
      console.log "Red: #{@character2.score}"
      console.log "Pink: #{@character.score}"

    if @game.camera.view.y > @character2.body.position.y + 200 and !(@character.body.position.y == 0)
      @resetGame()
      @increaseScore(@character)
      console.log 'Score:'
      console.log "Red: #{@character2.score}"
      console.log "Pink: #{@character.score}"

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
    @character.score = 0

  createCharacter2: ->
    @character2 = @game.add.sprite 220, 0, 'pixel'
    
    @characters.add @character2

    @game.physics.enable @character2, Phaser.Physics.ARCADE

    @character2.body.bounce.x = 0
    @character2.body.collideWorldBounds = true
    @character2.body.setSize 50, 50
    @character2.isSwitchingGravity = false
    @character2.body.gravity.x = -4000
    @character2.body.gravity.y = 0
    @character2.anchor.setTo 0.5, 0.5
    @character2.tint = 0xFF6B6B
    @character2.isCharacterOnGround = false
    @character2.score = 0

  createWorld: ->
    @walls = @game.add.group()

    @numberOfPads = 20000 / 200

    @setUpPads(@numberOfPads)

  isCharacterGravityInverted: (character) =>
    character.body.gravity.x < 0

  switchGravity: (character) =>
    character.body.gravity.x = -character.body.gravity.x

  jump: (character) =>
    if @isCharacterGravityInverted(character)
      character.body.velocity.x = 1000

    else
      character.body.velocity.x = -1000

  setUpGame: ->
    @game.world.setBounds 0, 0, 540, 20000
    @game.time.desiredFps = 60
    @game.physics.startSystem Phaser.Physics.ARCADE
    @cursors = {
      jump: @game.input.keyboard.addKey(Phaser.Keyboard.RIGHT)
      switch: @game.input.keyboard.addKey(Phaser.Keyboard.LEFT)
    }
    @cursors2 = {
      jump: @game.input.keyboard.addKey(Phaser.Keyboard.S)
      switch: @game.input.keyboard.addKey(Phaser.Keyboard.A)
    }
    @characters = @game.add.group()

  setUpPads: (numberOfPads) ->
    @speedPads.destroy() if @speedPads
    @slowPads.destroy() if @slowPads
    @normalPads.destroy() if @normalPads

    @speedPads = @game.add.group()
    @slowPads = @game.add.group()
    @normalPads = @game.add.group()

    @speedPads.enableBody = true
    @slowPads.enableBody = true
    @normalPads.enableBody = true

    @walls.add @speedPads
    @walls.add @slowPads
    @walls.add @normalPads

    @addPads(numberOfPads)

    @normalPads.setAll('body.immovable', true)
    @speedPads.setAll('body.immovable', true)
    @slowPads.setAll('body.immovable', true)

    @normalPads.setAll('tint', 0xB0FF87)
    @speedPads.setAll('tint', 0x9BD3FF)
    @slowPads.setAll('tint', 0xFFBC8E)

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

  resetGame: ->
    @resetCharacters()
    @setUpPads(@numberOfPads)

  resetCharacters: ->
    @character.body.position.x = 220
    @character.body.position.y = 0

    @character.body.gravity.x = 4000
    @character.body.velocity.y = 0

    @character2.body.position.x = 220
    @character2.body.position.y = 0
    
    @character2.body.gravity.x = -4000
    @character2.body.velocity.y = 0

  increaseScore: (character) ->
    character.score += 1
    

module.exports = State
