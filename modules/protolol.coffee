mongoose = require 'mongoose'
jsdom = require 'jsdom'

mongoose.connect('mongodb://localhost/navi_protolol')

ProtololSchema = new mongoose.Schema
  body: String

mongoose.model('Protolol', ProtololSchema)
myProtolol = mongoose.model('Protolol')

module.exports.handle = 'protolol'
module.exports.handler = (navi, from, to, message, params) ->
  scrape = ->
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
  if params[0] == 'scrape'
    scrape() for i in [1..12]
  else 
    mongoose.model('Protolol').find (err, items) ->
      random = Math.floor(Math.random()*items.length)
      navi.say to, items[random].body
