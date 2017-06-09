[![Build Status](https://travis-ci.org/ksator/junos-automation-with-chatops.svg?branch=master)](https://travis-ci.org/ksator/junos-automation-with-chatops)

This repo is about chatops for Junos automation.  
Chatops is about humans chatting to Bots (and the other way around) to delegate tasks.   

This repo provides a dockerized and slack integrated hubot for junos automation.  
The repo is actually based on slack and hubot and junos automation content (ansible playbooks, python scripts, jinja2 templates ...): so we can delegate junos automation tasks chatting to hubot with slack.  

Please visit [wiki](https://github.com/ksator/junos-automation-with-chatops/wiki) to know the [bot capabilities](https://github.com/ksator/junos-automation-with-chatops/wiki/03.-Bot-capabilities) and to get the usage instructions.  

Few examples:    

Rollback the Junos configuration:  
![rollback.png](resources/rollback.png)  

Backup the Junos configuration running on Junos devices on a server:  
![backup.png](resources/backup.png)  

Pass a Junos set command:  
![set.png](resources/set.png)  

