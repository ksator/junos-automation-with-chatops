# Author:
#   Khelil Sator

enterReplies = ['Hi', 'Hello']

module.exports = (robot) ->

   robot.respond /hi|hello/i, (msg) ->
     msg.reply "Hello!"

   robot.hear /junos/i, (res) ->
     res.send "I LOVE JUNOS!"

   robot.hear /^(@hubot|hubot) (.*)/i, (res) ->
     response = "Sorry, my name is #{robot.name}"
     res.reply response

   robot.listen(
     (message) ->
        message.user.name is "ksator" and Math.random() > 0.92
     (response) ->
       response.reply "HEY KSATOR! YOU'RE MY BEST FRIEND!"
   )
    
   robot.enter (msg) ->
     msg.send msg.random enterReplies
