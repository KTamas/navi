module.exports.handle = 'prefix'
module.exports.handler = (navi, from, to, message, params) ->
  if params.length == 0
    navi.say to, "My prefix is either my nick or '#{@prefix}'"
  else
    @prefix = params[0]
    navi.say to, "My new prefix is either my nick or '#{@prefix}'"
