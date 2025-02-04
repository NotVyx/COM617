# Project Initiation Document

## Project Summary & Introduction
### Purpose
The purpose is to create a easily deployable OpenNMS as a service Solution within AWS utilising resources such as EKS, ECS, RDS and EC2

### Background
Currently OpenNMS is deployed within a business and there is no cloud solution available which companies can easily deploy within their infrastructure. This project is aimed at providing a simple solution.

## Project Aims & Objectives
### Aims
* Provide a OpenNMS as a service solution to customers

### Objectives
* Utilise AWS resources to provide OpenNMS Horizon Core to customers
* Utilising Minions, to provide a way for customers to monitor their in house infrastructure
* Utilise Grafana to make a more customer friendly display of data

## Requirements
1. Create a deployable OpenNMS Solution within AWS utilising the following technologies
    1. AWS EC2 (OpenNMS Core)
    2. AWS RDS (Database PostgreSQL)
2. Product must be accessible globally
    1. VPN may be required
    2. OpenNMS Minions
3. Outline Costs to run OpenNMS as a service within AWS (Hourly, Daily, Weekly, Monthly)

## Scope & Exclusions
N/A

## Monitoring and Evaluation

### Test Plan
| A Cloud Formation | GRPC | ActiveMQ | Kafka |
|-------------------|------|----------|-------|
| ECS               |      |          |       |
| EKS               |      |          |       |
| EC2               |      |          |       |


## Project Organisation & Structure
### Team Members
* Ben Baier - Director
* Jordan Forrest - Project Manager
* Jack Gray - Editor
