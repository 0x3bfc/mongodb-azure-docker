# MOngoDB  on Windows Azure Image

This docker file creates a docker image for [MongoDB-Azure-Ansible](https://github.com/aabdulwahed/MongoDB-Azure-Ansible), which creates and configures MongoDB Cluster over Windows Azure Cloud, uses MongoDB Management Service or (MMS) to manage backup and restore processes and uses NewRelic monitoring tool to track the running services on MongoDB Servers.


**Build Generic Image**

First, make sure that you have a Docker Engine installed on your host for more information [how to install docker](https://docs.docker.com/installation/ubuntulinux/), download then run the following command lines:

    $ mkdir mongodb-azure-test
    $ cd mongodb-azure-test
    $ git clone https://github.com/aabdulwahed/mongodb-azure-docker.git 
    $ cd mongodb-azure-docker
    $ sudo docker build -t mongodb-azure .

once the installation finishes, check out your docker images

    $ sudo docker images 
    $ sudo docker run -it mongodb-azure bash

Now, you have a decorized container of MongoDB-Azure-Ansible.
