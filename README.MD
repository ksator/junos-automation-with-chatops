#### What to find on this repo:  
Chatops for network engineers.  
Based on slack and hubot and ansible for junos automation  
Initially inspired by this demo https://www.dravetech.com/blog/2016/03/30/chatops-demo.html  

#### Bot capabilties:
The bot can execute junos commands (set/delete/show) to a device or a group of devices.  
It can also backup the junos configuration, rollback the junos configuration, load a jinja2 template, apply a playbook to junos devices.  
This is easily extensible.    

#### Syntax: 
Here’s the chat syntax, with some help:  
- **myhubot set \<junos_command> on dev \<target>** - Execute a junos set command on device/group \<target>
- **myhubot delete \<junos_command> on dev \<target>** - Execute a junos delete command on device/group \<target>
- **myhubot rollback \<rb_id> on dev \<target>** - Rollback \<rb_id> the configuration of device/group \<target>
- **myhubot template \<template> on dev \<target>** - Backup the configuration of device/group \<target>, and apply the template \<template> to the device/group \<target>
- **myhubot backup on dev \<target>** - Backup the configuration of the device/group \<target>
- **myhubot show \<junos_command> on dev \<target>** - Execute a junos show command on device/group \<target> and print the command output
- **myhubot playbook \<playbook> on dev \<target>** - Execute the playbook \<playbook> on device/group \<target>

Note: \<target> is a device or a group of devices. \<target> has to exist in the ansible inventory file (https://github.com/ksator/chatops_junos/blob/master/ansible/hosts).   

##### Chat examples:   
```
@myhubot help
@myhubot help template

@myhubot template openconfig_bgp.j2 on dev Openconfig_Routers
@myhubot show bgp summary on dev FR-MX80-214
@myhubot rollback 1 on dev Openconfig_Routers

@myhubot backup on dev all

@myhubot set system login message newbanner on dev MX240-04
@myhubot delete system login message newbanner on dev MX240-04

@myhubot playbook pb.check.physical.topology.yml on dev FR-MX80-214
```


#### How does it work: 
The bot configuration is this file: https://github.com/ksator/chatops_junos/blob/master/scripts/junos.coffee. This is where we define the various actions the bot has to take based on the slack messages in the chat room.  So the bot is configured to execute Ansible playbooks.   

The bot uses Ansible under the hood. Here's the Ansible content (playbooks, variables, inventory ....) https://github.com/ksator/chatops_junos/tree/master/ansible   

So, as example, the slack message:   
```
myhubot template <X> on dev <Y>   
```
or
```
@myhubot template <X> on dev <Y>   
```
triggers the ansible playbook [**pb.template.yml**](https://github.com/ksator/chatops_junos/blob/master/ansible/pb.template.yml) with some variable definitions (using the --extra-vars option to pass the variables definition to the playbook):   
Actually, the bot will execute this command:  
```
ansible-playbook $PWD/ansible/pb.template.yml --extra-vars = "{'device': <Y>, 'template': <X>}"
```
Which is the equivalent of: 
```
ansible-playbook $PWD/ansible/pb.template.yml --extra-vars "device=<Y> template=<X>"  
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
#### Project road map
I will add permissions (otherwise anyone in the chat room can execute automation content on a live network just chatting with a bot …).   
I will also add more automation content. 

#### Contributions, bugs, questions, suggestions, enhancement requests
They are more than welcome. Please submit github issues or pull requests. 

