# Description:
#   Let's hear Hubot speak!
#
# Commands:
#   hubot clear log - Clear the daily log
#   hubot daily log - Find out how many units of milk have been logged today
#   hubot eightball - Get a Magic Eight Ball answer
#   hubot flip a coin - Flip a coin
#   hubot log N - Log N units of milk
#   hubot show timer - Show the timers progress
#   hubot roll the die - Roll the dice
#   hubot soda - have a soda!
#   hubot speak - It speaks!
#   hubot start timer - Start the timer
#   hubot stop timer - Stop the timer
#
# Author:
#   wylie

phrases = [
  'LIVIN\' A LIE!!',
  'TIMMY!!',
  'TIMMEH!!'
]
thecoin = ['heads', 'tails']
thedie = [1, 2, 3, 4, 5, 6]
ball = [
  "It is certain",
  "It is decidedly so",
  "Without a doubt",
  "Yes – definitely",
  "You may rely on it",
  "As I see it, yes",
  "Most likely",
  "Outlook good",
  "Signs point to yes",
  "Yes",
  "Reply hazy, try again",
  "Ask again later",
  "Better not tell you now",
  "Cannot predict now",
  "Concentrate and ask again",
  "Don't count on it",
  "My reply is no",
  "My sources say no",
  "Outlook not so good",
  "Very doubtful",
]

module.exports = (robot) ->

  # RESPOND

  babyName = 'Oslo'
  units = 'ounces'
  # add to log
  robot.respond /log ([0-9]*)/i, (res) ->
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

  # have a soda
  robot.respond /have a soda/i, (res) ->
    sodasHad = robot.brain.get('totalSodas') * 1 or 0
    if sodasHad > 4
      res.reply 'I\'m too full...'
    else
      res.reply 'Sure… TIMMY!!'

    robot.brain.set 'totalSodas', sodaHad+1
    
  robot.respond /sleep it off/i, (res) ->
    robot.brain.set 'totalSodas', 0
    res.reply 'zzzzz'
    
  # user
  robot.respond /user/i, (res) ->
    res.reply res.message.user.name

  # users
  robot.respond /all users/i, (res) ->
    res.reply res.message.user

  # room
  robot.respond /room/i, (res) ->
    room = res.message.room
    res.send "This room is: ##{room}"
    
  # speak
  robot.respond /speak/i, (res) ->
    res.send res.random phrases

  # choose between
  robot.respond /choose between ([^"]+)/i, (msg) ->
      options = msg.match[1].split(' ')
      msg.reply("Definitely \"#{msg.random options}\".")

  # coin
  robot.respond /(throw|flip|toss) a coin/i, (res) ->
    res.reply res.random thecoin

  # dice
  robot.respond /(throw|roll|toss) the die/i, (res) ->
    res.reply res.random thedie

  robot.respond /(eightball|8ball)(.*)/i, (res) ->
    res.reply res.random ball

  # LISTEN

  # users
  robot.hear /(hi\b)/gi, (res) ->
    sender = res.message.user.name.toLowerCase()
    res.send "HI @#{sender}! TIMMY!!"

  # brother
  brother = ['https://whatistheexcel.com/wooobooru/_images/75c9e97e34573f1f23518e36e40050fe/212%20-%20brother%20hulk_hogan%20macro%20mean_gene_okerlund%20microphone%20sunglasses%20wwe.jpg','http://t.qkme.me/3r68xv.jpg','http://cdn.meme.am/instances/53417899.jpg','http://cdn.meme.am/instances/61855016.jpg','http://i1168.photobucket.com/albums/r486/00GreenRanger/hulkhogan_zpsb7aa8412.jpg','http://www.quickmeme.com/img/be/be450207f2ec5e423298257ca2415fab23fbf53dfb6765070c3d333a42e0a5c5.jpg','http://www.quickmeme.com/img/5f/5f3a5911b741b287a80e45e1d3e7e5af00ebffa0067f3ef6a79aa22afa73caec.jpg']
  robot.hear /brother/i, (res) ->
    res.send res.random brother

  # cats
  cats = ['http://i.ytimg.com/vi/tntOCGkgt98/maxresdefault.jpg','http://www.washingtonpost.com/news/morning-mix/wp-content/uploads/sites/21/2014/09/Grumpy_Cat_Endorsement-017d7-ULFU.jpg','http://www.thaqafnafsak.com/wp-content/uploads/2014/05/Animals___Cats_Red_Cat_and_tongue_044659_29.jpg','http://static.giantbomb.com/uploads/original/3/34821/2577499-cat.jpg','http://f.tqn.com/y/cats/1/W/U/L/4/72892791DomesticCatsMating-Getty-Dorling-Kindersley-.jpg','https://assets.rbl.ms/435736/640x364.jpg','http://content4.video.news.com.au/NDM_-_news.com.au/150/881/parachuting_cats_648x365_2304624662-hero.jpg','http://www.pets4homes.co.uk/images/articles/1092/large/7-of-the-most-affectionate-cat-breeds-522ed069473c9.jpg','http://i.dailymail.co.uk/i/pix/2014/09/18/1411041513567_wps_11_dmvidpics_2014_09_18_at_1.jpg','http://www.amplifyingglass.com/wp-content/uploads/2014/06/sitting-cat5.jpg']
  robot.hear /(cat\b|cats\b)/i, (res) ->
    res.send res.random cats

  # beer
  robot.hear /(beer\b|beers\b)/i, (res) ->
    sender = res.message.user.name.toLowerCase()
    res.send ":beers: are on @#{sender} tonight!"

  # pokemon
  robot.hear /caught a (.*)/i, (res) ->
    pokemon = res.match[1]
    res.send "Good job catching that #{pokemon}! TIMMY!!"

  # NOTICE

  # randomly talk throughout the day
  setInterval((->
    num = Math.floor(Math.random() * phrases.length)
    robot.send room: 'general', phrases[num];
  ), Math.ceil(Math.random() * 100000000))

  # ask about the channel topic change
  robot.topic (res) ->
    sender = res.message.user.name.toLowerCase()
    res.send "@#{sender}, thanks for changing the channel topic to *#{res.message.text}*"

  # new user enter room welcome
  enterReplies = ["Hi", "Welcome", "Hello friend", "Boy, am I glad you\re here", "We're happy to have you"]
  robot.enter (res) ->
    randomReply = res.random enterReplies
    sender = res.message.user.name.toLowerCase()
    res.send "#{randomReply}, Hi, @#{sender}, I'm Olive and I'm here to help you out with things. You can type `Olive help` to see all the things I can lend a hand with."

  robot.respond /(who|qui) (.+)\?/i, (res) ->
    users = []
    for own key, user of robot.brain.users
      users.push "#{user.name}" if "#{user.name}" != robot.name
    res.send (res.random users).split(" ")[0] + " " + res.match[2] + "!"

  robot.respond /(google)( me)? (.*)/i, (res) ->
    googleMe res, res.match[3], (url) ->
      res.send url

googleMe = (res, query, cb) ->
  res.http('http://www.google.com/search')
    .query(q: query)
    .get() (err, res, body) ->
      cb body.match(/class="r"><a href="\/url\?q=([^"]*)(&amp;sa.*)">/)?[1] || "Sorry, Google had zero results for '#{query}'"
