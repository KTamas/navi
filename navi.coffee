irc = require 'irc'
fs = require 'fs'

navi = new irc.Client(
  process.argv[2], #server
  process.argv[3], #nick
  debug: true, #options
  channels: process.argv[4].split(',') #channels
)

navi.hey = navi.addListener
navi.hey 'listen', (from, to, message) ->
  navi.say to, "Hey, listen!"

static = 
  'dalek': "EXTERMINATE"
  'timelord': "Bow ties are cool."
  'about': "Hey, listen! You can find me at https://github.com/ktamas/navi"
  'jwz': "Now you have two problems."

navi.prefix = process.argv[5] ? "!"

navi.on 'message', (from, to, message) ->
  command_regexp = new RegExp("^(#{@nick}|#{@prefix}).*?$", 'g')
  has_command = message.toLowerCase().match command_regexp
  if has_command 
    [command, params...] = message.replace(@prefix, '').replace(@nick, '').replace(/(\,|\:)/, '').trim().split(' ')
    if static[command]
      navi.say to, static[command]
    else
      @emit command, navi, from, to, message, params

fs.readdir './modules', (err, files) ->
  if err
    navi.say "Error: #{err}"
  else
    for file in files
      m = require './modules/' + file
      navi.on m.handle, m.handler

process.on "SIGINT", ->
  navi.disconnect "Bye!"
  process.exit()
