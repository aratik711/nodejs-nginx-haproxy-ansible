# nodejs-nginx-haproxy-ansible
Scenario:

Let's assume we have 3 centOS 6 VMs:
Test1 - 192.168.30.1
Test2 - 192.168.30.2
Test3 - 192.168.30.3

Using any configuration management tool (preference given to using Ansible) configure each host as the following:

Host Test1:
- Haproxy installed and running on port 80
- Load balances requests to Test2 and Test3 port 8000
- Failover for hosts Test2 and Test3 should be setup for port 8000 (use sensible upstream checks)

Host Test2 and Host Test3:
- Nginx is installed and running on port 8000
- The file "/var/www/local.html" exists and contains the hostname of each machine
- Nginx location rules as following:
    - "/probe_local" should show the contents of /var/www/local.html
    - "/probe_applicant" should return your availability for being 24/7 on-call at nodejs-nginx-haproxy-ansible (shared with other team members)
    - "/*" forwarded to your favorite website
    - "/probe_remote" forwarded to localhost:5500

In addition please make sure:
- Production settings should be reflected in the haproxy, nginx, sysctl, etc. settings
- Please take the number of CPUs on the local machine into account for the nginx settings
- All hosts are reboot safe

Description:

The nodejs-nginx-haproxy-ansible project is used to deploy a simple nodejs appication.
The nodejs application will display the current timestamp of the instance.
The nodejs app will be proxied via nginx and will have failover via haproxy.
The application will be deployed via ansible.
The application will be available on the public ip of the test1 instance on port 80. 


Presumptions:
Nginx and nodejs servers are placed in the same machine.
Nodejs application runs on 5500 port
Nginx default port is 8000
Nodejs app is routed via haproxy at port 80
The application will be deployed on Centos 6 machine.
There should be passwordless sudo for all the instances.
External firewall open between the instances for port 8000.
All the 3 instances are in the same network and have internet access.


Prerequisites:

Provision 3 Centos 6 instances. (You will need a ansible controller machine other than these 3 instances)
Make sure you have a user with sudo rights on all the 3 machines. There should be passwordless sudo for all the instances.
PasswordAuthentication should be enabled in sshd_config.
Passwordless ssh should be done for all the 3 instances from the ansible controller machine.
You should also have python>=2.6.6 installed on the 3 machines.

Lets assume that the instances are test1, test2, test3.
Add them to the /etc/hosts file of the ansible controller if DNS is not present.
To add passwordless ssh you can execute the following command from ansible controller.
Create a ssh key if not already present with the following command:
ssh-keygen -t rsa
<Enter the key path and passphrase. By default key will be created in ~/.ssh/ as id_rsa and id_rsa.pub>

ssh-copy-id -i ~/.ssh/id_rsa.pub <username of remote instance>@test1
<Type in 'yes' when asked for confirmation and enter the password of test1 instance>
Repeat the same for test2 and test3:
ssh-copy-id -i ~/.ssh/id_rsa.pub <username of remote instance>@test2
ssh-copy-id -i ~/.ssh/id_rsa.pub <username of remote instance>@test3

On ansible-controller machine:
Install Python >=2.7
Ansible version 2.4.1.0 (latest). Installation steps: http://docs.ansible.com/ansible/intro_installation.html
Copy the nodejs-nginx-haproxy-ansible directory in ansible controller machine. 

Execute the following commands:
cd nodejs-nginx-haproxy-ansible
Edit the file run.sh 
Change the value of the following variables: HAPROXY_USER, NGINX_USER, NODEJS_USER (this will be the username of 3 instances). Save and close.
Then edit inventory/servers file to change the hostname of the instances which will be running nodejs, nginx and haproxy. Save and close.
Then execute sh run.sh
After a few minutes the application will be available on the <test1 IP> in your browser.
It will display the nginx homepage.
On the url <IP>/probe_local: will display hostname of the nginx machine
<IP>/probe_applicant: will display applicant's availability
<IP>/probe_remote: will reroute to nodejs app displaying timestamp
<IP>/* will reroute to my favorite website

Known Issues/ Limitations:
The code has been tested on Centos 6.9 but should work on other Centos 6 variants as well.
The nodejs app displays static timestamp (current timestamp when the webpage was loaded).
The code only supports passphraseless ssh currently.
