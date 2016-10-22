# Description:
#   Let's hear Hubot speak!
#
# Commands:
#   hubot eightball - Get a Magic Eight Ball answer
#   hubot flip a coin - Flip a coin
#   hubot log N - Log N units of milk
#   hubot show timer - Show the timers progress
#   hubot roll the die - Roll the dice
#   hubot have a [anything] - eat or drink anything
#   hubot speak - It speaks!
#   hubot start timer - Start the timer
#   hubot stop timer - Stop the timer
#
# Author:
#   wylie

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
  robot.respond /have a (((:.*:))|(.\w+\b))/i, (res) ->
    stuffHad = res.match[1]
    #res.reply stuffHad
    stuffTotal = robot.brain.get('totalStuff') * 1 or 0
    if stuffTotal > 4
      res.reply "I'm too full for any more..."
    else
      res.reply "Sure, I love #{stuffHad} TIMMY!!"
    robot.brain.set 'totalStuff', stuffTotal+1

  robot.respond /sleep it off/i, (res) ->
    robot.brain.set 'totalStuff', 0
    res.reply "zzzzz"

  # user
  robot.respond /user/i, (res) ->
    res.reply res.message.user.name

  # room
  robot.respond /room/i, (res) ->
    room = res.message.room
    res.send "This room is: ##{room} :house_with_garden:"

  robot.respond /lyrics '(.*)'/i, (msg) ->
    msg.http("http://dukeofcheese.com/dev/hubot/olive/songs.json")
      .get() (err, res, body) ->
        json = JSON.parse(body)
        switch res.statusCode
          when 200
            songTitle = msg.match[1]
            songLyrics = json.songs[songTitle]
            msg.send songLyrics
          else
            msg.send "..."

  robot.respond /song (.*) by (.*)/i, (msg) ->
    songTitle = msg.match[1]
    songTitle = songTitle.replace(/\s/i,'%20')
    songArtist = msg.match[2]
    songArtist = songArtist.replace(/\s/i,'%20')
    myUrl = "http://api.lyricsnmusic.com/songs?api_key=085157dded76ca409d9cd41b300453&q=#{songArtist}%20#{songTitle}";
    msg.http(myUrl)
      .get() (err, res, body) ->
        json = JSON.parse(body)
        switch res.statusCode
          when 200
            msg.send myUrl
          else
            msg.send "..."

  # speak
  robot.respond /speak/i, (msg) ->
    msg.http("http://dukeofcheese.com/dev/hubot/timmy/speak.json")
      .get() (err, res, body) ->
        json = JSON.parse(body)
        switch res.statusCode
          when 200
            num = Math.floor(Math.random() * json.speak.length)
            msg.send json.speak[num]
          else
            msg.send "..."

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
    res.reply "#{res.random ball} :magic8ball: TIMMEH!!"

  # hi
  robot.respond /(\bhi\b)/gi, (res) ->
    sender = res.message.user.name.toLowerCase()
    res.send "HI @#{sender}! TIMMY!!"

  # kick your butt
  robot.respond /(what\scan\syou\sdo)/i, (res) ->
    sender = res.message.user.name.toLowerCase()
    res.send "I can kick your ass, @#{sender}! :knife: TIMMY!!"

  # sorry
  robot.respond /(wrong\sanswer)/i, (res) ->
    sender = res.message.user.name.toLowerCase()
    res.send "Sorry, @#{sender}, what would you have my answer be?"

  # brother
  robot.hear /(\bbrother\b)/i, (msg) ->
    msg.http("http://dukeofcheese.com/dev/hubot/timmy/brother.json")
      .get() (err, res, body) ->
        json = JSON.parse(body)
        switch res.statusCode
          when 200
            num = Math.floor(Math.random() * json.brother.length)
            msg.send json.brother[num]
          else
            msg.send "..."

  # roberto
  robot.hear /(\bwombat\b)/i, (msg) ->
    msg.http("http://dukeofcheese.com/dev/hubot/timmy/roberto.json")
      .get() (err, res, body) ->
        json = JSON.parse(body)
        switch res.statusCode
          when 200
            num = Math.floor(Math.random() * json.roberto.length)
            msg.send json.roberto[num]
          else
            msg.send "..."

  # get/buy(ing) beer(s)
  robot.hear /(((\bget\b)|(\bbuy\b|\bbuying\b))\s(\bbeer\b|\bbeers\b))/i, (res) ->
    sender = res.message.user.name.toLowerCase()
    res.send ":beers: are on @#{sender} tonight! TIMMY!!"

  # shut up
  robot.hear /(\bshut up\b)/i, (res) ->
    sender = res.message.user.name.toLowerCase()
    res.send "No, you shut up @#{sender}! TIMMY!!"

  # zombie jesus
  robot.hear /(\bsweet\b|\bzombie\b|\bjesus\b|\bsweet jesus\b|\bzombie jesus\b|\bsweet zombie jesus\b)/i, (res) ->
    res.send "http://rs777.pbsrc.com/albums/yy59/gaderffii/SweetZombieJesus.jpg~c200"

  # the rock
  robot.hear /(\bsmell\b|\brock\b|\bcooking\b)/i, (res) ->
    res.send "http://www.awesomelyluvvie.com/wp-content/uploads/2014/07/the-rock-fanny-pack.jpg"

  # pokemon
  robot.hear /(caught).* (:pokemon-.*:)/i, (res) ->
    pokemon = res.match[1]
    sender = res.message.user.name.toLowerCase()
    res.send "Good job catching that #{pokemon}, @#{sender}! TIMMY!!"

  # kill
  robot.hear /i will (\bend\b|\bdestroy\b|\bkill\b) you/i, (res) ->
    sender = res.message.user.name.toLowerCase()
    res.send "Not before I kill you, @#{sender}! TIMMY!!"

  # not now timmy
  notNow = new RegExp "(not now #{robot.name}|#{robot.name}(, not now|\snot now))", "i"
  robot.hear notNow, (res) ->
    sender = res.message.user.name.toLowerCase()
    res.send "If not now, when @#{sender}? TIMMY!!"

  # NOTICE

  # randomly talk throughout the day
  setInterval((->
    robot.http("http://dukeofcheese.com/dev/hubot/timmy/phrases.json")
      .get() (err, res, body) ->
        json = JSON.parse(body)
        switch res.statusCode
          when 200
            num = Math.floor(Math.random() * json.phrases.length)
            robot.send room: 'general', json.phrases[num];
          else
            res.send "..."
  ), 100000000)

  # ask about the channel topic change
  # robot.topic (res) ->
  #   sender = res.message.user.name.toLowerCase()
  #   res.send "Attention, attention! @#{sender} has changed the channel topic to *#{res.message.text}*"

  # user enters room
  robot.enter (res) ->
    sender = res.message.user.name.toLowerCase()
    res.send "Everybody give a warm welcome to @#{sender}! :wave: I'm Timmy and I'm here to help. Type `Timmy help` to see all my actions. TIMMY!!"

  # user leaves room
  robot.leave (res) ->
    sender = res.message.user.name.toLowerCase()
    res.send "So long, @#{sender} :wave: TIMMY!!"

  # who's in this room
  robot.respond /(who|qui) (.+)\?/i, (res) ->
    users = []
    for own key, user of robot.brain.users
      users.push "#{user.name}" if "#{user.name}" != robot.name
    res.send (res.random users).split(" ")[0] + " " + res.match[2] + "!"

  # google
  robot.respond /\b(goog(le me|le))?\b (.*)/i, (res) ->
    googleMe res, res.match[3], (url) ->
      res.send "It looks like this might help you on your search :mag:\n#{url}"

    googleMe = (msg, query, cb) ->
      msg.http('http://www.google.com/search')
        .query(q: query)
        .get() (err, res, body) ->
          cb body.match(/class="r"><a href="\/url\?q=([^"]*)(&amp;sa.*)">/)?[1] || "Sorry, Google had zero results for '#{query}'"

  # youtube
  # robot.respond /\b(vid(eo me|eo))?\b (.*)/i, (res) ->
  #   youtubeMe res, res.match[3], (url) ->
  #     res.send url
  #
  # youtubeMe = (msg, query, cb) ->
  #   msg.http('https://www.googleapis.com/youtube/v3/search')
  #     .query(q: query)
  #     .get() (err, res, body) ->
  #       cb body.match(/class="r"><a href="\/url\?q=([^"]*)(&amp;sa.*)">/)?[1] || "Sorry, YouTube had zero results for '#{query}'"

  # days of the week
  setInterval (->
    time = new Date
    day = time.getDay()
    hour = time.getHours()
    minute = time.getMinutes()
    second = time.getSeconds()
    # if hour < 12
    #   suff = 'am'
    # if hour > 12
    #   suff = 'pm'
    # if hour == 0
    #   hour = 12
    # Taco Tuesday
    if day == 2 and hour == 12 and minute == 0
      robot.send room: 'general', "Hooray, it's Taco Tuesday! :taco: TIMMY!!"
    # Burger Friday
    if day == 5 and hour == 12 and minute == 0
      robot.send room: 'general', "Hooray, it's Burger Friday! :hamburger: TIMMY!!"
    return
  ), 60000

  # Timmy good morning
  robot.respond /good morning/i, (res) ->
    res.http("http://dukeofcheese.com/dev/hubot/timmy/speak.json")
      .get() (err, res, body) ->
        json = JSON.parse(body)
        switch res.statusCode
          when 200
            num = Math.floor(Math.random() * json.speak.length)
            sender = res.message.user.name.toLowerCase()
            res.reply "Good morning, @#{sender}! " + json.speak[num]
          else
            res.reply "..."
  ## ---------------
  ## EMOJI RESPONSES
  ## ---------------
  # beer
  robot.hear /\bbeer\b/i, (msg) ->
    queryData =  {
      token: process.env.HUBOT_SLACK_TOKEN
      name: "beer"
      channel: msg.message.rawMessage.channel # required with timestamp, uses rawMessage to find this
      timestamp: msg.message.id # this id is no longer undefined
    }
    if (queryData.timestamp?)
      msg.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # cat(s)
  robot.hear /(\bcat\b|\bcats\b)/i, (msg) ->
    queryData =  {
      token: process.env.HUBOT_SLACK_TOKEN
      name: "cat"
      channel: msg.message.rawMessage.channel # required with timestamp, uses rawMessage to find this
      timestamp: msg.message.id # this id is no longer undefined
    }
    if (queryData.timestamp?)
      msg.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # kanye
  robot.hear /\bkanye\b/i, (msg) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "kanye"
        channel: msg.message.rawMessage.channel
        timestamp: msg.message.id
      }

    if (queryData.timestamp?)
      msg.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # 100
  robot.hear /\b(awesome|success)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "100"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # hamburger
  robot.hear /\b(ham)|burger\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "hamburger"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # star
  robot.hear /\b(props|star)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "star"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # lee
  robot.hear /\blee\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "lee"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # sunrise
  robot.hear /\b(good\smorning|morning)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "sunrise"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # sushi
  robot.hear /\bsushi\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "sushi"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # coffee
  robot.hear /\bcoffee\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "coffee"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # dickbutt
  robot.hear /\b(dick|butt|dickbutt|richard)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "dickbutt"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # computer
  robot.hear /\b(laptop|computer|work|working)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "computer"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # moneybag
  robot.hear /\b(paid|money|cash|expensive|expenses|riches)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "moneybag"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # the_horns
  robot.hear /\brock(\son|er|\sand\sroll|\s&\sroll|in|)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "the_horns"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # medal
  robot.hear /\b(good\sjob|well\sdone)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "medal"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # amazon
  robot.hear /\bamazon\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "amazon"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # esimons
  robot.hear /\be(van\ssimons|van|simons)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "esimons"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  robot.hear /\bro(b|bs|berto|bsface|bsfault)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "robsface"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return


  # matt-pivnick
  robot.hear /\bm(att\spivnick|att|pivnick)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "matt-pivnick"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # rbl
  robot.hear /\br(yan\sleach|yan|leach|bl)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "rbl"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # greg-jones
  robot.hear /\bg(reg|jjones)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "greg-jones"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # trent
  robot.hear /\b(trent|dragonegger2)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "trent"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # wylie
  robot.hear /\bwy(lie|liefisher)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "wylie"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # burrito
  robot.hear /\bburrito\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "burrito"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # meat_on_bone
  robot.hear /\bbbq\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "meat_on_bone"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # my_little_pony
  robot.hear /\b(rob|robs|roberto|robsface|robsfault)\b|\b(pony|my\slittle\spony)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "my_little_pony"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # flowdock
  robot.hear /\bflowdock\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "flowdock"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # starbucks
  robot.hear /\bstarbucks\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "starbucks"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # hocho
  robot.hear /\b(stab|knife|cut\syou|end\syou|destroy\syou)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "hocho"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # middle_finger
  robot.hear /\b(fuck|fucker|fuckers)\b|\b(ass|asshole|assholes)\b|\b(jerk|jerks)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "middle_finger"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # appleinc
  robot.hear /\b(os\sx|apple|mac|macintosh|iphone|apple\swatch)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "appleinc"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # google
  robot.hear /\b(google|search)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "google"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # git
  robot.hear /\bgit\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "git"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # github
  robot.hear /\bgithub\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "github"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # facebook
  robot.hear /\bfacebook\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "facebook"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # drupal
  robot.hear /\b(amy|ooh\sooh|um|drupal)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "drupal"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # amy
  robot.hear /\b(amy|ooh\sooh|um|drupal)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "amy"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # keanu
  robot.hear /\b(w(hoa|hoah|oah))|(keanu)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "keanu"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # spiderman
  robot.hear /\bspid(erman|ey|er)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "spiderman"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # starwars
  robot.hear /\b(star\swars|starwars|rogue\sone)\b|\b(empire|rebel)\b|\b(darth\svader|darth|vader|anakin)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "starwars"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # empire
  robot.hear /\b(star\swars|starwars|rogue\sone)\b|\b(empire)\b|\b(darth\svader|darth|vader|anakin)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "starwars_empire"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # rebel
  robot.hear /\b(star\swars|starwars|rogue\sone)\b|\b(rebel)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "starwars_rebel"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # darth_vader
  robot.hear /\b(star\swars|starwars|rogue\sone)\b|\b(empire)\b|\b(father|darth\svader|darth|vader|anakin)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "starwars_darth_vader"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # cheese
  robot.hear /\bcheese\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "cheese"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # skull
  robot.hear /\b(skull|cheese|die)\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "skull"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # photoshop
  robot.hear /\bphotoshop\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "photoshop"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # surprise
  robot.hear /\bsurprise\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "surprise"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # flamingo
  robot.hear /\bflamingo\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "flamingo"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # peach
  robot.hear /\b(peach|bu(tt|tts))\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "peach"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # chicken
  robot.hear /\bchicken\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "chicken"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # slack
  robot.hear /\bslack\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "slack"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # pepsi
  robot.hear /\bpepsi\b/i, (res) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "pepsi"
        channel: res.message.rawMessage.channel
        timestamp: res.message.id
      }

    if (queryData.timestamp?)
      res.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          return

  # double test
  robot.hear /\bi(ts|t's)\snot\srobs\sfault\b/i, (res) ->
    smpl = [
      "nyancat_big"
      "bomb"
      "star"
      "aw_yeah"
      "taco"
      "dickbutt"
      "middle_finger"
      "beer"
      "matt-pivnick"
      "sausage_punch"
      "robsface"
      "esimons"
      "wylie"
      "rabbit_dance_pose"
      "lee"
      "greg-jones"
      "tangotucan"
      "pump_girl"
      "my_little_pony"
      "skull"
      "timmy"
      "bmo"
      "keanu"
      "futurama_fry"
      "kanye"
      "empire"
      "rebel"
      "cheese"
    ]
    x = 0
    while x < smpl.length
      queryData =  {
          token: process.env.HUBOT_SLACK_TOKEN
          name: smpl[x]
          channel: res.message.rawMessage.channel
          timestamp: res.message.id
        }
      x++

      if (queryData.timestamp?)
        res.http("https://slack.com/api/reactions.add")
          .query(queryData)
          .post() (err, res, body) ->
              return

  # add reaction
  # robot.hear /\bclocks?\b/i, (msg) ->
  #   queryData =  {
  #       token: process.env.HUBOT_SLACK_TOKEN
  #       name: "bomb"
  #       channel: msg.message.rawMessage.channel # required with timestamp, uses rawMessage to find this
  #       timestamp: msg.message.id # this id is no longer undefined
  #     }
  #
  #   if (queryData.timestamp?)
  #     msg.http("https://slack.com/api/reactions.add")
  #       .query(queryData)
  #       .post() (err, res, body) ->
  #         #TODO: error handling
  #         return
