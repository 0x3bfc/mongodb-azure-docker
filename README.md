# MongoDB on Windows Azure Image

This docker file creates a docker image for MongoDB-Azure-Ansible, which creates and configures MongoDB Cluster over Windows Azure Cloud, uses MongoDB Management Service or (MMS) to manage backup and restore processes and uses NewRelic monitoring tool to track the running services on MongoDB Servers.

**Install Docker**

First, make sure that you have a Docker Engine installed on your host for more information [how to install docker](https://docs.docker.com/installation/ubuntulinux/)

**Copy Azure Certificates**

If you did not create your azure certificates, please read more how to create Azure certificate from this [link](https://github.com/aabdulwahed/MongoDB-Azure-Ansible#Create_and_manage_Azure_certificates) then copy these certificates to MongoDB-Azure-Ansible/cert

    $ cp cert.* MongoDB-Azure-Ansible/cert/

**Edit Configuration Files**

* Edit Vagrantfile by modifying cloud service name and Deployment service name, this name must be **unique**

    $ vi MongoDB-Azure-Ansible/Vagrantfile

     ....
     azure.cloud_service_name = 'mongo-staging1' # same as vm_name. leave blank to auto-generate
     azure.deployment_name = 'mongo-staging1' # defaults to cloud_service_name
     ....

Also change storage account name and Subscription ID:

     ....
     azure.subscription_id = '' # add here your subscription id
     azure.storage_acct_name = 'vagrantazure1'
     ....

* Edit hosts file, by modifying the value of ansible_ssh_host "in hosts file" to match the name of <code>cloudservicename.cloudapp.net</code> in Vagrantfile

    $ vi MongoDB-Azure-Ansible/hosts

* Add your MMS keys, New-Relic keys and admin password, check out this file <code>group_vars/all _</code>

**Build Docker Image**

    $ sudo docker build -t mongodb-test:v1 .

**Start MongoDB Deployment**

1. Start new container
   
   $ sudo docker run -it mongodb-test:v1

2. Creaate Azure MongoDB cluster

    $ vagrant up --provider azure

3. Start MongoDB Deployment

    $ ansible-playbook -i hosts playbook.yml -vvvv

4. IN CASE OF RECOVERY OR ADDING NEW NODES TO MONGODB CLUSTER

    $ vagrant up --provider azure
    $ ansible-playbook -i hosts recovery.yml -vvvv


5. FINALLY, IF THERE IS ANY ISSUE, KINDLY CHECK OUT history.txt FILE OR CONTACT ME.

**Test Mongo**

Once, your installation has been deployed, you can test the running mongodb 

    $ mongo <cloudservicename.cloudapp.net>:40000/admin -u admin -p <adminpassword>

    PRIMARY>> rs.status() 
