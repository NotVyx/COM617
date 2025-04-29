# OpenTOFU Deployment Script

The script located in this directory was developed using OpenTofu.
https://opentofu.org/docs/intro/install/

You must install this on a server or your machine along with AWS CLI
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

## File information
All 3 files are important for this deployment. 

`deploy.sh.tmpl` is a bash script which is ran on the destination ec2 instance through the cloud-init which is run on first launch.

`deploy.tf` is the tofu file, this defines what resources will be created, including the subnets, RDS (PostgreSQL 14) and the security groups required for the deployment to function.

`id_rsa.pub` You can change this to any public ssh key, you will need the private key to access the servers ssh console remotely. 

## Deployment

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