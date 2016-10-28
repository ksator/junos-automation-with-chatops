### What to find on this repo:  
Chatops for network engineers.  
Initially inspired by this demo https://www.dravetech.com/blog/2016/03/30/chatops-demo.html  
Actually based on slack and hubot and automation content (ansible playbooks, python scripts, jinja2 templates ...) for junos automation  

### Bot capabilties:
You can use slack to delegate these tasks to the bot: 
- execute a junos command (set/delete/show) on junos devices  
- load a configuration data based on a jinja2 template on junos devices  
- apply a playbook to junos devices   
- roll back the junos configuration on junos devices  
- backup locally the configuration of junos devices  
- Manage bgp neighbors (add a neighbor, remove a neighbor, audit a neighbor session) on a junos device   
- Execute a python script  

This is easily extensible.    

### Chat syntax: 
Here’s the chat syntax to delegate tasks to the bot:  

Notes: \<target> is a device or a group of devices. The value \<target> has to be exist in the ansible inventory [**hosts**] (https://github.com/ksator/chatops_junos/blob/master/automation_content/hosts) file.   

- Backup the configuration of \<target>.   
It run under the hood the playbook [**pb.backup.yml**](https://github.com/ksator/chatops_junos/tree/master/automation_content/pb.backup.yml) with the variable \<target>. 
```
@hubot_name dev=<target> backup 
```
- Execute a Junos delete command on \<target>.  
It run under the hood the playbook [**pb.config.yml**](https://github.com/ksator/chatops_junos/tree/master/automation_content/pb.config.yml) with the variables \<target> and \<command>.
```
@hubot_name dev=<target> delete <command>
```
- Rollback \<rb_id> the configuration of \<target>.  
It run under the hood the playbook [**pb.rollback.yml**](https://github.com/ksator/chatops_junos/tree/master/automation_content/pb.rollback.yml) with the variables \<target> and \<rb_id>.
```
@hubot_name dev=<target> rollback <rb_id>
```
- Execute a Junos set command on \<target>.  
It run under the hood the playbook [**pb.config.yml**](https://github.com/ksator/chatops_junos/tree/master/automation_content/pb.config.yml) with the variables \<target> and \<command>.  
Add "--diff" to display the differences, add "--check" for a dry run.  
```
@hubot_name dev=<target> set <command>
```
- Execute a Junos show command on \<target> and print the command output.  
It run under the hood the playbook [**pb.command.yml**](https://github.com/ksator/chatops_junos/tree/master/automation_content/pb.command.yml) with the variables \<target> anc \<command>.  
You can use "show" or "sh".  
```
@hubot_name dev=<target> show <command>
```
- Backup the configuration of \<target>, and apply the jinja2 template \<template> to \<target>.  
It run under the hood the playbook [**pb.template.yml**](https://github.com/ksator/chatops_junos/tree/master/automation_content/pb.template.yml) with the variables \<target> and \<template>. 
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
- Configure an ebgp neighbor on the device \<target>.  
It run under the hood the playbook [**pb.add.ebgp.yml**](https://github.com/ksator/chatops_junos/tree/master/automation_content/pb.add.ebgp.yml) with the variables \<target> and \<peer_ip> and \<peer_asn>.  
You can use "neighbor" or "neigh".  
Add "--diff" to display the differences, add "--check" for a dry run.  
```
@hubot_name dev=<target> add bgp neighbor <peer_ip> as <peer_asn>
```
- Retrieve on the device \<target> the bgp state for the neighbor \<peer_ip>, and print it.  
It run under the hood the playbook [**pb.check.bgp.yml**](https://github.com/ksator/chatops_junos/tree/master/automation_content/pb.check.bgp.yml) with the variables \<target> and \<peer_ip>  
```
@hubot_name dev=<target> get bgp state <peer_ip>
```
- Delete an existing ebgp neighbor on the device \<target>.  
It run under the hood the playbook [**pb.remove.ebgp.yml**](https://github.com/ksator/chatops_junos/tree/master/automation_content/pb.remove.ebgp.yml) with the variables \<target> and \<peer_ip>  
You can use "remove" or "rm", you can use "neighbor" or "neigh".   
```
@hubot_name dev=<target> remove bgp neighbor <peer_ip>
```
- Print a file (playbook, template, python scripts ...) defined in the directory [**automation_content**] (https://github.com/ksator/chatops_junos/blob/master/automation_content)    
You can use "show" or "sh"
```
@hubot_name show <file>
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
- Execute the python script \<script> and print the program output  
The python script has to be defined into the directory [**automation_content**] (https://github.com/ksator/chatops_junos/blob/master/automation_content).  
```
@hubot_name python <script>
```

### Examples:   
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

### How does it work: 
Hubot executes the scripts defined into the directory [**scripts**](https://github.com/ksator/chatops_junos/blob/master/scripts).    

The dictionnary is the file [junos.coffee] (https://github.com/ksator/chatops_junos/blob/master/scripts/junos.coffee).  
This is where we define the various actions the bot has to take based on the slack messages in the chat room.  

The bot is configured to execute the automation content (Ansible playbooks, python scripts ...) defined into the directory[** automation_content**] (https://github.com/ksator/chatops_junos/tree/master/automation_content)

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

### The steps to reproduce are: 
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

### Contributions, bugs, questions, suggestions, enhancement requests
They are more than welcome. Please submit github issues or pull requests. 

