# MongoDB on Windows Azure Image

This docker file creates a docker image for MongoDB-Azure-Ansible, which creates and configures MongoDB Cluster over Windows Azure Cloud, uses MongoDB Management Service or (MMS) to manage backup and restore processes and uses NewRelic monitoring tool to track the running services on MongoDB Servers.

**Install Docker**

First, make sure that you have a Docker Engine installed on your host for more information [how to install docker](https://docs.docker.com/installation/ubuntulinux/)

**Copy Azure Certificates**

If you did not create your azure certificates, please read more how to create Azure certificate from this [link](https://github.com/aabdulwahed/MongoDB-Azure-Ansible#Create_and_manage_Azure_certificates) then copy these certificates to MongoDB-Azure-Ansible/cert

     $ cp cert.* MongoDB-Azure-Ansible/cert/

**Edit Configuration Files**

Edit Vagrantfile by modifying cloud service name and Deployment service name, this name must be **unique**


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

Edit hosts file, by modifying the value of ansible_ssh_host "in hosts file" to match the name of <code>cloudservicename.cloudapp.net</code> in Vagrantfile

     $ vi MongoDB-Azure-Ansible/hosts

Add your MMS keys, New-Relic keys and admin password, check out this file <code>group_vars/all _</code>, for more information how to get your MMS Group ID and API keys, check out this [link](https://github.com/aabdulwahed/MongoDB-Azure-Ansible#MongoDB_Management_Service), and for New-Relic, check out this [NEWRELIC](https://github.com/aabdulwahed/MongoDB-Azure-Ansible#NewRelic_Server_Monitor)

**Build Docker Image**

     $ sudo docker build -t mongodb-test:v1 .

**Start MongoDB Deployment**

Start new container
   
     $ sudo docker run -it mongodb-test:v1

Creaate Azure MongoDB cluster

     $ vagrant up --provider azure

Start MongoDB Deployment

     $  ansible-playbook -i hosts playbook.yml -vvvv

In case of recovery or scaling out you mongodb cluster

     $ vagrant up --provider azure
     $ ansible-playbook -i hosts recovery.yml -vvvv

**Test Mongo**

Once, your installation has been deployed, you can test the running mongodb 

	$ mongo <cloudservicename.cloudapp.net>:40000/admin -u admin -p <adminpassword>
	PRIMARY>> rs.status() 
		{
				"set" : "master",
				"date" : ISODate("2015-07-16T14:33:34Z"),
				"myState" : 1,
				"members" : [
						{
								"_id" : 0,
								"name" : "master-node:40000",
								"health" : 1,
								"state" : 1,
								"stateStr" : "PRIMARY",
								"uptime" : 970,
								"optime" : {
										"t" : 1437056561000,
										"i" : 2
								},
								"optimeDate" : ISODate("2015-07-16T14:22:41Z"),
								"electionTime" : {
										"t" : 1437056518000,
										"i" : 1
								},
								"electionDate" : ISODate("2015-07-16T14:21:58Z"),
								"self" : true
						},
						{
								"_id" : 1,
								"name" : "replica1:40000",
								"health" : 1,
								"state" : 2,
								"stateStr" : "SECONDARY",
								"uptime" : 676,
								"optime" : {
										"t" : 1437056561000,
										"i" : 2
								},
								"optimeDate" : ISODate("2015-07-16T14:22:41Z"),
								"lastHeartbeat" : ISODate("2015-07-16T14:33:33Z"),
								"lastHeartbeatRecv" : ISODate("2015-07-16T14:33:33Z"),
								"pingMs" : 0,
								"syncingTo" : "master-node:40000"
						},
						{
								"_id" : 2,
								"name" : "replica2:40000",
								"health" : 1,
								"state" : 2,
								"stateStr" : "SECONDARY",
								"uptime" : 668,
								"optime" : {
										"t" : 1437056561000,
										"i" : 2
								},
								"optimeDate" : ISODate("2015-07-16T14:22:41Z"),
								"lastHeartbeat" : ISODate("2015-07-16T14:33:33Z"),
								"lastHeartbeatRecv" : ISODate("2015-07-16T14:33:33Z"),
								"pingMs" : 0,
								"syncingTo" : "master-node:40000"
						}
				],
				"ok" : 1
		}

