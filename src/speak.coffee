# Description:
#   Let's hear Hubot speak!
#
# Commands:
#   hubot speak - It speaks!
#
# Author:
#   wylie

noises = ['Woof', 'Bark', 'Grrr', 'Ruff']
# noises = ['Help', 'Me', 'Please', 'Sir']
phrases = [
  'Does anybody want to play?',
  'I think I hear somebody at the door… grrr',
  'I\'d really like to get up on the couch.',
  'Cats sure are tasty'
]

module.exports = (robot) ->
  # speak
  robot.respond /speak/i, (res) ->
    res.send res.random noises

  # randomly talk throughout the day
  setTimeout () ->
    robot.send room: 'general', res.random phrases
  , Math.ceil(Math.random() * 1000000)

  # ask about the channel topic change
  robot.topic (res) ->
    res.send "Are you sure you want change the channel topic to #{res.message.text}?"

  # biscuit?!
  robot.respond /would you like a biscuit/i, (res) ->
    res.send "yes, please!"

  # walks?!
  robot.hear /walk/i, (res) ->
    res.send "Did somebody say walk?!"

  # new user enter room welcome
  enterReplies = ["Hi", "Welcome", "Hello friend", "Boy, am I glad you\re here", "We're happy to have you"]
  robot.enter (res) ->
    randomReply = res.random enterReplies
    res.send "#{randomReply}, I'm Olive and I'm here to help you out with things. You can type `Olive help` to see all the things I can lend a hand with."
