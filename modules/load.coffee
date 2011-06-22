module.exports.handle = 'load'
module.exports.handler = (navi, from, to, message, params) ->
  try
    m = require '../modules/' + params[0]
    navi.on m.handle, m.handler
    navi.say "successfully loaded #{params[0]}"
  catch error
    navi.say "couldn't load #{params[0]} because: #{error}"

