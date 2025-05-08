# Network Management as a Service (NMaaS)

This repo is part of Solent module COM617 and is split into two key sections
```
COM617
├───COM617-Config
├───Deployment
│   ├───helmchart
│   │   └───templates
│   ├───kustomize
│   │   ├───grafana
│   │   ├───opennms
│   │   └───traefik
│   ├───minion-ActiveMQ
│   └───minion-grpc-broken
│       └───container-fs
│           └───minion
│               └───opt
│                   └───minion
└───OpenTofu
```
`Deployment` Contains everything to do with Kubernetes / OpenNMS deployment files.<br />
`OpenTofu` Contains all the files for the infrastructure as code deployment within AWS.

# Getting Started
Follow this process to fully deploy our current solution.

## Requirements
You will need to install the below tools on your system of choice. <br />
`git` https://git-scm.com/ <br />
`OpenTofu` https://opentofu.org/docs/intro/install/ <br />
`AWS CLI` https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html <br />
`FQDN` https://www.techtarget.com/whatis/definition/fully-qualified-domain-name-FQDN

## Core Deployment
Clone our current repo.
```
$ git clone https://github.com/NotVyx/COM617.git
```
Navigate to the OpenTofu folder:
```
$ cd ./COM617/OpenTofu
```

### File information
All 3 files are important for this deployment. 

`deploy.sh.tmpl` is a bash script which is ran on the destination ec2 instance through the cloud-init which is run on first launch.

`deploy.tf` is the tofu file, this defines what resources will be created, including the subnets, RDS (PostgreSQL 14) and the security groups required for the deployment to function.

`id_rsa.pub` You can change this to any public ssh key, you will need the private key to access the servers ssh console remotely. 

### Login to AWS
Generate an Access Token through your AWS profile. As best practice, this should not be the root account. 
```
$ aws configure
AWS Access Key ID [****************3R7J]:
AWS Secret Access Key [****************OQOo]: 
Default region name []: 
Default output format [None]:

```
Once logged in, you should initialise TOFU to pull all requirements.
```
$ tofu init

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/random from the dependency lock file
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/random v3.7.2
- Using previously-installed hashicorp/aws v5.96.0
OpenTofu has been successfully initialized!

```

Once fully initialised, you can run the following commands to test and plan the deployment, if anything is wrong it should warn you here.

### Testing the configuration
```
$ tofu test

Success! 0 passed, 0 failed.
```

### Planning the Deployment
```
$ tofu plan

OpenTofu used the selected providers to generate the following execution plan. Resource
actions are indicated with the following symbols:
  + create

OpenTofu will perform the following actions: ...
```

### Deploying OpenNMS into AWS
When you are ready to deploy OpenNMS into your AWS environment you run:
```
$ tofu apply

OpenTofu used the selected providers to generate the following execution plan. Resource       
actions are indicated with the following symbols:
  + create

OpenTofu will perform the following actions: ...
```
Tofu will prompt you to confirm the actions, if you are happy to continue, type 'yes'.




## Known Issues
Currently, there is some known issues as follows:
- The Helmchart does not fully function, the communication between Traefik and OpenNMS does not work.



## ActiveMQ Minion Deployment
On a system of your choice, you will be able to deploy a minion and attach it to the OpenNMS.

### Requirements
You will need to installed on the OS of the minion. <br />
`git` https://git-scm.com/ <br />
`docker` https://docs.docker.com/engine/install/ <br />

### Clone the Repo
Though you can simply copy the contents of both files in `./Deployment/minion-ActiveMQ` onto your host of choice, cloning the repo is easier.<br />
```
$ git clone https://github.com/NotVyx/COM617.git
$ cd ./COM617/Deployment/minion-ActiveMQ
```

### Update Configuration
You will need to update the configuration in both `docker-compose.yaml` and `minion-config.yaml`.<br />
Each of these files have comments so please refer to them for guidance. However ensure you update the `http-url` and `broker-url` entries in the minion-config, otherwise the minion will **FAIL** to start.

### Deploy the Minion
Once you have verified your own configuration and the Core OpenNMS deployment is accessible, you can attempt to run the minion.
```
$ sudo docker compose up -d
[+] Running 30/30
 ✔ minion Pulled
[+] Running 2/2
 ✔ Network onmsminion_default  Created
 ✔ Container minion            Started

```
The system can take a few moments to initialise, it will show up on OpenNMS when ready, if you don't see it, you can view the docker logs by running:
```
$ sudo docker compose logs
```