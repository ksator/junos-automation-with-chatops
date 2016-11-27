FROM ubuntu:14.04 
MAINTAINER Khelil Sator <ksator@juniper.net> 

#####################################################################################################
## install Junos automation tools (ansible and python details)                  
#####################################################################################################
RUN apt-get update 
RUN apt-get install -y python-dev  \ 
    libxml2-dev python-pip libxslt1-dev build-essential \ 
    libssl-dev libffi-dev git curl
RUN pip install cryptography==1.2.1 junos-eznc==1.3.1 \
	jxmlease wget ansible==2.2.1.0 junos-netconify jsnapy \
	requests ipaddress
RUN ansible-galaxy install Juniper.junos

#####################################################################################################
## install hubot requirements (nodejs and npm)                                  
#####################################################################################################
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
RUN apt-get install -y nodejs

#####################################################################################################
## update npm (but this fails ...)                                                                  
#####################################################################################################
#RUN npm install npm@latest -g

#####################################################################################################
## install a generator for hubot 
#####################################################################################################
RUN npm install -g yo generator-hubot

##################################################################################################### 
## you would run “yo hubot” to create a new hubot instance, but that leads an error. 
## The reason is that yo doesn’t run as root user.
## so we can not instanciate hubot with the hubot generator and a root user. 
## So we have to create our own user and switch to it
#####################################################################################################
RUN	useradd -d /hubot -m -s /bin/bash -U hubot
USER    hubot

#####################################################################################################
## move to the hubot directory
#####################################################################################################
WORKDIR /hubot

#####################################################################################################
## instanciate hubot using the generator with the following options
#####################################################################################################
RUN yo hubot --owner="first name last name <user@email.com>" --name="j-bot" --description="Junos automation" --adapter="slack" --defaults

#####################################################################################################
## configure hubot 
## add the directory scripts (hubot dictionnary) from the local repository. 
## remove default package.json and external-scripts.json. And replace them by the ones in the local repository
#####################################################################################################
ADD scripts/ /hubot/scripts
RUN rm package.json external-scripts.json
ADD package.json /hubot/package.json
ADD external-scripts.json /hubot/external-scripts.json

#####################################################################################################
## add add the automation content to the bot.
## the automation_content directory in the local repository will be mounted to the diretory automation_content in the container later on
## i.e, once we will instanciate the container, with the flag -v.
#####################################################################################################
ADD ansible.cfg /hubot/ansible.cfg
#ADD automation_content /hubot/automation_content

######################################################################################################
## launch the bot 
## the HUBOT_SLACK_TOKEN environnement variable is not part of the dockerfile (as it is not something we want to share) 
## so we need to pass as environment variable when we start the container instance with the flag -e
######################################################################################################
ENV HUBOT_NAME j-bot
CMD ["./bin/hubot", "--name", "${HUBOT_NAME}", "HUBOT_SLACK_TOKEN", "${HUBOT_SLACK_TOKEN}",  "--adapter", "slack"]
#CMD bin/hubot
#CMD ["./bin/hubot", "--name", "${HUBOT_NAME}", "HUBOT_SLACK_TOKEN", "${HUBOT_SLACK_TOKEN}",  "--adapter", "slac$

######################################################################################################
## that's it to build the image!
## you also need to instanciate the docker image to get a container. 
## from the same directory, use the following command to get a slack integrated hubot for Junos automation container:
## docker run -v $PWD/automation_content:/hubot/automation_content -e HUBOT_SLACK_TOKEN=xxxxxxxxxxxxxxxx --rm -d j-bot_image
#######################################################################################################

