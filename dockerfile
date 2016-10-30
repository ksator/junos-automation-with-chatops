FROM ubuntu:14.04 
MAINTAINER Khelil Sator <ksator@juniper.net> 

##################################################################################
## install network automation tools (ansible and python details)               ##
##################################################################################
RUN apt-get update 
RUN apt-get install -y python-dev  \ 
    libxml2-dev python-pip libxslt1-dev build-essential \ 
    libssl-dev libffi-dev git curl
RUN pip install cryptography==1.2.1 junos-eznc==1.3.1 \
	jxmlease wget ansible==2.1.0.0 junos-netconify jsnapy \
	requests ipaddress
RUN ansible-galaxy install Juniper.junos

##################################################################################
## install nodejs and npm                                                       ##
##################################################################################
RUN curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
RUN apt-get install -y nodejs
#RUN npm install npm@latest -g

##################################################################################
## install hubot 
##################################################################################

# install a generator for creating hubot
RUN npm install -g yo generator-hubot

# Create hubot user
RUN	useradd -d /hubot -m -s /bin/bash -U hubot

# Log in as hubot user and change directory
USER	hubot
WORKDIR /hubot

# instanciate the bot
RUN yo hubot --owner="first name last name <user@email.com>" --name="j-bot" --description="Junos automation" --adapter="slack" --defaults

#######################################################
# add the bot dictionnary (coffeescript) and add the automation content to the bot
#######################################################
#ADD ansible.cfg /hubot/ansible.cfg
#ADD scripts/junos_automation.coffee /hubot/scripts
#ADD scripts/script.coffee /hubot/scripts
#ADD automation_content /hubot/automation_content

ENV HUBOT_SLACK_TOKEN xoxb-90946701733-bOtCxFFH4611wo7nNC2sibvH
ENV HUBOT_NAME j-bot
CMD ["./bin/hubot", "--name", "${HUBOT_NAME}", "HUBOT_SLACK_TOKEN", "${HUBOT_SLACK_TOKEN}",  "--adapter", "slack"]
