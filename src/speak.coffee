# Description:
#   Let's hear Hubot speak!
#
# Commands:
#   hubot speak - It speaks!
#   hubot log N - Log N units of milk
#   hubot daily log - Find out how many units of milk have been logged today
#   hubot clear log - Clear the daily log
#   hubot start timer - Start the timer
#   hubot show timer - Show the timers progress
#   hubot stop timer - Stop the timer
#   hubot biscuit - have a biscuit!
#
# Author:
#   wylie

noises = ['Woof', 'Bark', 'Grrr', 'Ruff']
phrases = [
  'Wake up and take me outside!',
  'Are you ever going to feed me?!',
  'Why do I get little food? I\'m still hungry.',
  'I won\'t tell anyone what you are doing, but I would tweet about it if I had thumbs.',
  'Throwing the ball isn\'t that difficult when I\'m the one chasing it.',
  'Are you really gonna drink wine alone on a Friday night? I\'m snapchatting this to all my friends. No judgement though.',
  'Yes I shed a lot, but I want to be a lap dog. Don\'t you have dreams?',
  'Why can\'t I pee in the house if you can?',
  'Can you turn on Animal Planet? The Puppy Bowl is this Sunday!',
  'I have crush on the dog down the street.',
  'I don\'t like the thunder! Stop laughing at me!',
  'Why do you always step on me?',
  'I\'m very selective. You can\'t just bring a random dog here and expect me to like them.',
  'Offering to give me a treat, then forgetting you made that promise sucks. Are you Satan?',
  'How would you feel if I put you on a leash?',
  'Oh that boy on the park is on a leash. I feel for you kid. Respect.',
  'Why the hell is there a tree in the house if I can\'t pee on it?',
  'How about you go outside in the rain?',
  'I smell bacon! I want bacon!!',
  'While you were on your cell phone not watching me, I got lost and it\'s getting dark and I\'m scared.',
  'Why must you talk to me like I\'m an infant? I\'m 91 years old in dog years.',
  'I\'m about to get car-sick and you don\'t seem to care.',
  'Okay, I just threw up. Don\'t yell at me - I warned you.',
  'I hate getting wet. Why do I need a bath?',
  'You tricked me! You told me we were going for a ride and then you took me to the vet.',
  'I hate this cone.',
  'How would you feel if I put a cone on you and watched you walk into every wall?',
  'Why are we watching this stupid show? And why are you crying?',
  'Why must you insist I wear this sweater? I look like an idiot.',
  'You brought me to a house and are leaving me. Why?!',
  'Oh you\'re going on vacation? I could use a vacation. Take me!',
  'I\'m sorry I pooped in the house, but where the hell have you been and why are you wearing the same clothes from last night?',
  'Can you please scratch my butt? I wouldn\'t ask you to do it if I could do it myself.',
  'You have an entire cupboard of food. Why do I only get fed twice?',
  'I\'m thirsty and my bowl is downstairs. Help! I\'m gonna die!',
  'No, I don\'t want to wake up this early. Leave me be.',
  'I just had a nightmare that the mailman was coming for me.',
  'Speaking of the mailman, I hate him.',
  'You are annoying me so much right now. I want to bite you.',
  'There\'s a stranger in the house. Alert! Alert!',
  'This snow is getting stuck to my fur and I\'m freezing my butt off.',
  'Where do you go all day?',
  'I don\'t trust cats. I never know where they are.',
  'You\'re going to miss me when I die.',
  'I\'ll haunt you if you replace me'
]

module.exports = (robot) ->

  # RESOND

  # speak
  robot.respond /speak/i, (res) ->
    res.send res.random noises

  babyName = 'Oslo'
  units = 'ounces'
  room = '#oslo'
  # add to log
  robot.respond /log (.*)/i, (res) ->
    newMilk = res.match[1]
    oldMilk = robot.brain.get('totalMilk') * 1 or 0
    robot.brain.set 'totalMilk', parseFloat(oldMilk)+parseFloat(newMilk)
    res.reply "#{babyName} just had #{newMilk} #{units} of milk! :baby_bottle:"

  # show log
  robot.respond /daily log/i, (res) ->
    totalMilk = robot.brain.get('totalMilk') * 1 or 0
    if totalMilk < 1
      res.reply "#{babyName} hasn't had any milk yet today :cry:"
    else
      res.reply "#{babyName} has had a total of *#{totalMilk}* #{units} of milk today! :baby_bottle:"

  # clear log
  robot.respond /clear log/i, (res) ->
    robot.brain.set 'totalMilk', 0
    res.reply "The daily log has been cleared :+1:"

  # stop the timer
  robot.respond /start timer/i, (res) ->
    oldTime = (new Date)
    robot.brain.set 'oldTime', oldTime
    res.reply "The timer has begun! :timer_clock:"

  # display the timer
  robot.respond /show timer/i, (res) ->
    oldTime = robot.brain.get('oldTime')
    newTime = (new Date)
    time = newTime - oldTime
    hour = new Date(time).getHours()
    minute = new Date(time).getMinutes()
    second = new Date(time).getSeconds()
    final = ''
    if hour > 0
      final += hour + ' hour, '
    if hour > 0 or minute > 0
      final += minute + ' minutes and '
    if second >= 0
      if second > 1
        final += second + ' seconds'
      else
        final += second + ' second'
    res.reply "The timer has been going for: *#{final}*! :timer_clock:"

  # stop the timer
  robot.respond /stop timer/i, (res) ->
    oldTime = robot.brain.get('oldTime')
    newTime = (new Date)
    time = newTime - oldTime
    hour = new Date(time).getHours()
    minute = new Date(time).getMinutes()
    second = new Date(time).getSeconds()
    final = ''
    if hour > 0
      final += hour + ' hour, '
    if hour > 0 or minute > 0
      final += minute + ' minutes and '
    if second >= 0
      if second > 1
        final += second + ' seconds'
      else
        final += second + ' second'
    res.reply "Total time: *#{final}*! :timer_clock: :+1:"
    robot.brain.set 'oldTime', 0

  # have a biscuit
  robot.respond /have a biscuit/i, (res) ->
    biscuitsHad = robot.brain.get('totalBiscuits') * 1 or 0
    if biscuitsHad > 4
      res.reply "I'm too full..."
    else
      res.reply 'Sure!'

    robot.brain.set 'totalBiscuits', biscuitsHad+1
  robot.respond /sleep it off/i, (res) ->
    robot.brain.set 'totalBiscuits', 0
    msg.reply 'zzzzz'

  # LISTEN

  # bone?!
  robot.hear /bone/i, (res) ->
    res.send "I love bones!"

  # brother
  brother = ['https://whatistheexcel.com/wooobooru/_images/75c9e97e34573f1f23518e36e40050fe/212%20-%20brother%20hulk_hogan%20macro%20mean_gene_okerlund%20microphone%20sunglasses%20wwe.jpg','http://t.qkme.me/3r68xv.jpg','http://cdn.meme.am/instances/53417899.jpg','http://cdn.meme.am/instances/61855016.jpg','http://i1168.photobucket.com/albums/r486/00GreenRanger/hulkhogan_zpsb7aa8412.jpg','http://www.quickmeme.com/img/be/be450207f2ec5e423298257ca2415fab23fbf53dfb6765070c3d333a42e0a5c5.jpg','http://www.quickmeme.com/img/5f/5f3a5911b741b287a80e45e1d3e7e5af00ebffa0067f3ef6a79aa22afa73caec.jpg']
  robot.hear /brother/i, (res) ->
    res.send res.random brother

  # cats
  cats = ['http://i.ytimg.com/vi/tntOCGkgt98/maxresdefault.jpg','http://www.washingtonpost.com/news/morning-mix/wp-content/uploads/sites/21/2014/09/Grumpy_Cat_Endorsement-017d7-ULFU.jpg','http://www.thaqafnafsak.com/wp-content/uploads/2014/05/Animals___Cats_Red_Cat_and_tongue_044659_29.jpg','http://static.giantbomb.com/uploads/original/3/34821/2577499-cat.jpg','http://catswallpaperhd.us/wp-content/uploads/2014/06/male-cats-mating-gsfgeo7g.jpg','https://assets.rbl.ms/435736/640x364.jpg','http://content4.video.news.com.au/NDM_-_news.com.au/150/881/parachuting_cats_648x365_2304624662-hero.jpg','http://www.pets4homes.co.uk/images/articles/1092/large/7-of-the-most-affectionate-cat-breeds-522ed069473c9.jpg','http://i.dailymail.co.uk/i/pix/2014/09/18/1411041513567_wps_11_dmvidpics_2014_09_18_at_1.jpg','http://www.amplifyingglass.com/wp-content/uploads/2014/06/sitting-cat5.jpg']
  robot.hear /cat/i, (res) ->
    res.send res.random cats

  # walks?!
  robot.hear /walk/i, (res) ->
    res.send "Did somebody say walk?!"

  # beer
  beers = [':beers: are on @gjjones: tonight!',':beers: are on @mpivnick: tonight!',':beers: are on @bobandy: tonight!',':beers: are on @esimons: tonight!',':beers: are on @wylie: tonight!',':beers: are on @slackbot: tonight!','did somebody say beer? Who wants some?','no thanks, I\'m already drunk...','http://www.leeabbamonte.com/wp-content/uploads/2015/03/Beer-1.jpg']
  robot.hear /beer/i, (res) ->
    res.send res.random beers

  # NOTICE

  # randomly talk throughout the day
  setInterval((->
    num = Math.floor(Math.random() * phrases.length)
    robot.send room: 'general', phrases[num];
  ), Math.ceil(Math.random() * 100000000))

  # ask about the channel topic change
  robot.topic (res) ->
    res.send "Good job changing the channel topic to #{res.message.text}?"

  # new user enter room welcome
  enterReplies = ["Hi", "Welcome", "Hello friend", "Boy, am I glad you\re here", "We're happy to have you"]
  robot.enter (res) ->
    randomReply = res.random enterReplies
    res.send "#{randomReply}, I'm Olive and I'm here to help you out with things. You can type `Olive help` to see all the things I can lend a hand with."
