# COM617

## Team Members
* Ben Baier - Director
* Jordan Forrest - Project Manager
* Jack Gray - Editor


## Sprints and their goals
### Sprint 1:
* Week 1: Gather Requirements
* Week 2: Develop a Project Plan, experiment with in-house equipment
* Week 3: Prepare a Group presentation

### Sprint 2:
* Week 1: Develop a POC within AWS
* Week 2: Test POC
* Week 3: Refine POC

### Sprint 3:
* Week 1: Action Feedback, Adjust requirements if requirements
* Week 2: Review product

## Requirements:
1. Develop a method to automatically deployment of OpenNMS on AWS
    1. Utilise AWS Resources to run OpenNMS Core
        1. Elastic Container Service (ECS)
        2. Elastic Kubernetes Service (EKS)
        3. Elastic Compute Cloud (EC2)
    1. Relational Database Service (RDS, Postgres)
    2. Grafana for Data Visualisation
    3. Apache Kafka
2. Multi-Tenant Support
    1. Enable a deployment for multiple customers with isolated configuration
    2. Provide a secure method of connectivity for each customers network to OpenNMS
3. Secure Connectivity
    1. A VPN solution may be neccessary for some customers due to network limitations.
    2. Utilise Communication Protocols supported by OpenNMS
        1. ActiveMQ
        2. Kafka
        3. GRPC
4. Optimise Costs
    1. Compare the cost of running the solution in house vs the cloud
    2. Provide recommendations for cost-efficient deployment options
5. Scalability & Performance
    1. Optimise OpenNMS performance within a cloud environment


## Test Plan
| A Cloud Formation | ???? | ActiveMQ | Kafka | GRPC |
|-------------------|------|----------|-------|------|
| ECS               |      |          |       |      |
| EKS               |      |          |       |      |
| EC2               |      |          |       |      |


| 




