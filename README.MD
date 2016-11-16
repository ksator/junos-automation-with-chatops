### About this repo:  
This repository is about Chatops for network engineers  
I was initially inspired by this demo https://www.dravetech.com/blog/2016/03/30/chatops-demo.html  
The repo is actually based on slack and hubot and content for junos automation (ansible playbooks, python scripts, jinja2 templates ...).   
So you can delegate junos automation tasks chatting to hubot with slack.  

### What to find on this repo  
You will find into this repo: 
- How to use the bot  
  - [Bot capabilities](https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/README.MD#bot-capabilities)
  - [How does it work](https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/README.MD#how-does-it-work)
  - [Chat syntax](https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/README.MD#chat-syntax)
  - [Usage examples](https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/README.MD#usage-examples)
- The [installation instructions](https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/README.MD#installation-instructions) if you want to install it yourself, and [dockerfile](https://github.com/ksator/junos-automation-with-chatops-in-ams/tree/master/dockerfile) if you prefer [a dockerized and slack integrated hubot for Junos automation](https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/README.MD#a-dockerized-and-slack-integrated-hubot-for-junos-automation)  
- The [bot dictionnary](https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/scripts/junos_automation.coffee). It defines the bot actions based on chat messages (Hubot scripts are written in CoffeeScript, and have to live in the "scripts" directory).   
- the [network automation content](https://github.com/ksator/junos-automation-with-chatops-in-ams/tree/master/automation_content) the bot uses (python scripts, ansible playbooks, jinja2 templates ...)  

### Bot capabilities:
So far you can use slack to delegate the following tasks to the bot:
- execute a junos command (set/delete/show) on junos devices  
- roll back the junos configuration on junos devices  
- backup locally the configuration of junos devices  
- Manage bgp neighbors (add a neighbor, remove a neighbor, audit a neighbor session) on a junos device   
- load on junos devices a configuration based on a jinja2 template on junos devices  
- apply a playbook to junos devices   
- Execute a python script  

This is easily extensible to other tasks. You just need to create more automation content, and then you need to update the bot dictionnary.     

### How does it work: 

##### Hubot scripts
Hubot scripts are written in CoffeeScript.    
Hubot executes all the scripts defined into the directory [**scripts**](https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/scripts).    
The dictionnary for network automation is the file [**junos_automation.coffee**] (https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/scripts/junos_automation.coffee).  
This is where we define the various actions the bot has to take based on the slack messages in the chat room.  

##### Automation content
The bot is configured to execute the automation content (Ansible playbooks, python scripts ...) defined into the directory [**automation_content**] (https://github.com/ksator/junos-automation-with-chatops-in-ams/tree/master/automation_content)

##### Example
So, as example, the slack message:   
```
@hubot_name dev=<target> template <template>   
```
or
```
hubot_name dev=<target> template <template>
```
configures the device (or the group of devices) \<target> with the template \<template>.  
Actually, this slack message triggers the ansible playbook [**pb.template.yml**](https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/ansible/pb.template.yml) with some variable definitions (using the --extra-vars option to pass the variables definition to the playbook):   
The bot will execute this command:  
```
ansible-playbook $PWD/automation_content/pb.template.yml --extra-vars = "{'device': <target>, 'template': <template>}"
```
Which is the equivalent of: 
```
ansible-playbook $PWD/automation_content/pb.template.yml --extra-vars "device=<target> template=<template>"  
```

### Chat syntax: 
Here’s the chat syntax to delegate tasks to the bot:  

Notes: \<target> can refer to a device or to a group of devices. The value for \<target> in the chat messages has to be define in the  [**hosts**] (https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/automation_content/hosts) file (this is the ansible inventory).     

##### Backup the configuration of \<target>
It run under the hood the playbook [**pb.backup.yml**](https://github.com/ksator/junos-automation-with-chatops-in-ams/tree/master/automation_content/pb.backup.yml) with the variable \<target>. 
```
@hubot_name dev=<target> backup 
```
##### Rollback \<rb_id> the configuration of \<target>
Run under the hood the playbook [**pb.rollback.yml**](https://github.com/ksator/junos-automation-with-chatops-in-ams/tree/master/automation_content/pb.rollback.yml) with the variables \<target> and \<rb_id>.
```
@hubot_name dev=<target> rollback <rb_id>
```
##### Execute a Junos set command on \<target> 
Run under the hood the playbook [**pb.config.yml**](https://github.com/ksator/junos-automation-with-chatops-in-ams/tree/master/automation_content/pb.config.yml) with the variables \<target> and \<command>.  
Add "--diff" to display the differences, add "--check" for a dry run.  
```
@hubot_name dev=<target> set <command>
```
##### Execute a Junos delete command on \<target> 
Run under the hood the playbook [**pb.config.yml**](https://github.com/ksator/junos-automation-with-chatops-in-ams/tree/master/automation_content/pb.config.yml) with the variables \<target> and \<command>.
```
@hubot_name dev=<target> delete <command>
```
##### Execute a Junos show command on \<target> and print the command output  
Run under the hood the playbook [**pb.command.yml**](https://github.com/ksator/junos-automation-with-chatops-in-ams/tree/master/automation_content/pb.command.yml) with the variables \<target> anc \<command>.  
You can use "show" or "sh".  
```
@hubot_name dev=<target> show <command>
```
##### Configure an ebgp neighbor on the device \<target>  
Run under the hood the playbook [**pb.add.ebgp.yml**](https://github.com/ksator/junos-automation-with-chatops-in-ams/tree/master/automation_content/pb.add.ebgp.yml) with the variables \<target> and \<peer_ip> and \<peer_asn>.  
You can use "neighbor" or "neigh".  
Add "--diff" to display the differences, add "--check" for a dry run.  
```
@hubot_name dev=<target> add bgp neighbor <peer_ip> as <peer_asn>
```
##### Retrieve on the device \<target> the bgp state for the neighbor \<peer_ip>, and print it 
Run under the hood the playbook [**pb.check.bgp.yml**](https://github.com/ksator/junos-automation-with-chatops-in-ams/tree/master/automation_content/pb.check.bgp.yml) with the variables \<target> and \<peer_ip>  
```
@hubot_name dev=<target> get bgp state <peer_ip>
```
##### Delete an existing ebgp neighbor on the device \<target>  
Run under the hood the playbook [**pb.remove.ebgp.yml**](https://github.com/ksator/junos-automation-with-chatops-in-ams/tree/master/automation_content/pb.remove.ebgp.yml) with the variables \<target> and \<peer_ip>  
You can use "remove" or "rm", you can use "neighbor" or "neigh".   
```
@hubot_name dev=<target> remove bgp neighbor <peer_ip>
```
##### Backup the configuration of \<target>, and apply the jinja2 template \<template> to \<target>  
Run under the hood the playbook [**pb.template.yml**](https://github.com/ksator/junos-automation-with-chatops-in-ams/tree/master/automation_content/pb.template.yml) with the variables \<target> and \<template>. 
The jinja2 template \<template> has to be defined into the directory [**automation_content**] (https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/automation_content).   
Add "--diff" to display the differences, add "--check" for a dry run.  
```
@hubot_name dev=<target> template <template>
```
##### Execute the Ansible playbook \<playbook> on \<target>  
The Ansible playbook \<playbook> has to be defined into the directory [**automation_content**] (https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/automation_content).  
Add "--diff" to display the differences, add "--check" for a dry run.
```
@hubot_name dev=<target> playbook <playbook>
```
##### Execute the python script \<script> and print the program output  
The python script has to be defined into the directory [**automation_content**] (https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/automation_content).  
```
@hubot_name python <script>
```
##### Print the list of Ansible playbooks defined into the directory [**automation_content**] (https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/automation_content).  
You can use "list" or "ls"
```
@hubot_name list playbooks
```
##### Print the list of Jinja2 templates defined into the directory [**automation_content**] (https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/automation_content).    
You can use "list" or "ls"
```
@hubot_name list templates
```
##### Print the list of Python scripts defined into the directory [**automation_content**] (https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/automation_content).  
You can use "list" or "ls"
```
@hubot_name list python scripts
```
##### Print a file (playbook, template, python scripts ...) defined in the directory [**automation_content**] (https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/automation_content)    
You can use "show" or "sh"
```
@hubot_name show <file>
```
##### Print the [**hosts**] (https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/automation_content/hosts) file (It has the valid values for \<target>)    
You can use "show" or "sh"
```
@hubot_name show hosts
```

### Usage examples:   

##### To get the help: 
```
@j-bot help
```
```
@j-bot help bgp
```
##### To pass a junos command (set/show/delete) to devices: 
```
@j-bot show hosts
```
```
@j-bot dev=leaf-04 set interfaces xe-1/0/0 description newdesc
@j-bot dev=leaf-04 show interfaces descriptions
@j-bot dev=leaf-04 set interfaces xe-1/0/0 description anotherdesc --check --diff
@j-bot dev=leaf-04 delete interfaces xe-1/0/0 description
```
##### To roll back the junos configuration on devices:  
```
@j-bot dev=all set system login message newbanner --check
@j-bot dev=all set system login message newbanner --diff
@j-bot dev=all rollback 1
```
##### To backup locally the configuration of all devices:
```
@j-bot dev=all backup
```
##### To manage bgp neighbors (add/audit/remove bgp neighbors) on devices:  
```
@j-bot help bgp
```
```
@j-bot dev=leaf-03 add bgp neighbor 172.16.0.28 as 65014 --check --diff
@j-bot dev=leaf-03 add bgp neighbor 172.16.0.28 as 65014
```
```
@j-bot dev=spine-04 add bgp neigh 172.16.0.29 as 65023 --check 
@j-bot dev=spine-04 add bgp neigh 172.16.0.29 as 65023 --diff
```
```
@j-bot dev=spine-04 get bgp state 172.16.0.29
```
```
@j-bot dev=leaf-03 remove bgp neighbor 172.16.0.28
@j-bot dev=spine-04 rm bgp neighbor 172.16.0.29
```
##### To execute a python script: 
```
@j-bot list python scripts
@j-bot show get_facts.py
@j-bot python get_facts.py
```
##### To execute an Ansible playbook: 
```
@j-bot list playbooks
@j-bot show pb.check.interfaces.yml
@j-bot sh pb.conf.bgp.oc.yml
@j-bot show hosts
@j-bot dev=fabric playbook pb.check.interfaces.yml
@j-bot dev=fabric playbook pb.conf.bgp.oc.yml
```
##### To load on junos devices a configuration based on a jinja2 template 
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

### Installation instructions: 
This section provides the details for each step if you want to install everything yourself.  
The next section [(a dockerized and slack integrated hubot for junos automation)](https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/README.MD#a-dockerized-and-slack-integrated-hubot-for-junos-automation) is about using docker to get most of this. 

- Install hubot  
  - I installed it on an ubuntu 14.04 VM  following the below steps:   
    - Install node.js and npm (npm is the package manager for JavaScript) 
    ```
    curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
    sudo apt-get install -y nodejs
    node -v
    ```    
    - Update npm   
    ```
    sudo npm install npm@latest -g
    npm -v
    ```    
    - Install the hubot generator
    ```
    sudo npm install -g yo generator-hubot
    ```
    - Create a new directory (call him hubot)
    ``` 
    mkdir hubot
    ```
    - move to the new directory and generate a new instance of hubot running the command "yo hubot".  
    if you prefer to automate your hubot build without being interactively prompted for its configuration, you can add the following
    options to the "yo hubot" command.
    ```
    cd hubot
    yo hubot --owner="your name <user@email.com>" --name="j-bot" --description="Junos automation" --adapter="slack" --defaults
    ```
    - So you have now a hubot called j-bot, with a slack adapter. 
- Install the automation tools (Ansible, python libraries ...) required to execute your automation content.  
You can do it on the same VM that has the bot, so the bot doesnt need to use API to consume the automation content.   
Here's the instructions to install some Python libraries for Junos automation (PyEZ, jsnapy, junos-netconify) and Ansible and the Ansible roles for Junos.  
```
sudo apt-get update 
sudo apt-get install -y python-dev libxml2-dev python-pip libxslt1-dev build-essential libssl-dev libffi-dev 
sudo pip install cryptography==1.2.1 junos-eznc==1.3.1 jxmlease junos-netconify jsnapy requests ipaddress ansible==2.1.0.0
sudo ansible-galaxy install Juniper.junos
```
-	Create your automation content.  
You can do it on the same VM that has the bot, so the bot doesnt need to use API to consume the automation content.   
My automation content is based on Ansible and Python: https://github.com/ksator/junos-automation-with-chatops-in-ams/tree/master/automation_content.   
-	Create a script (the bot dictionnary) that tell your bot what to do based on the slack messages in the chat room. It has to live in the directory "scripts".    
Here’s the dictionnary I am using https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/scripts/junos_automation.coffee.  
- if you want to interact with your bot locally (i.e with the shell adapter, instead of the slack adaptor) (useful for testing), you can run this command: 
```
bin/hubot
j-bot> j-bot help
j-bot> j-bot help bgp
j-bot> j-bot dev=AMS-all backup
j-bot> exit
```
- create a slack team (https://slack.com/) 
-	Optionally, invite humans to the slack team 
-	Optionally, integrate some tools into various channels of this slack team.  
Github, Ansible, Travis CI, ... can send slack notifications. So you can receive slack notifications on channels from Github (each time there is a change on your github repositories), from TravisCI (each time it will finish to run its tests), from Ansible (if you use the [ansible slack notification module](http://docs.ansible.com/ansible/slack_module.html) in your playbooks. Here's an [example](https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/automation_content/pb.add.ebgp.yml)).
-	Integrate your bot in your slack team  
- the bot should now appear in the chat room. its slack status should appear as "away" in the chat room. 
- launch the bot, with a slack adaptor, and the token generated when you integrated the bot to the slack team: 
```
HUBOT_SLACK_TOKEN=xxxxxxxxxx ./bin/hubot -a slack
```
- the slack status for the bot should now appear as "active" in the chat room! 
- Send slack messages to your bot in order to delegate tasks to him :-)

### A dockerized and slack integrated hubot for Junos automation
There is a [dokerfile](https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/dockerfile) at the root of the repository.   
It has the details: 
- to install hubot and its requirements (nodejs, npm ...) 
- to install some tools for junos automation (ansible, python libraries ...)   
- to configure the bot 

So this simplifies and automates part of the [installation instructions](https://github.com/ksator/junos-automation-with-chatops-in-ams/blob/master/README.MD#installation-instructions) in the above section. 
- You still need to manually create a slack team, and integrate your bot in your slack team.      

Requirements: 
- you need git and docker on your laptop.   

Here's the instructions to use it:  
- clone locally the repository
```
git clone https://github.com/ksator/junos-automation-with-chatops-in-ams.git
```
- move to your local repository
```
cd junos-automation-with-chatops
```
- adapt your local repository to match your network settings (devices ip @, credentials, ...)
  - The **automation_content** directory has:
    - The ansible **hosts** inventory file.  
    You need to change this file in order to use the ip addresses of your network.   
    - the ansible variables definition under the directories **host_vars** and **group_var**.  
    You need to change the files under the directories **host_vars** and **group_var** to define the variables that match your network settings (device credentials ....). 
    - the ansible playbooks.  
    it is not required to change them. 
    - the jinja2 templates.  
    it is not required to change them.  
    - the python scripts.  
    some variables are hard coded inside the python script (devices ip @ and device credentials), you need to change them to match your network settings.    
  - The hubot coffeescript are in the **scripts** directory (the script I am using to educate the bot is **junos_automation.coffee**).   
  it is not required to change it. 
  - The **ansible.cfg** (ansible configuration file) is at the root of the repository.   
  it is not required to change it. 
  - The **dockerfile** is ta the root of the repository.  
  it is not required to change it. 
- create a docker image based on the local dockerfile
```
docker build -t j-bot-image .
```
- Instanciate the docker image to get a container. Use the following options: 
  - -e to set the environement variable HUBOT_SLACK_TOKEN with the token provided by slack when you integrated the bot to the slack team
  - -v to add a data volume to the container. Your local **automation_content** directory will be mounted to the diretory **automation_content** in the container.
  - -d to run the container in background and print container ID
```
docker run -v $PWD/automation_content:/hubot/automation_content -e HUBOT_SLACK_TOKEN=xxxxxxxxxxxxxxxx -d j-bot-image
```

### Road map
- Travis CI notification settings encryption https://docs.travis-ci.com/user/encryption-keys/ (to not show the slack token in clear text in the .travis.yml file)
- add Hubot permissions/roles (chatops access control with hubot-auth)
- remove hardcoded details from the python script

### Contributions, bugs, questions, suggestions, enhancement requests
They are more than welcome. Please submit github issues or pull requests. 


