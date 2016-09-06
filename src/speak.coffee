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
    res.send "This room is: ##{room}"

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
    # msg.send myUrl
    msg.http(myUrl)
    # msg.http("http://api.lyricsnmusic.com/songs?api_key=085157dded76ca409d9cd41b300453&q=#{songArtist}%20#{songTitle}")
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
    res.reply res.random ball

  # LISTEN

  # hi
  robot.hear /(\bhi\b)/gi, (res) ->
    sender = res.message.user.name.toLowerCase()
    res.send "HI @#{sender}! TIMMY!!"

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
          #TODO: error handling
          return

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
          #TODO: error handling
          return

  # shut up
  robot.hear /(\bshut up\b)/gmi, (res) ->
    sender = res.message.user.name.toLowerCase()
    res.send "No, you shut up @#{sender}! TIMMY!!"

  # zombie jesus
  robot.hear /(\bsweet\b|\bzombie\b|\bjesus\b|\bsweet jesus\b|\bzombie jesus\b|\bsweet zombie jesus\b)/gmi, (res) ->
    res.send "http://rs777.pbsrc.com/albums/yy59/gaderffii/SweetZombieJesus.jpg~c200"

  # the rock
  robot.hear /(\bsmell\b|\brock\b|\bcooking\b)/gmi, (res) ->
    res.send "http://www.awesomelyluvvie.com/wp-content/uploads/2014/07/the-rock-fanny-pack.jpg"

  ## ---------------
  ## EMOJI RESPONSES
  ## ---------------
  # robsface
  robot.hear /(:|@|#|)(\brob\b|\brobs\b|\broberto\b|\brobsface\b|\brobsfault\b)(:|)/i, (msg) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "robsface"
        channel: msg.message.rawMessage.channel
        timestamp: msg.message.id
      }

    if (queryData.timestamp?)
      msg.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          #TODO: error handling
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
          #TODO: error handling
          return

  # 100
  robot.hear /\bawesome\b/i, (msg) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "100"
        channel: msg.message.rawMessage.channel
        timestamp: msg.message.id
      }

    if (queryData.timestamp?)
      msg.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          #TODO: error handling
          return

  # hamburger
  robot.hear /\b(burger|hamburger)\b/i, (msg) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "hamburger"
        channel: msg.message.rawMessage.channel
        timestamp: msg.message.id
      }

    if (queryData.timestamp?)
      msg.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          #TODO: error handling
          return

  # star
  robot.hear /\bprops\b/i, (msg) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "star"
        channel: msg.message.rawMessage.channel
        timestamp: msg.message.id
      }

    if (queryData.timestamp?)
      msg.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          #TODO: error handling
          return

  # lee
  robot.hear /(:|#|@|)(\blee\b)(:|)/i, (msg) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "lee"
        channel: msg.message.rawMessage.channel
        timestamp: msg.message.id
      }

    if (queryData.timestamp?)
      msg.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          #TODO: error handling
          return

  # sunrise
  robot.hear /\b(good\smorning|morning)\b/i, (msg) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "sunrise"
        channel: msg.message.rawMessage.channel
        timestamp: msg.message.id
      }

    if (queryData.timestamp?)
      msg.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          #TODO: error handling
          return

  # sushi
  robot.hear /\bsushi\b/i, (msg) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "sushi"
        channel: msg.message.rawMessage.channel
        timestamp: msg.message.id
      }

    if (queryData.timestamp?)
      msg.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          #TODO: error handling
          return

  # coffee
  robot.hear /\bcoffee\b/i, (msg) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "coffee"
        channel: msg.message.rawMessage.channel
        timestamp: msg.message.id
      }

    if (queryData.timestamp?)
      msg.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          #TODO: error handling
          return

  # dickbutt
  robot.hear /\b(dick|butt|dickbutt|richard)\b/i, (msg) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "dickbutt"
        channel: msg.message.rawMessage.channel
        timestamp: msg.message.id
      }

    if (queryData.timestamp?)
      msg.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          #TODO: error handling
          return

  # amazon
  robot.hear /\bamazon\b/i, (msg) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "amazon"
        channel: msg.message.rawMessage.channel
        timestamp: msg.message.id
      }

    if (queryData.timestamp?)
      msg.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          #TODO: error handling
          return

  # esimons
  robot.hear /\b(evan|simons|esimons)\b/i, (msg) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "esimons"
        channel: msg.message.rawMessage.channel
        timestamp: msg.message.id
      }

    if (queryData.timestamp?)
      msg.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          #TODO: error handling
          return

  # matt-pivnick
  robot.hear /\b(matt|pivnick)\b/i, (msg) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "matt-pivnick"
        channel: msg.message.rawMessage.channel
        timestamp: msg.message.id
      }

    if (queryData.timestamp?)
      msg.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          #TODO: error handling
          return

  # greg-jones
  robot.hear /\b(greg|jones)\b/i, (msg) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "greg-jones"
        channel: msg.message.rawMessage.channel
        timestamp: msg.message.id
      }

    if (queryData.timestamp?)
      msg.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          #TODO: error handling
          return

  # wylie
  robot.hear /\bwylie\b/i, (msg) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "wylie"
        channel: msg.message.rawMessage.channel
        timestamp: msg.message.id
      }

    if (queryData.timestamp?)
      msg.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          #TODO: error handling
          return

  # burrito
  robot.hear /\bburrito\b/i, (msg) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "burrito"
        channel: msg.message.rawMessage.channel
        timestamp: msg.message.id
      }

    if (queryData.timestamp?)
      msg.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          #TODO: error handling
          return

  # meat_on_bone
  robot.hear /\bbbq\b/i, (msg) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "meat_on_bone"
        channel: msg.message.rawMessage.channel
        timestamp: msg.message.id
      }

    if (queryData.timestamp?)
      msg.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          #TODO: error handling
          return

  # flowdock
  robot.hear /\bflowdock\b/i, (msg) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "flowdock"
        channel: msg.message.rawMessage.channel
        timestamp: msg.message.id
      }

    if (queryData.timestamp?)
      msg.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          #TODO: error handling
          return

  # slack
  robot.hear /\bslack\b/i, (msg) ->
    queryData =  {
        token: process.env.HUBOT_SLACK_TOKEN
        name: "slack"
        channel: msg.message.rawMessage.channel
        timestamp: msg.message.id
      }

    if (queryData.timestamp?)
      msg.http("https://slack.com/api/reactions.add")
        .query(queryData)
        .post() (err, res, body) ->
          #TODO: error handling
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

  # pokemon
  robot.hear /(caught).* (:pokemon-.*:)/i, (res) ->
    pokemon = res.match[1]
    sender = res.message.user.name.toLowerCase()
    res.send "Good job catching that #{pokemon}, @#{sender}! TIMMY!!"

  # kill
  robot.hear /i will (\bend\b|\bdestroy\b|\bkill\b) you/gmi, (res) ->
    sender = res.message.user.name.toLowerCase()
    res.send "Not before I kill you, @#{sender}! TIMMY!!"

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
            msg.send "..."
  ), 100000000)

  # ask about the channel topic change
  robot.topic (res) ->
    sender = res.message.user.name.toLowerCase()
    res.send "@#{sender}, thanks for changing the channel topic to *#{res.message.text}*"

  # new user enter room welcome
  robot.enter (msg) ->
    msg.http("http://dukeofcheese.com/dev/hubot/timmy/enter.json")
      .get() (err, res, body) ->
        json = JSON.parse(body)
        switch res.statusCode
          when 200
            num = Math.floor(Math.random() * json.enter.length)
            msg.send json.enter[num]
          else
            msg.send "..."

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

  setInterval (->
    time = new Date
    day = time.getDay()
    hour = time.getHours()
    minute = time.getMinutes()
    second = time.getSeconds()
    if hour < 12
      suff = 'am'
    if hour > 12
      hour = hour - 4
      suff = 'pm'
    if hour == 0
      hour = 12
    # Taco Tuesday
    if day == 2 and hour == 8 and minute == 0
      robot.send room: 'general', "Hooray, it's Taco Tuesday! :taco: TIMMY!!"
    # Burger Friday
    if day == 5 and hour == 8 and minute == 0
      robot.send room: 'general', "Hooray, it's Burger Friday! :hamburger: TIMMY!!"
    return
  ), 60000

  robot.respond /good morning/i, (msg) ->
    msg.http("http://dukeofcheese.com/dev/hubot/timmy/speak.json")
      .get() (err, res, body) ->
        json = JSON.parse(body)
        switch res.statusCode
          when 200
            num = Math.floor(Math.random() * json.speak.length)
            sender = msg.message.user.name.toLowerCase()
            msg.send "Good morning, @#{sender}! " + json.speak[num]
          else
            msg.send "..."

  morning = new RegExp "(good morning #{robot.name}|good morning @#{robot.name})", "i"
  robot.hear morning, (msg) ->
    msg.http("http://dukeofcheese.com/dev/hubot/timmy/speak.json")
      .get() (err, res, body) ->
        json = JSON.parse(body)
        switch res.statusCode
          when 200
            num = Math.floor(Math.random() * json.speak.length)
            sender = msg.message.user.name.toLowerCase()
            msg.send "Good morning, @#{sender}! " + json.speak[num]
          else
            msg.send "..."
    
