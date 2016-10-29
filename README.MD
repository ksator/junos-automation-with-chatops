### What to find on this repo:  
Chatops for network engineers.  
Initially inspired by this demo https://www.dravetech.com/blog/2016/03/30/chatops-demo.html  
Actually based on slack and hubot and automation content (ansible playbooks, python scripts, jinja2 templates ...) for junos automation  

### Bot capabilties:
You can use slack to delegate these tasks to the bot: 
- execute a junos command (set/delete/show) on junos devices  
- roll back the junos configuration on junos devices  
- backup locally the configuration of junos devices  
- Manage bgp neighbors (add a neighbor, remove a neighbor, audit a neighbor session) on a junos device   
- load on junos devices a configuration based on a jinja2 template on junos devices  
- apply a playbook to junos devices   
- Execute a python script  

This is easily extensible to other tasks.    


### How does it work: 
Hubot executes all the scripts defined into the directory [**scripts**](https://github.com/ksator/chatops_junos/blob/master/scripts).    

The dictionnary for network automation is the file [**junos_automation.coffee**] (https://github.com/ksator/chatops_junos/blob/master/scripts/junos_automation.coffee).  
This is where we define the various actions the bot has to take based on the slack messages in the chat room.  

The bot is configured to execute the automation content (Ansible playbooks, python scripts ...) defined into the directory [**automation_content**] (https://github.com/ksator/chatops_junos/tree/master/automation_content)

So, as example, the slack message:   
```
@hubot_name dev=<target> template <template>   
```
or
```
hubot_name dev=<target> template <template>
```
triggers the ansible playbook [**pb.template.yml**](https://github.com/ksator/chatops_junos/blob/master/ansible/pb.template.yml) with some variable definitions (using the --extra-vars option to pass the variables definition to the playbook):   
Actually, the bot will execute this command:  
```
ansible-playbook $PWD/automation_content/pb.template.yml --extra-vars = "{'device': <target>, 'template': <template>}"
```
Which is the equivalent of: 
```
ansible-playbook $PWD/automation_content/pb.template.yml --extra-vars "device=<target> template=<template>"  
```

### Chat syntax: 
Here’s the chat syntax to delegate tasks to the bot:  

Notes: \<target> is a device or a group of devices. The value for \<target> has to exist in the ansible inventory [**hosts**] (https://github.com/ksator/chatops_junos/blob/master/automation_content/hosts) file.   

- Backup the configuration of \<target>.   
It run under the hood the playbook [**pb.backup.yml**](https://github.com/ksator/chatops_junos/tree/master/automation_content/pb.backup.yml) with the variable \<target>. 
```
@hubot_name dev=<target> backup 
```
- Rollback \<rb_id> the configuration of \<target>.  
Run under the hood the playbook [**pb.rollback.yml**](https://github.com/ksator/chatops_junos/tree/master/automation_content/pb.rollback.yml) with the variables \<target> and \<rb_id>.
```
@hubot_name dev=<target> rollback <rb_id>
```
- Execute a Junos set command on \<target>.  
Run under the hood the playbook [**pb.config.yml**](https://github.com/ksator/chatops_junos/tree/master/automation_content/pb.config.yml) with the variables \<target> and \<command>.  
Add "--diff" to display the differences, add "--check" for a dry run.  
```
@hubot_name dev=<target> set <command>
```
- Execute a Junos delete command on \<target>.  
Run under the hood the playbook [**pb.config.yml**](https://github.com/ksator/chatops_junos/tree/master/automation_content/pb.config.yml) with the variables \<target> and \<command>.
```
@hubot_name dev=<target> delete <command>
```
- Execute a Junos show command on \<target> and print the command output.  
Run under the hood the playbook [**pb.command.yml**](https://github.com/ksator/chatops_junos/tree/master/automation_content/pb.command.yml) with the variables \<target> anc \<command>.  
You can use "show" or "sh".  
```
@hubot_name dev=<target> show <command>
```
- Configure an ebgp neighbor on the device \<target>.  
Run under the hood the playbook [**pb.add.ebgp.yml**](https://github.com/ksator/chatops_junos/tree/master/automation_content/pb.add.ebgp.yml) with the variables \<target> and \<peer_ip> and \<peer_asn>.  
You can use "neighbor" or "neigh".  
Add "--diff" to display the differences, add "--check" for a dry run.  
```
@hubot_name dev=<target> add bgp neighbor <peer_ip> as <peer_asn>
```
- Retrieve on the device \<target> the bgp state for the neighbor \<peer_ip>, and print it.  
Run under the hood the playbook [**pb.check.bgp.yml**](https://github.com/ksator/chatops_junos/tree/master/automation_content/pb.check.bgp.yml) with the variables \<target> and \<peer_ip>  
```
@hubot_name dev=<target> get bgp state <peer_ip>
```
- Delete an existing ebgp neighbor on the device \<target>.  
Run under the hood the playbook [**pb.remove.ebgp.yml**](https://github.com/ksator/chatops_junos/tree/master/automation_content/pb.remove.ebgp.yml) with the variables \<target> and \<peer_ip>  
You can use "remove" or "rm", you can use "neighbor" or "neigh".   
```
@hubot_name dev=<target> remove bgp neighbor <peer_ip>
```
- Backup the configuration of \<target>, and apply the jinja2 template \<template> to \<target>.  
Run under the hood the playbook [**pb.template.yml**](https://github.com/ksator/chatops_junos/tree/master/automation_content/pb.template.yml) with the variables \<target> and \<template>. 
The jinja2 template \<template> has to be defined into the directory [**automation_content**] (https://github.com/ksator/chatops_junos/blob/master/automation_content).   
Add "--diff" to display the differences, add "--check" for a dry run.  
```
@hubot_name dev=<target> template <template>
```
- Execute the Ansible playbook \<playbook> on \<target>.  
The Ansible playbook \<playbook> has to be defined into the directory [**automation_content**] (https://github.com/ksator/chatops_junos/blob/master/automation_content).  
Add "--diff" to display the differences, add "--check" for a dry run.
```
@hubot_name dev=<target> playbook <playbook>
```
- Execute the python script \<script> and print the program output  
The python script has to be defined into the directory [**automation_content**] (https://github.com/ksator/chatops_junos/blob/master/automation_content).  
```
@hubot_name python <script>
```
- Print the list of Ansible playbooks defined into the directory [**automation_content**] (https://github.com/ksator/chatops_junos/blob/master/automation_content).  
You can use "list" or "ls"
```
@hubot_name list playbooks
```
- Print the list of Jinja2 templates defined into the directory [**automation_content**] (https://github.com/ksator/chatops_junos/blob/master/automation_content).    
You can use "list" or "ls"
```
@hubot_name list templates
```
- Print the list of Python scripts defined into the directory [**automation_content**] (https://github.com/ksator/chatops_junos/blob/master/automation_content).  
You can use "list" or "ls"
```
@hubot_name list python scripts
```
- Print a file (playbook, template, python scripts ...) defined in the directory [**automation_content**] (https://github.com/ksator/chatops_junos/blob/master/automation_content)    
You can use "show" or "sh"
```
@hubot_name show <file>
```
- Print the [**hosts**] (https://github.com/ksator/chatops_junos/blob/master/automation_content/hosts) file (It has the valid values for \<target>)    
You can use "show" or "sh"
```
@hubot_name show hosts
```

### Usage examples:   

To get the help: 
```
@j-bot help
@j-bot help bgp
```

To pass a junos command (set/show/delete) to devices: 
```
@j-bot show hosts
@j-bot dev=MX240-04 set interfaces xe-1/0/0 description newdesc
@j-bot dev=MX240-04 show interfaces descriptions
@j-bot dev=MX240-04 set interfaces xe-1/0/0 description anotherdesc --check --diff
@j-bot dev=MX240-04 delete interfaces xe-1/0/0 description
```

To roll back the junos configuration on devices:  
```
@j-bot dev=all set system login message newbanner --check
@j-bot dev=all set system login message newbanner --diff
@j-bot dev=all rollback 1
```

To backup locally the configuration of all devices:
```
@j-bot dev=all backup
```

To manage bgp neighbors (add/audit/remove bgp neighbors) on devices:  
```
@j-bot help bgp
@j-bot dev=FR-MX80-214 add bgp neighbor 10.10.0.1 as 65001 --check --diff
@j-bot dev=FR-MX80-214 add bgp neighbor 10.10.0.1 as 65001
@j-bot dev=MX240-04 add bgp neigh 10.10.0.2 as 65000 --check 
@j-bot dev=MX240-04 add bgp neigh 10.10.0.2 as 65000 --diff
@j-bot dev=MX240-04 get bgp state 10.10.0.2
@j-bot dev=MX240-04 remove bgp neighbor 10.10.0.2
@j-bot dev=FR-MX80-214 rm bgp neighbor 10.10.0.1
```
To execute a python script: 
```
@j-bot list python scripts
@j-bot show get_facts.py
@j-bot python get_facts.py
```
To execute an Ansible playbook: 
```
@j-bot list playbooks
@j-bot show pb.check.physical.topology.yml
@j-bot show hosts
@j-bot dev=FR-MX80-214 playbook pb.check.physical.topology.yml
@j-bot dev=FR-MX80-214 playbook pb.ping.yml
```
To load on junos devices a configuration based on a jinja2 template 
```
@j-bot help template 
@j-bot ls templates
@j-bot show openconfig_bgp.j2
@j-bot show hosts
@j-bot dev=Openconfig_Routers template openconfig_bgp.j2 --check
@j-bot dev=MX240-04 template openconfig_bgp.j2 --check --diff
@j-bot dev=Openconfig_Routers template openconfig_bgp.j2
@j-bot dev=FR-MX80-214 show bgp summary 
@j-bot dev=Openconfig_Routers rollback 1
```

### The steps to reproduce are: 
-	create a slack team (https://slack.com/) 
-	Invite some peoples (humans) 
-	Optionally, integrate some tools into some channels of this slack team.  
Github, Ansible, Travis CI, ... can send slack notifications. So you can receive slack notifications on these channels from Github (each time there is a change on your github repositories), from TravisCI (each time it will finish to run its tests), from Ansible (if you use the [slack notification module](http://docs.ansible.com/ansible/slack_module.html) in your playbooks. Here's an [example](https://github.com/ksator/chatops_junos/blob/master/automation_content/pb.add.ebgp.yml)).
-	Install hubot (I installed it on an ubuntu 14.04 VM) 
-	Integrate your bot in your slack team  
- the slack status for the bot should appear as "away" in the chat room
-	Create some automation content. You can do it on the same VM that has the bot, so the bot doesnt need to use API to consume the automation content. My automation content is based on Ansible and Python: https://github.com/ksator/chatops_junos/tree/master/automation_content. Install the automation tools (Ansible, python libraries ...) required to execute your automation content.   
-	Create a script that tell your bot what to do based on the slack messages in the chat room. Here’s my dictionnary https://github.com/ksator/chatops_junos/blob/master/scripts/junos_automation.coffee.  
- launch the bot, with a slack adaptor, and the token generated when you integrated the bot to the slack team: 
```
ksator@ubuntu:~/myhubot$ HUBOT_SLACK_TOKEN=xoxb-90946701733-BTJh5QnUdQrTMcbtjgawmvjo ./bin/hubot -a slack
```
- the slack status for the bot should now appear as "active" in the chat room! 
- Send slack messages to your bot in order to delegate tasks to him :-)


### Contributions, bugs, questions, suggestions, enhancement requests
They are more than welcome. Please submit github issues or pull requests. 

