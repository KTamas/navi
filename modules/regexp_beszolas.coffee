module.exports.handle = 'regexp_html'
module.exports.handler = (navi, from, to, message, params) ->
  navi.say to, "You can't parse html with regexp: http://stackoverflow.com/questions/1732348/regex-match-open-tags-except-xhtml-self-contained-tags/1732454#1732454"
