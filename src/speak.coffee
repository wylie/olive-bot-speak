# Description:
#   Let's hear Hubot speak!
#
# Commands:
#   hubot speak - It speaks!
#
# Author:
#   wylie

noises = ['Woof', 'Bark', 'Grrr', 'Ruff']
phrases = [
  'Does anybody want to play?',
  'I think I hear somebody at the door… grrr',
  'I\'d really like to get up on the couch.',
  'Cats sure are tasty'
]

module.exports = (robot) ->
  robot.respond /speak/i, (res) ->
    res.send res.random noises

  robot.hear /you/i, (res) ->
    setTimeout () ->
      res.send res.random (phrases || noises)
    , Math.ceil(Math.random() * 1000000)
