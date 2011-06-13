module.exports.handle = 'weather'
module.exports.handler = (navi, from, to, message, location=1) ->
  jsdom = require 'jsdom'
  jsdom.env({
    html: 'http://koponyeg.hu/idojaras_rss.php?regios=' + location
    scripts: [ 'http://code.jquery.com/jquery-1.6.1.min.js' ]
    done: (err, window) ->
      navi.say to, window.$("koponyeg\\:jelenido").attr('homerseklet') + ' fok van.'
  })
