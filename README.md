Sometimes it is a requirement to utilize EC2 instead of RDS for database servers. 

This projects utilizes terraform to deploy MariaDB or MySQL database servers on EC2 on AWS.

It applies backups, disaster recovery, high availability and fault tolerance to these servers when they are running on EC2. 

This includes all of those requirements and build out the architecture starting from the VPC from scratch.

This project is built on top of the following components:

* [Packer](https://packer.io) for automating the build of the base images
* [Terraform](https://www.terraform.io/) for provisioning the infrastructure
* [Consul](http://consul.io) for service discovery, Health Checks and Nodes Monitoring
* [Shell Scripts]() for installing software and performing the database backups

#### Infrastructure Design Overview
![Graph](databaseSetup.png)



#### Service Discovery, Monitoring & Health Checks
![Graph](health-status.png)


#### configuration Plan
![Graph](graph.png)