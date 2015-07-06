FROM ubuntu:12.04
MAINTAINER Ahmed Abullah <ahmedaabdulwahed@gmail.com>

# Install common packages
RUN apt-get update
RUN apt-get install -y  wget git curl rubygems python-software-properties \
vim openssh-server unzip software-properties-common apt-utils
RUN gem install json -v '1.8.3'
RUN mkdir /root/packages
ENV ROOT_DIR /root/packages
WORKDIR $ROOT_DIR

# Install Vagrant & Azure Plugin
RUN wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.2_x86_64.deb
RUN dpkg -i vagrant_1.7.2_x86_64.deb
RUN vagrant plugin install vagrant-azure
RUN vagrant box add azure https://github.com/msopentech/vagrant-azure/raw/master/dummy.box

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y nodejs

# Install Azure CLI
RUN npm install -g azure-cli

# Install Ansible  
RUN apt-add-repository ppa:ansible/ansible
RUN apt-get update
RUN apt-get -y install ansible

# Download MongoDB Azure Package
RUN git clone https://github.com/aabdulwahed/MongoDB-Azure-Ansible.git


