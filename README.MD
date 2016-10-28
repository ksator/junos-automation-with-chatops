#### What to find on this repo:  
Chatops for network engineers.  
Initially inspired by this demo https://www.dravetech.com/blog/2016/03/30/chatops-demo.html  
Actually based on slack and hubot and automation content (ansible playbooks, python scripts, jinja2 templates ...) for junos automation  

#### Bot capabilties:
You can use slack delegate tasks to the bot.  
The bot can: 
- execute a junos command (set/delete/show) on junos devices  
- load a configuration data based on a jinja2 template on junos devices  
- apply a playbook to junos devices   
- roll back the junos configuration on junos devices  
- backup locally the configuration of junos devices  
- Manage bgp neighbors (add a neighbor, remove a neighbor, audit a neighbor session) on a junos device   
- Execute a python script  

It is easily extensible.    

#### Syntax: 
Here’s the chat syntax to delegate tasks to the bot, with some help:  

Backup the configuration of the device/group \<target>. It run under the hood the playbook pb.backup.yml with the variable \<target>. ```
hubot dev=\<target> backup 
```

Execute a Junos delete command on device/group \<target>. It run under the hood the playbook pb.delete.yml with the variables \<target>  and \<command>.

hubot dev=\<target> delete \<command>
```

Rollback \<rb_id> the configuration of device/group \<target>. It run under the hood the playbook pb.rollback.yml with the variables \<target> and \<rb_id>.
```
hubot dev=\<target> rollback \<rb_id>
```

Execute a Junos set command on device/group \<target>.  Add "--diff" to display the differences, add "--check" for a dry run. It run under the hood the playbook pb.config.yml with the variables \<target> and \<command>.
```
hubot dev=\<target> set \<command>
```

Execute a Junos show command on device/group \<target> and print the command output. You can use "show" or "sh". It run under the hood the playbook pb.command.yml with the variables \<target> anc \<command>.
```
hubot dev=\<target> show \<command>
```

Backup the configuration of device/group \<target>, and apply the jinja2 template \<template> to the device/group \<target>.  Add "--diff" to display the differences, add "--check" for a dry run. It run under the hood the playbook pb.template.yml with the variables \<target> and \<template>.
```
hubot dev=\<target> template \<template>
```

Execute the Ansible playbook \<playbook> on device/group \<target>. Add "--diff" to display the differences, add "--check" for a dry run.
```
hubot dev=\<target> playbook \<playbook>
```
Configure an ebgp neighbor on device \<target>. You can use "neighbor" or "neigh". Add "--diff" to display the differences, add "--check" for a dry run.  It run under the hood the playbook pb.add.ebgp.yml with the variables \<target> and \<peer_ip> and \<peer_asn>.
```
hubot dev=\<target> add bgp neighbor \<peer_ip> as \<peer_asn>
```

Retrieve on the device \<target> the bgp state for the neighbor \<peer_ip>, and print it. You can use "neighbor" or "neigh". It run under the hood the playbook pb.check.bgp.yml with the variables \<target> and \<peer_ip> 
```
hubot dev=\<target> get bgp state \<peer_ip>
```

Delete an existing ebgp neighbor on device \<target>. You can use "remove" or "rm", you can use "neighbor" or "neigh". It run under the hood the playbook pb.remove.ebgp.yml with the variables \<target> and \<peer_ip> 
```
hubot dev=\<target> remove bgp neighbor \<peer_ip>
```
Print a file (playbook, template, python scripts ...). You can use "show" or "sh"
```
hubot show \<file>
```

Print the list of Ansible playbooks. You can use "list" or "ls"
```
hubot list playbooks
```
Print the list of Jinja2 templates. You can use "list" or "ls"
```
hubot list templates
```

Print the list of Python scripts. You can use "list" or "ls"
```
hubot list python scripts
```
Execute the python script \<script> and print the program output
```
hubot python \<script>
```


Note: \<target> is a device or a group of devices. \<target> has to exist in the ansible inventory file (https://github.com/ksator/chatops_junos/blob/master/ansible/hosts).   

##### Chat examples:   
```
@myhubot help

@myhubot help template
@myhubot list templates
@myhubot display openconfig_bgp.j2
@myhubot list hosts
@myhubot target Openconfig_Routers template openconfig_bgp.j2
@myhubot target FR-MX80-214 show bgp summary 
@myhubot target Openconfig_Routers rollback 1

@myhubot target all backup

@myhubot target MX240-04 set system login message newbanner
@myhubot target MX240-04 delete system login message newbanner

@myhubot list playbooks
@myhubot target FR-MX80-214 playbook pb.check.physical.topology.yml
```


#### How does it work: 
The bot configuration is this file: https://github.com/ksator/chatops_junos/blob/master/scripts/junos.coffee. This is where we define the various actions the bot has to take based on the slack messages in the chat room.  So the bot is configured to execute Ansible playbooks.   

The bot uses Ansible under the hood. Here's the Ansible content (playbooks, variables, inventory ....) https://github.com/ksator/chatops_junos/tree/master/ansible   

So, as example, the slack message:   
```
myhubot target <target> template <template>    
```
or
```
@myhubot target <target> template <template>  
```
triggers the ansible playbook [**pb.template.yml**](https://github.com/ksator/chatops_junos/blob/master/ansible/pb.template.yml) with some variable definitions (using the --extra-vars option to pass the variables definition to the playbook):   
Actually, the bot will execute this command:  
```
ansible-playbook $PWD/ansible/pb.template.yml --extra-vars = "{'device': <target>, 'template': <template>}"
```
Which is the equivalent of: 
```
ansible-playbook $PWD/ansible/pb.template.yml --extra-vars "device=<target> template=<template>"  
```

#### The steps to reproduce are: 
-	create a slack team  
-	Optionally, integrate some tools into some channels of this slack team (some of my github repositories have a webhook to slack, some of my .travis.yml send slack notifications. So from these channels I receive notifications from github and TravisCI). 
-	Invite some peoples 
-	Install hubot (I installed it on an ubuntu 14.04 VM) 
-	Invite your bot 
-	Create some automation content (on the same VM that has the bot, so the bot doesnt need to use API to consume the automation content). My automation content is based on Ansible: https://github.com/ksator/chatops_junos/tree/master/ansible. 
- Optionally, you can also use the slack notification module in your Ansible playbooks (here's an example https://github.com/ksator/chatops_junos/blob/master/ansible/pb.template.yml)    
-	Create a script that tell your bot what to do based on slack messages. Here’s mine https://github.com/ksator/chatops_junos/blob/master/scripts/junos.coffee.  
- launch the bot, with a slack adaptor: 
```
ksator@ubuntu:~/myhubot$ HUBOT_SLACK_TOKEN=xoxb-90946701733-BTJh5QnUdQrTMcbtjgawmvjo ./bin/hubot -a slack
```

#### Contributions, bugs, questions, suggestions, enhancement requests
They are more than welcome. Please submit github issues or pull requests. 

