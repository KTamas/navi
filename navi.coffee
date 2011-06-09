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
  cmd_regexp = "^#{@nick.toLowerCase()}(\:|\,) ?(.+?)( .*?)?$"
  # undorito undorito js regexpkezeles. undorito.
  has_command = message.toLowerCase().match new RegExp(cmd_regexp, 'g')
  if has_command 
    arr = new RegExp(cmd_regexp, 'g').exec(message.toLowerCase())
    command = arr[2]
    if static[command]
      navi.say to, static[command]
    else
      try
        @emit command, from, to, message, arr[3].trim()
      catch error
        @emit command, from, to, message

navi.on 'weather', (from, to, message, location=1) ->
  jsdom = require 'jsdom'

  jsdom.env({
    html: 'http://koponyeg.hu/idojaras_rss.php?regios=' + location
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
