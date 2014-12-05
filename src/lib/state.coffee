config = require './config.coffee'

class State
  preload: ->
    @game.stage = $.extend @game.stage, config.stage
    
    @game.load.image imageName, path for imageName, path of config.images

  create: ->
    @setUpGame()

    @addCharacter()

  update: ->
    @character.body.velocity.y = 0

    if @cursors.up.isDown
      @character.moveUp()

    if @cursors.down.isDown
      @character.moveDown()

    if @cursors.right.isDown and @character.isCharacterOnGround()
      @character.jump()

    if @cursors.left.isDown and @character.isCharacterOnGround()
      @character.switchGravity()

  addCharacter: ->
    @character = @game.add.sprite 220, 0, 'pixel'
    
    @characters.add @character

    @game.physics.enable @character, Phaser.Physics.ARCADE

    @character.body.bounce.x = 0
    @character.body.collideWorldBounds = true
    @character.body.setSize 50, 50
    @character.isSwitchingGravity = false
    @character.body.gravity.x = -4000
    @character.anchor.setTo 0.5, 0.5
    @character.tint = 0xFF20A0
    @character.isCharacterOnGround = @isCharacterOnGround
    @character.isCharacterGravityInverted = @isCharacterGravityInverted
    @character.switchGravity = @switchGravity
    @character.moveUp = @moveUp
    @character.moveDown = @moveDown
    @character.jump = @jump

  isCharacterOnGround: =>
    @character.body.onWall()

  isCharacterGravityInverted: =>
    @character.body.gravity.x > 0

  switchGravity: =>
    @character.body.gravity.x = -@character.body.gravity.x

  moveUp: =>
    @character.body.velocity.y = -500

  moveDown: =>
    @character.body.velocity.y = 500

  jump: =>
    if @isCharacterGravityInverted()
      @character.body.velocity.x = -1000

    else
      @character.body.velocity.x = 1000

  setUpGame: ->
    @game.time.desiredFps = 60
    @game.physics.startSystem Phaser.Physics.ARCADE
    @cursors = @game.input.keyboard.createCursorKeys()
    @characters = @game.add.group()

module.exports = State
