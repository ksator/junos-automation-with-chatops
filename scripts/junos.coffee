# Description:
#   Junos automation
#
# Commands:
#   hubot dev=<target> backup - Backup the configuration of the device/group <target>. It run under the hood the playbook pb.backup.yml
#   hubot dev=<target> delete <command> - Execute a Junos delete command on device/group <target>. It run under the hood the playbook pb.delete.yml
#   hubot dev=<target> rollback <rb_id> - Rollback <rb_id> the configuration of device/group <target>. It run under the hood the playbook pb.rollback.yml
#   hubot dev=<target> set <command> - Execute a Junos set command on device/group <target>.  Add "--diff" to display the differences, add "--check" for a dry run. It run under the hood the playbook pb.config.yml
#   hubot dev=<target> show <command> - Execute a Junos show command on device/group <target> and print the command output. You can use "show" or "sh". It run under the hood the playbook pb.command.yml
#   hubot dev=<target> template <template> - Backup the configuration of device/group <target>, and apply the jinja2 template <template> to the device/group <target>.  Add "--diff" to display the differences, add "--check" for a dry run. It run under the hood the playbook pb.template.yml
#   hubot dev=<target> playbook <playbook> - Execute the Ansible playbook <playbook> on device/group <target>. Add "--diff" to display the differences, add "--check" for a dry run.
#   hubot dev=<target> add bgp neighbor <peer_ip> as <peer_asn> - Configure an ebgp neighbor on device <target>. You can use "neighbor" or "neigh". Add "--diff" to display the differences, add "--check" for a dry run.  It run under the hood the playbook pb.add.ebgp.yml
#   hubot dev=<target> get bgp state <peer_ip> - Retrieve on the device <target> the bgp state for the neighbor <peer_ip>, and print it. You can use "neighbor" or "neigh". It run under the hood the playbook pb.check.bgp.yml
#   hubot dev=<target> remove bgp neighbor <peer_ip> - Delete an existing ebgp neighbor on device <target>. You can use "remove" or "rm", you can use "neighbor" or "neigh". It run under the hood the playbook pb.remove.ebgp.yml
#   hubot show <file> - Print a file (playbook, template, ...). You can use "show" or "sh"
#   hubot list playbooks - Print the list of Ansible playbooks. You can use "list" or "ls"
#   hubot list templates - Print the list of Jinja2 templates. You can use "list" or "ls"
#
# Author:
#   Khelil Sator

child_process = require('child_process')
enterReplies = ['Hi', 'Hello', 'Welcome']
initial_response=["I am on it!", "I'll take care of that right away!", "Working on it!"]

module.exports = (robot) ->

   robot.respond /hi|hello/i, (msg) ->
     msg.reply "Hello!"

   robot.hear /junos/i, (res) ->
     res.send "I LOVE JUNOS!"

   robot.hear /^(@hubot|hubot) (.*)/i, (res) ->
     response = "Sorry, my name is #{robot.name}"
     res.reply response

   robot.enter (msg) ->
     msg.send msg.random enterReplies

   robot.listen(
     (message) ->
        message.user.name is "ksator" and Math.random() > 0.85
     (response) ->
       response.reply "HEY KSATOR! YOU'RE MY BEST FRIEND!"
   )
    
   robot.respond /dev=(.*) playbook (.*)/i, (msg) ->
     msg.send msg.random initial_response
     pb = msg.match[2]
     dev = msg.match[1]
     extra = "device=#{dev}"
     child_process.exec "ansible-playbook $PWD/ansible/#{pb} --extra-vars #{extra}", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)

   robot.respond /dev=(.*) set (.*)/i, (msg) ->
     cmd = msg.match[2]
     command = "set #{cmd}"
     dev = msg.match[1]
     extra = "{'device': #{dev}, 'cli': #{command}}"
     child_process.exec "ansible-playbook $PWD/ansible/pb.config.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)
   
   robot.respond /dev=(.*) delete (.*)/i, (msg) ->
     msg.send msg.random initial_response
     cmd = msg.match[2]
     command = "delete #{cmd}"
     dev = msg.match[1]
     extra = "{'device': #{dev}, 'cli': #{command}}"
     child_process.exec "ansible-playbook $PWD/ansible/pb.config.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)
   
   robot.respond /dev=(.*) rollback (.*)/i, (msg) ->
     msg.send msg.random initial_response
     rbid = msg.match[2]
     dev = msg.match[1]
     extra = "{'device': #{dev}, 'rbid': #{rbid}}"
     child_process.exec "ansible-playbook $PWD/ansible/pb.rollback.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)

   robot.respond /dev=(.*) backup/i, (msg) ->
     msg.send msg.random initial_response
     dev = msg.match[1]
     extra = "{'device': #{dev}}"
     child_process.exec "ansible-playbook $PWD/ansible/pb.backup.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)

   robot.respond /dev=(.*) template (.*)/i, (msg) ->
     msg.send msg.random initial_response
     template = msg.match[2]      
     dev = msg.match[1]
     extra = "{'device': #{dev}, 'template': #{template}}"
     child_process.exec "ansible-playbook $PWD/ansible/pb.template.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)

   robot.respond /dev=(.*) sh(ow)? (.*)/i, (msg) ->
     msg.send msg.random initial_response
     cmd = msg.match[3]
     command = "show #{cmd}"
     dev = msg.match[1]
     extra = "{'device': #{dev}, 'cli': #{command}}"
     child_process.exec "ansible-playbook $PWD/ansible/pb.command.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)

   robot.respond /dev=(.*) add bgp neigh(bor)? (.*) as (.*)/i, (msg) ->
     if not match = /help/.test(msg.match[1])
       msg.send msg.random initial_response
       ip = msg.match[3]
       asn = msg.match[4]
       dev = msg.match[1]
       option = ""   
       if match = /--check/.test(asn)
          option = "--check #{option}"
          asn = asn.replace(/--check/i,'')
       if match = /--diff/.test(asn)
          option = "--diff #{option}"
          asn = asn.replace(/--diff/i,'')
       extra = "{'device': #{dev}, 'peer_ip': #{ip}, 'peer_asn': #{asn}}"
       child_process.exec "ansible-playbook $PWD/ansible/pb.add.ebgp.yml --extra-vars \"#{extra}\" #{option}", (error, stdout, stderr) ->
         if error
           msg.send "Oops! " + error + stderr
         else
           msg.send(stdout)

   robot.respond /dev=(.*) (remove|rm) bgp neigh(bor)? (.*)/i, (msg) ->
     msg.send msg.random initial_response
     dev = msg.match[1]
     ip = msg.match[4]  
     extra = "{'device': #{dev}, 'peer_ip': #{ip}}"
     child_process.exec "ansible-playbook $PWD/ansible/pb.remove.ebgp.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)

   robot.respond /dev=(.*) get bgp state (.*)/i, (msg) ->
     if not match = /help/.test(msg.match[1])
       msg.send msg.random initial_response
       ip = msg.match[2]
       dev = msg.match[1]
       extra = "{'device': #{dev}, 'peer_ip': #{ip}}"
       child_process.exec "ansible-playbook $PWD/ansible/pb.check.bgp.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
         if error
           msg.send "Oops! " + error + stderr
         else
           msg.send(stdout)

   robot.respond /(list|ls) playbooks/i, (msg) ->
     child_process.exec "cd $PWD/ansible && ls pb.*.yml && cd ..", (error, stdout, stderr) ->
        msg.send(stdout)

   robot.respond /(list|ls) templates/i, (msg) ->
     child_process.exec "cd $PWD/ansible && ls *.j2 && cd ..", (error, stdout, stderr) ->
        msg.send(stdout)

   robot.respond /sh(ow)? (.*)/i, (msg) ->
     msg.send "here is it!"
     file = msg.match[2]
     child_process.exec "cat $PWD/ansible/#{file}", (error, stdout, stderr) -> 
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)


