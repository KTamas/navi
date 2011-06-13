irc = require 'irc'
jsdom = require 'jsdom'
http = require 'http'
mongoose = require 'mongoose'

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


navi.on 'message', (from, to, message) ->
  prefix = process.argv[5] ? @nick
  has_command = message.toLowerCase().match new RegExp("^#{prefix}.*?$", 'g')
  if has_command 
    [command, params...] = message.replace(prefix, '').replace(/(\,|\:)/, '').trim().split(' ')
    console.log "command: #{command}"
    console.log "params: #{params}"
    if static[command]
      navi.say to, static[command]
    else
      @emit command, from, to, message, params

navi.on 'weather', (from, to, message, location=1) ->
  jsdom.env({
    html: 'http://koponyeg.hu/idojaras_rss.php?regios=' + location
    scripts: [ 'http://code.jquery.com/jquery-1.6.1.min.js' ]
    done: (err, window) ->
      navi.say to, window.$("koponyeg\\:jelenido").attr('homerseklet') + ' fok van.'
  })

navi.on 'protoscrape', (from, to, message) ->
  scrape = () ->
    jsdom.env({
      html: "http://protolol.com/page/#{i}"
      scripts: [ 'http://code.jquery.com/jquery-1.6.1.min.js' ]
      done: (err, window) ->
        $ = window.$
        items = $("#posts").clone()
        $('div', items).remove()
        $('li', items).each (c, item) ->
          quote = new myProtolol()
          quote.body = $(item).html().trim().replace("&ldquo;", "").replace("&rdquo;", "")
          quote.save (err) ->
            if err
              console.log "oopsie"
    }) 
  scrape() for i in [1..11]
  
mongoose.connect('mongodb://localhost/navi_protolol')

ProtololSchema = new mongoose.Schema
  body: String

mongoose.model('Protolol', ProtololSchema)
myProtolol = mongoose.model('Protolol')

navi.on 'protolol', (from, to, message) ->
  mongoose.model('Protolol').find (err, items) ->
    random = Math.floor(Math.random()*items.length)
    navi.say to, items[random].body
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
  process.exit()
