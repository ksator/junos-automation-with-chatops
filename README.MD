#### What to find on this repo:  
Chatops for network engineers.  
Initially inspired by this demo https://www.dravetech.com/blog/2016/03/30/chatops-demo.html  
Actually based on slack and hubot and automation content (ansible, python, jinja2 ...) for junos automation  

#### Bot capabilties:
You can use slack delegate tasks to the bot.  
The bot can: 
- execute junos commands (set/delete/show) on junos devices  
- load configuration based on a jinja2 template on junos devices  
- apply a playbook to junos devices   
- roll back the junos configuration on junos devices  
- backup locally the configuration of junos devices  
- Manage bgp neighbors (add a neighbor, remove a neighbor, audit a neighbor session) on a junos device   
- Execute a python script  

It is easily extensible.    

#### Syntax: 
Here’s the chat syntax to delegate tasks to the bot, with some help:  
- **myhubot target \<target> set \<junos_command>** - Execute a junos set command on device/group \<target>
- **myhubot target \<target> delete \<junos_command>** - Execute a junos delete command on device/group \<target>
- **myhubot target \<target> rollback \<rb_id>** - Rollback \<rb_id> the configuration of device/group \<target>
- **myhubot target \<target> template \<template>** - Backup the configuration of device/group \<target>, and apply the jinja2 template \<template> to the device/group \<target>
- **myhubot target \<target> backup** - Backup the configuration of the device/group \<target>
- **myhubot target \<target> show \<junos_command>** - Execute a junos show command on device/group \<target> and print the command output
- **myhubot target \<target> playbook \<playbook>** - Execute the ansible playbook \<playbook> on device/group \<target>
- **hubot list playbooks** - Print the list of Ansible playbooks
- **hubot list templates** - Print the list of Jinja2 templates
- **hubot display <file>** - Print an Ansible file (playbook, template, ...)

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

