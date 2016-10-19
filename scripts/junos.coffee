# Description:
#   <description of the scripts functionality>
#
# Commands:
#   hubot playbook <X> on dev <Y> - Execute the playbook <X> on device/group <Y>
#   hubot set <X> on dev <Y> - Execute a junos set command on device/group <Y>
#   hubot delete <X> on dev <Y> - Execute a junos delete command on device/group <Y>
#   hubot rollback <id> on dev <Y> - Rollback <id> the configuration of device/group <Y>
#   hubot backup on dev <Y> - Backup the configuration of the device/group <Y>
#   hubot template <X> on dev <Y> - Backup the configuration of device/group <Y>, and apply the template <X> to the device/group <Y> 
#   hubot show <X> on dev <Y> - Execute a junos show command on device/group <Y> and print the command output
#   junos - Return a random lol
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   <github username of the original script author>

child_process = require('child_process')
enterReplies = ['Hi', 'Hello', 'Welcome']
lol = ['lol', 'LOL', 'I LOVE JUNOS']

module.exports = (robot) ->

   robot.respond /hi|hello/i, (msg) ->
     msg.reply "Hello!"

   robot.hear /junos/i, (res) ->
     res.send res.random lol

   robot.hear /^@hubot (.*)/i, (res) ->
     response = "Sorry, my name is #{robot.name}"
     res.reply response

   robot.hear /^hubot (.*)/i, (res) ->
     response = "Sorry, my name is #{robot.name}"
     res.reply response

   robot.enter (msg) ->
     msg.send msg.random enterReplies

   robot.listen(
     (message) ->
        message.user.name is "ksator" and Math.random() > 0.9
     (response) ->
       response.reply "HEY KSATOR! YOU'RE MY BEST FRIEND!"
   )
    
   robot.respond /playbook (.*) on dev (.*)/i, (msg) ->
     pb = msg.match[1]
     dev = msg.match[2]
     extra = "device=#{dev}"
     child_process.exec "ansible-playbook $PWD/ansible/#{pb} --extra-vars #{extra}", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)

   robot.respond /set (.*) on dev (.*)/i, (msg) ->
     cmd = msg.match[1]
     command = "set #{cmd}"
     dev = msg.match[2]
     extra = "{'device': #{dev}, 'cli': #{command}}"
     child_process.exec "ansible-playbook $PWD/ansible/pb.config.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)
   

   robot.respond /delete (.*) on dev (.*)/i, (msg) ->
     cmd = msg.match[1]
     command = "delete #{cmd}"
     dev = msg.match[2]
     extra = "{'device': #{dev}, 'cli': #{command}}"
     child_process.exec "ansible-playbook $PWD/ansible/pb.config.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)
   
   robot.respond /rollback (.*) on dev (.*)/i, (msg) ->
     rbid = msg.match[1]
     dev = msg.match[2]
     extra = "{'device': #{dev}, 'rbid': #{rbid}}"
     child_process.exec "ansible-playbook $PWD/ansible/pb.rollback.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)

   robot.respond /backup on dev (.*)/i, (msg) ->
     dev = msg.match[1]
     extra = "{'device': #{dev}}"
     child_process.exec "ansible-playbook $PWD/ansible/pb.backup.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)

   robot.respond /template (.*) on dev (.*)/i, (msg) ->
     template = msg.match[1]      
     dev = msg.match[2]
     extra = "{'device': #{dev}, 'template': #{template}}"
     child_process.exec "ansible-playbook $PWD/ansible/pb.template.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)

   robot.respond /show (.*) on dev (.*)/i, (msg) ->
     cmd = msg.match[1]
     command = "show #{cmd}"
     dev = msg.match[2]
     extra = "{'device': #{dev}, 'cli': #{command}}"
     child_process.exec "ansible-playbook $PWD/ansible/pb.command.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)
