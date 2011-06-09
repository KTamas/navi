irc = require 'irc'
http = require 'http'

navi = new irc.Client 'hub.irc.hu', 'Navi', debug:true, channels: ['#hspbp']
navi.hey = navi.addListener

navi.hey 'listen', (from, to, message) ->
  navi.say to, "Hey, listen!"

static = 
  'dalek': "EXTERMINATE"
  'timelord': "Bow ties are cool."
  'about': "Hey, listen! You can find me at https://github.com/ktamas/navi"

navi.on 'message', (from, to, message) ->
  prefix_regexp = "^#{@nick.toLowerCase()}(\:|\,) ?(.+?)$"
  matches = message.toLowerCase().match new RegExp(prefix_regexp, 'g')
  if matches 
    command = new RegExp(prefix_regexp, 'g').exec(message.toLowerCase())[2]
    if static[command]
      navi.say to, static[command]
    else
      @emit command, from, to, message

navi.on 'weather', (from, to, message) ->
  jsdom = require 'jsdom'

  jsdom.env({
    html: 'http://koponyeg.hu/idojaras_rss.php?regios=1'
    scripts: [ 'http://code.jquery.com/jquery-1.5.min.js' ]
    done: (err, window) ->
      navi.say to, window.$("koponyeg\\:jelenido").attr('homerseklet') + ' fok van.'
  })

#navi.on "message", (nick, to, message) ->
  #try
    #[_, cmd] = message.match "^js:(.*)"
    #result = eval cmd
    #if result
      #@say to, result
    #else
      #@say to, "YES MASTER I HAVE DONE IT"
  #catch e
    #@say to, "gebasz: #{e}"
  #try
    #[_, cmd] = message.match "^coffeescript:(.*)"
    #result = CoffeeScript.eval cmd, bare:true
    #if result
      #@say to, result
    #else
      #@say to, "YES MASTER I HAVE DONE IT"
  #catch e
    #@say to, "gebasz: #{e}"

process.on "SIGINT", ->
  navi.disconnect "Bye!"
