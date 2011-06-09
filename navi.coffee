irc = require 'irc'

navi = new irc.Client 'hub.irc.hu', 'Navi', debug:true, channels: ['#nonesuch']
navi.hey = navi.addListener

navi.hey 'message', (from, to, message) ->
  prefix_regexp = "^#{@nick.toLowerCase()}(\:|\,) ?(.+?)$"
  matches = message.toLowerCase().match new RegExp(prefix_regexp, 'g')
  if matches 
    @emit new RegExp(prefix_regexp, 'g').exec(message.toLowerCase())[2], from, to, message

navi.hey 'listen', (from, to, message) ->
  navi.say to, "Hey, listen!"

navi.hey 'dalek', (from, to, message) ->
  navi.say to, "EXTERMINATE"

process.on "SIGINT", ->
  navi.disconnect "Bye!"
