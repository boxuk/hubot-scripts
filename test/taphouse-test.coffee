Helper = require 'hubot-test-helper'
helper = new Helper('../src/taphouse.js')
chai = require 'chai'

expect = chai.expect

describe 'taphouse', ->
  room = null

  beforeEach ->
    room = helper.createRoom()

  afterEach ->
    room.destroy()

  it 'should be able to respond with a list of beers', (done) ->
    room.user.say 'tom', '@hubot what beers are available'

    checkForBeers = () ->
      response = room.messages[1];

      expect(response).not.to.be.undefined;

      author = response[0]
      messages = response[1].split('\n')

      expect(author).to.equal('hubot')

      expect(messages[0]).to.equal('Hey there!')
      expect(messages[1]).to.equal('The following drinks are available at Tiny Rebel (Cardiff):')

      # The rest of the messages should be beer information
      expect(messages.length).to.be.greaterThan(2)

      done();

    # It takes some time to fetch available drinks.
    # This usually takes about 0.5s, but to be on the safer side wait 1.5s before making any assertions
    setTimeout(checkForBeers, 1500)

  it 'should be able to respond with the strongest available drink', (done) ->
    room.user.say 'tom', '@hubot get me drunk'

    checkForBeers = () ->
      response = room.messages[1];

      expect(response).not.to.be.undefined;

      author = response[0]
      messages = response[1].split('\n')

      expect(author).to.equal('hubot')

      expect(messages[0]).to.equal('Hey there!')
      expect(messages[1]).to.equal('The strongest drink on tap at Tiny Rebel (Cardiff) is:')

      # The rest of the messages should be beer information
      expect(messages.length).to.be.greaterThan(2)

      done();

    # It takes some time to fetch available drinks.
    # This usually takes about 0.5s, but to be on the safer side wait 1.5s before making any assertions
    setTimeout(checkForBeers, 1500)
