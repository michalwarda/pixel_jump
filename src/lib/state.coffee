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
    @character.isCharacterOnGround = false

    @game.physics.arcade.collide @character, @walls, @setCharacterGroundTouching

    @character.body.velocity.y = -500

    if @cursors.right.isDown and @character.isCharacterOnGround
      @character.jump()

    if @cursors.left.isDown and @character.isCharacterOnGround
      @character.switchGravity()

  setCharacterGroundTouching: (character) ->
    character.isCharacterOnGround = true

  createCharacter: ->
    @character = @game.add.sprite 220, 4975, 'pixel'
    
    @characters.add @character

    @game.physics.enable @character, Phaser.Physics.ARCADE

    @character.body.bounce.x = 0
    @character.body.collideWorldBounds = true
    @character.body.setSize 50, 50
    @character.isSwitchingGravity = false
    @character.body.gravity.x = -4000
    @character.anchor.setTo 0.5, 0.5
    @character.tint = 0xFF20A0
    @character.isCharacterOnGround = false
    @character.isCharacterGravityInverted = @isCharacterGravityInverted
    @character.switchGravity = @switchGravity
    @character.jump = @jump

    @game.camera.follow @character, Phaser.Camera.FOLLOW_LOCKON

  createWorld: ->
    @walls = @game.add.group()

    @walls.enableBody = true

    leftWall = @game.add.sprite 0, 0, 'pixel', 0, @walls
    rightWall = @game.add.sprite 490, 0, 'pixel', 0, @walls
    leftWall.scale.setTo 1, 100
    rightWall.scale.setTo 1, 100

    @walls.setAll('body.immovable', true)

  isCharacterOnGround: =>
    @character.body.onWall()

  isCharacterGravityInverted: =>
    @character.body.gravity.x > 0

  switchGravity: =>
    @character.body.gravity.x = -@character.body.gravity.x

  jump: =>
    if @isCharacterGravityInverted()
      @character.body.velocity.x = -1000

    else
      @character.body.velocity.x = 1000

  setUpGame: ->
    @game.world.setBounds 0, 0, 540, 5000
    @game.time.desiredFps = 60
    @game.physics.startSystem Phaser.Physics.ARCADE
    @cursors = @game.input.keyboard.createCursorKeys()
    @characters = @game.add.group()

module.exports = State
