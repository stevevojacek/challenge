AWS Challenge:

The intention of this lab is to create an AWS Infrastructure to provide a new VPC, subnets, routing tables, NATs and Web Servers with terraform code.
On the first phase a single web server will be created, after that the infrastructure will be completely destroyed and recreated with two web servers instead of one.



Steps:

Step 1:
•	Create a VPC with public and private subnet
•	Create the NAT, Elastic IP and Routes needed for the Web Servers
•	Create an EC2 server
•	Install a web service (httpd, nginx) and publish a simple web page (Hello World)
•	Open the web service to be accessible from the internet
   
Step 2:
•	Delete all the Infrastructure deployed on Step 1

Step 3:
•	Deploy the Infrastructure on Step 1 with two Servers and their web Services

Step 4:
•	Delete all the Infrastructure deployed on Step 3

 
Procedure (How it is done):

STEP1:
1-First, I check that there is only one default VPN and no EC2 instances on my AWS account (Please see the attached images 001 and 002 on the IMAGES dir)
2-Add the Provider (aws) section to the file main.tf
3-Add the "Main VPC" for the project (ChallengeVPC)
4-Add the "Public and Private Subnets" (Inside the ChallengeVPC)
5-Add the "Internet Gateway"
6-Add the "Elastic IP" for the NAT Gateway
7-Add the "NAT Gateway"
8-Add the "Route" for the public subnet and add the "route table association"
9-Add the "Security Group", and allow anyone on the internet to reach the port 80 for the web server
10-Add an EC2 server (copy the AMI code from the AWS web console to be used on the main.tf file), and add a script to be executed within the instance to install httpd service with a "Hello World - Server 1" message
11-After creating the main.tf file on terraform, I execute:
#terraform init
#terraform plan   (I check that all the changes to be applied to AWS are correct, and then proceed) 
#terraform apply

(..The VPC, networking, NAT, routes and the EC2 instance/web server are created)
I go to the EC2 instance page on AWS web console, copy the Internet IP address, paste it on a web client on my side and check that the web server is up and running (Please see the attached image 003a/b and 004)

STEP2:
12-I destroy everything, with #terraform destroy

STEP3:
13-Add the secondary EC2 instance, as the secondary web server, with the same config than the first one, but with the text "Hello World - Server 2" message on their web server
14-After modify the main.tf file on terraform, I execute:
#terraform plan   (I check that all the changes to be applied to AWS are correct, and then proceed) 
#terraform apply

(..The secondary EC2 instance is created)
-I go to the EC2 instance page on AWS console, copy the Internet IP address of both instances, paste it on a web client on my side and check that the web servers are up and running (Please see the attached images 005, 006, 007 and 008)

STEP4:
15-Finally, everything is deleted again, with #terraform destroy
