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
1. Solution must be globally accessible with the use of a Minion
    1. (optional) May require the use of a VPN
        1. Wireguard
        2. OpenVPN
    2. Must use any of the following communication protocols
        1. Kafka
        2. ActiveMQ
        3. GRPC
    3. Must be deployable with minimal user configuration
2. Solution must be deployable within the cloud in an optimised manner
    1. Deployed within AWS utilise solutions such as
        1. EC2
        2. AWS Databases such as AWS RDS (SQL) or DynamoDB (NoSQL)
        3. S3 Storage, for logs(?)
    2. On-Premise must use any of the following solutions
        1. Docker or Kubernetes for containerisation
        2. NoSQL or MariaDB (SQL)
3. Solution must have users and roles configured for each customer.
4. OpenNMS must utilise alarms and notifications to alert the relevant customer of the outage.
5. Must monitor systems must be able to monitor the following services:
    1. SNMP
    2. HTTP(s)
    3. DNS
    4. TCP Port
    5. SSH (If applicable)
