# Description:
#   Junos automation
#
# Commands:
#
# here's the help! 
#
#   hubot dev=<target> backup - Backup the configuration of the device/group <target>. It run under the hood the playbook pb.backup.yml with the variable <target>. 
#
#   hubot dev=<target> delete <command> - Execute a Junos delete command on device/group <target>. It run under the hood the playbook pb.config.yml with the variables <target>  and <command>.
#
#   hubot dev=<target> rollback <rb_id> - Rollback <rb_id> the configuration of device/group <target>. It run under the hood the playbook pb.rollback.yml with the variables <target> and <rb_id>.
#
#   hubot dev=<target> set <command> - Execute a Junos set command on device/group <target>.  Add "--diff" to display the differences, add "--check" for a dry run. It run under the hood the playbook pb.config.yml with the variables <target> and <command>.
#
#   hubot dev=<target> show <command> - Execute a Junos show command on device/group <target> and print the command output. You can use "show" or "sh". It run under the hood the playbook pb.command.yml with the variables <target> anc <command>.
#
#   hubot dev=<target> template <template> - Backup the configuration of device/group <target>, and apply the jinja2 template <template> to the device/group <target>.  Add "--diff" to display the differences, add "--check" for a dry run. It run under the hood the playbook pb.template.yml with the variables <target> and <template>.
#
#   hubot dev=<target> playbook <playbook> - Execute the Ansible playbook <playbook> on device/group <target>. Add "--diff" to display the differences, add "--check" for a dry run.
#
#   hubot dev=<target> add bgp neighbor <peer_ip> as <peer_asn> - Configure an ebgp neighbor on device <target>. You can use "neighbor" or "neigh". Add "--diff" to display the differences, add "--check" for a dry run.  It run under the hood the playbook pb.add.ebgp.yml with the variables <target> and <peer_ip> and <peer_asn>.
#
#   hubot dev=<target> get bgp state <peer_ip> - Retrieve on the device <target> the bgp state for the neighbor <peer_ip>, and print it. You can use "neighbor" or "neigh". It run under the hood the playbook pb.check.bgp.yml with the variables <target> and <peer_ip> 
#
#   hubot dev=<target> remove bgp neighbor <peer_ip> - Delete an existing ebgp neighbor on device <target>. You can use "remove" or "rm", you can use "neighbor" or "neigh". It run under the hood the playbook pb.remove.ebgp.yml with the variables <target> and <peer_ip> 
#
#   hubot show <file> - Print a file (playbook, template, python scripts ...). You can use "show" or "sh"
#
#   hubot list playbooks - Print the list of Ansible playbooks. You can use "list" or "ls"
#
#   hubot list templates - Print the list of Jinja2 templates. You can use "list" or "ls"
#
#   hubot list python scripts- Print the list of Python scripts. You can use "list" or "ls"  
#
#   hubot python <script> - Execute the python script <script> and print the program output
#
#
# Author:
#   Khelil Sator

child_process = require('child_process')
initial_response=["I am on it!", "I'll take care of that right away!", "Working on it!"]

module.exports = (robot) ->

   robot.respond /dev=(.*) playbook (.*)/i, (msg) ->
     msg.send msg.random initial_response
     pb = msg.match[2]
     dev = msg.match[1]
     option = ""   
     if match = /--check/.test(pb)
        option = "--check #{option}"
        pb = pb.replace(/--check/i,'')
     if match = /--diff/.test(pb)
        option = "--diff #{option}"
        pb = pb.replace(/--diff/i,'')
     extra = "device=#{dev}"
     child_process.exec "ansible-playbook $PWD/automation_content/#{pb} --extra-vars #{extra} #{option}", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)

   robot.respond /dev=(.*) set (.*)/i, (msg) ->
     msg.send msg.random initial_response
     cmd = msg.match[2]
     command = "set #{cmd}"
     dev = msg.match[1]
     option = ""   
     if match = /--check/.test(command)
        option = "--check #{option}"
        command = command.replace(/--check/i,'')
     if match = /--diff/.test(command)
        option = "--diff #{option}"
        command = command.replace(/--diff/i,'')
     extra = "{'device': #{dev}, 'cli': #{command}}"
     child_process.exec "ansible-playbook $PWD/automation_content/pb.config.yml --extra-vars \"#{extra}\" #{option}", (error, stdout, stderr) ->
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
     child_process.exec "ansible-playbook $PWD/automation_content/pb.config.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)
   
   robot.respond /dev=(.*) rollback (.*)/i, (msg) ->
     msg.send msg.random initial_response
     rbid = msg.match[2]
     dev = msg.match[1]
     extra = "{'device': #{dev}, 'rbid': #{rbid}}"
     child_process.exec "ansible-playbook $PWD/automation_content/pb.rollback.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)

   robot.respond /dev=(.*) backup/i, (msg) ->
     msg.send msg.random initial_response
     dev = msg.match[1]
     extra = "{'device': #{dev}}"
     child_process.exec "ansible-playbook $PWD/automation_content/pb.backup.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)

   robot.respond /dev=(.*) template (.*)/i, (msg) ->
     msg.send msg.random initial_response
     template = msg.match[2]      
     dev = msg.match[1]
     option = ""   
     if match = /--check/.test(template)
        option = "--check #{option}"
        template = template.replace(/--check/i,'')
     if match = /--diff/.test(template)
        option = "--diff #{option}"
        template = template.replace(/--diff/i,'')
     extra = "{'device': #{dev}, 'template': #{template}}"
     child_process.exec "ansible-playbook $PWD/automation_content/pb.template.yml --extra-vars \"#{extra}\" #{option}", (error, stdout, stderr) ->
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
     child_process.exec "ansible-playbook $PWD/automation_content/pb.command.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
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
       child_process.exec "ansible-playbook $PWD/automation_content/pb.add.ebgp.yml --extra-vars \"#{extra}\" #{option}", (error, stdout, stderr) ->
         if error
           msg.send "Oops! " + error + stderr
         else
           msg.send(stdout)

   robot.respond /dev=(.*) (remove|rm) bgp neigh(bor)? (.*)/i, (msg) ->
     msg.send msg.random initial_response
     dev = msg.match[1]
     ip = msg.match[4]  
     extra = "{'device': #{dev}, 'peer_ip': #{ip}}"
     child_process.exec "ansible-playbook $PWD/automation_content/pb.remove.ebgp.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
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
       child_process.exec "ansible-playbook $PWD/automation_content/pb.check.bgp.yml --extra-vars \"#{extra}\"", (error, stdout, stderr) ->
         if error
           msg.send "Oops! " + error + stderr
         else
           msg.send(stdout)

   robot.respond /python (.*)/i, (msg) ->
     msg.send msg.random initial_response
     script = msg.match[1]
     output = child_process.exec "python $PWD/automation_content/#{script}"
     output.stdout.on 'data', (data) ->
        msg.send data.toString()

   robot.respond /(list|ls) playbooks/i, (msg) ->
     child_process.exec "cd $PWD/automation_content && ls pb.*.yml && cd ..", (error, stdout, stderr) ->
        msg.send(stdout)

   robot.respond /(list|ls) templates/i, (msg) ->
     child_process.exec "cd $PWD/automation_content && ls *.j2 && cd ..", (error, stdout, stderr) ->
        msg.send(stdout)

   robot.respond /(list|ls) python scripts/i, (msg) ->
     child_process.exec "cd $PWD/automation_content && ls *.py && cd ..", (error, stdout, stderr) ->
        msg.send(stdout)

   robot.respond /sh(ow)? (.*)/i, (msg) ->
     file = msg.match[2]
     child_process.exec "cat $PWD/automation_content/#{file}", (error, stdout, stderr) -> 
       if error
         msg.send "Oops! " + error + stderr
       else
         msg.send(stdout)

