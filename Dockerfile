FROM ubuntu:12.04
MAINTAINER Ahmed Abullah <ahmedaabdulwahed@gmail.com>

# Install common packages
RUN apt-get update
RUN apt-get install -y  wget git curl rubygems python-software-properties \
vim openssh-server unzip software-properties-common apt-utils mongodb \
inetutils-ping telnet
RUN gem install json -v '1.8.3'

# Add Ubuntu User
RUN useradd -ms /bin/bash ubuntu


# Generate Required SSH keys
USER ubuntu
RUN ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa
RUN openssl req -batch -new -x509 -key ~/.ssh/id_rsa -out ~/.ssh/ssh-cert.pem

USER root
# Install Vagrant & Azure Plugin
RUN wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.2_x86_64.deb
RUN dpkg -i vagrant_1.7.2_x86_64.deb
RUN rm -f vagrant_1.7.2_x86_64.deb

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y nodejs

# Install Azure CLI
RUN npm install -g azure-cli

# Install Ansible  
RUN apt-add-repository ppa:ansible/ansible
RUN apt-get update
RUN apt-get -y install ansible

# MongoDB Azure Package
ENV HOME /home/ubuntu/
RUN mkdir $HOME/MongoDB-Azure-Ansible/
ADD MongoDB-Azure-Ansible/ $HOME/MongoDB-Azure-Ansible/
WORKDIR $HOME/MongoDB-Azure-Ansible/

# configure Ansible
ADD ansible.cfg /etc/ansible/ansible.cfg

USER root
RUN apt-get -y install sudo 
RUN echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# permission
RUN chown -R ubuntu:ubuntu $HOME
USER ubuntu
RUN vagrant plugin install vagrant-azure
RUN vagrant box add azure https://github.com/msopentech/vagrant-azure/raw/master/dummy.box
