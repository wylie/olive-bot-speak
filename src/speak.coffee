# Description:
#   Let's hear Hubot speak!
#
# Commands:
#   hubot speak - It speaks!
#
# Author:
#   wylie

speaks = ['Woof', 'Bark', 'Grrr']
module.exports = (robot) ->
  robot.respond /speak/i, (res) ->
    res.send res.random speaks

  robot.hear /i/i, (res) ->
    setTimeout () ->
      res.send res.random speaks
    , 2 * 60 * 1000
