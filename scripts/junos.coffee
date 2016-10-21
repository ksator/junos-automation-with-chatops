# Description:
#   <description of the scripts functionality>
#
# Commands:
#
#   hubot target <target> backup - Backup the configuration of the device/group <target>
#   hubot target <target> delete <command>  - Execute a Junos delete command on device/group <target>
#   hubot target <target> rollback <rb_id> - Rollback <rb_id> the configuration of device/group <target>
#   hubot target <target> set <command> - Execute a Junos set command on device/group <target>
#   hubot target <target> show <command> - Execute a Junos show command on device/group <target> and print the command output
#   hubot target <target> template <template> - Backup the configuration of device/group <target>, and apply the jinja2 template <template> to the device/group <target>
#   hubot target <target> playbook <playbook> - Execute the Ansible playbook <playbook> on device/group <target>
#   hubot display <file> - Print an Ansible file (playbook, template, ...)
#   hubot list playbooks - Print the list of Ansible playbooks
#   hubot list templates - Print the list of Jinja2 templates
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
    
   robot.respond /target (.*) playbook (.*)/i, (msg) ->
     pb = msg.match[2]
     dev = msg.match[1]
     extra = "device=#{dev}"
     child_process.exec "ansible-playbook $PWD/ansible/#{pb} --extra-vars #{extra}", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)

   robot.respond /target (.*) set (.*)/i, (msg) ->
     cmd = msg.match[2]
     command = "set #{cmd}"
     dev = msg.match[1]
     extra = "{'device': #{dev}, 'cli': #{command}}"
     child_process.exec "ansible-playbook $PWD/ansible/pb.config.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)
   

   robot.respond /target (.*) delete (.*)/i, (msg) ->
     cmd = msg.match[2]
     command = "delete #{cmd}"
     dev = msg.match[1]
     extra = "{'device': #{dev}, 'cli': #{command}}"
     child_process.exec "ansible-playbook $PWD/ansible/pb.config.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)
   
   robot.respond /target (.*) rollback (.*)/i, (msg) ->
     rbid = msg.match[2]
     dev = msg.match[1]
     extra = "{'device': #{dev}, 'rbid': #{rbid}}"
     child_process.exec "ansible-playbook $PWD/ansible/pb.rollback.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)

   robot.respond /target (.*) backup/i, (msg) ->
     dev = msg.match[1]
     extra = "{'device': #{dev}}"
     child_process.exec "ansible-playbook $PWD/ansible/pb.backup.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)

   robot.respond /target (.*) template (.*)/i, (msg) ->
     template = msg.match[2]      
     dev = msg.match[1]
     extra = "{'device': #{dev}, 'template': #{template}}"
     child_process.exec "ansible-playbook $PWD/ansible/pb.template.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)

   robot.respond /target (.*) show (.*)/i, (msg) ->
     cmd = msg.match[2]
     command = "show #{cmd}"
     dev = msg.match[1]
     extra = "{'device': #{dev}, 'cli': #{command}}"
     child_process.exec "ansible-playbook $PWD/ansible/pb.command.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)

   robot.respond /list playbooks/i, (msg) ->
     child_process.exec "cd $PWD/ansible && ls pb.*.yml && cd ..", (error, stdout, stderr) ->
        msg.send(stdout)

   robot.respond /list templates/i, (msg) ->
     child_process.exec "cd $PWD/ansible && ls *.j2 && cd ..", (error, stdout, stderr) ->
        msg.send(stdout)

   robot.respond /display (.*)/i, (msg) ->
     file = msg.match[1]
     child_process.exec "cat $PWD/ansible/#{file}", (error, stdout, stderr) -> 
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)


