# Description:
#   Let's hear Hubot speak!
#
# Commands:
#   hubot speak - Hubot speaks!
#
# Author:
#   wylie

speaks = ['Woof', 'Bark', 'Grrr']
module.exports = (robot) ->
  robot.respond /speak/i, (res) ->
    res.send res.random speaks
