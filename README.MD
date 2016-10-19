#### What to find on this repo 
chatops for network engineers: slack and hubot and ansible for junos automation

#### bot capabilties 
The bot can execute junos commands (set/delete/show) to a device or a group of devices. It can also backup the junos configuration, rollback the junos configuration, load a jinja2 template, apply a playbook to junos devices.  
It uses Ansible under the hood.   
Here’s the syntax ( \<Y> has to exist in the ansible inventory file, it could be an endpoint or a group) with some help: 
- **myhubot set \<X> on dev \<Y>** - Execute a junos set command on device/group \<Y>
- **myhubot delete \<X> on dev \<Y>** - Execute a junos delete command on device/group \<Y>
- **myhubot rollback \<id> on dev \<Y>** - Rollback <id> the configuration of device/group \<Y>
- **myhubot template \<X> on dev \<Y>** - Backup the configuration of device/group \<Y>, and apply the template \<X> to the device/group \<Y>
- **myhubot backup on dev \<Y>** - Backup the configuration of the device/group \<Y>
- **myhubot show \<X> on dev \<Y>** - Execute a junos show command on device/group \<Y> and print the command output
- **myhubot playbook \<X> on dev \<Y>** - Execute the playbook <X> on device/group \<Y>

#### The steps to reproduce are: 
-	create a slack team  
-	Optionally, integrate some tools into some channels of this slack team (some of my github repositories have a webhook to slack, some of my .travis.yml send slack notifications. So from these channels I receive notifications from github and TravisCI). 
-	Invite some peoples 
-	Install hubot (I am using it on an ubuntu 14.04 VM) 
-	Invite your bot 
-	Create some automation content (on the same VM that has the bot, so the bot dosent need to use API to consume the automation content). My automation content is based on Ansible: https://github.com/ksator/chatops_junos/tree/master/ansible . 
- Optionally, you can also use the slack notification module in the Ansible playbooks (here's an https://github.com/ksator/chatops_junos/blob/master/ansible/pb.template.yml)    
-	Create a script that tell your bot what to do based on slack messages. Here’s mine https://github.com/ksator/chatops_junos/blob/master/scripts/junos.coffee.  
- launch the bot, with a slack adaptor: 
```
ksator@ubuntu:~/myhubot$ HUBOT_SLACK_TOKEN=xoxb-90946701733-BTJh5QnUdQrTMcbtjgawmvjo ./bin/hubot -a slack
```

  

