irc = require 'irc'

navi = new irc.Client 'hub.irc.hu', 'Navi', debug:true, channels: ['#nonesuch']

Array::random = ->
  @[Math.floor Math.random()*@length]

navi.hey = navi.addListener

navi.addListener 'message', (from, to, message) ->
  if message.toUpperCase().match '^' + @nick.toUpperCase() + '(\:|\,)'
    @emit 'listen', from, to, message

navi.hey 'listen', (from, to, message) ->
  navi.say to, "Hey, listen!"  

process.on "SIGINT", ->
  navi.disconnect "Goodbye cruel world!"