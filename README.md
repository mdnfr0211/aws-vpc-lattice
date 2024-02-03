# Service-to-Service Communication with Amazon VPC Lattice

This repository provides example code for deploying service-to-service communication using Amazon VPC Lattice. The architecture includes several applications hosted in Amazon EKS, Amazon ECS, and EC2 instances. The components are interconnected using VPC Lattice according to the following setup.

![Diag](https://github.com/mdnfr0211/aws-vpc-lattice-infra/assets/55761300/a935b214-f38e-4829-a552-98fdc87ac5c5)


# Prerequisites

- Terraform: The infrastructure is managed using Terraform. Ensure it is installed on your local machine
- AWS CLI: Make sure you have the AWS Command Line Interface installed to interact with your AWS resources.
- kubectl: Kubernetes command-line tool, kubectl, is required for interacting with EKS clusters.
- AWS Accounts: You need AWS account(s) with IAM user(s) possessing the necessary permissions. The deployment instructions are flexible and support both single and multiple AWS accounts. Choose the pattern that aligns with your testing preferences


# Components

## EC2 Instance - Consumer (Account A)

- This component represents an EC2 instance in the first AWS account. Purpose: It serves as a consumer, making requests to other endpoints within the architecture.

## VPC Lattice Service Network (Account B)

- This component consists of a vpc lattice service network designed to facilitate communication between different AWS accounts. Resource Access Manager (RAM) is utilized to share the service network across multiple AWS accounts.

## ECS Cluster (Account C)

- This component involves an Amazon Elastic Container Service (ECS) cluster in AWS account C. Tasks run within the cluster, and an Internal Application Load Balancer (ALB) is used, as there is no direct integration between ECS and VPC Lattice target group

## EKS Cluster (Account D)

- This component represents an Amazon Elastic Kubernetes Service (EKS) cluster in AWS account D. Pods run within this cluster, and the AWS API Gateway Controller manages the VPC Lattice.

## EC2 Instance (Account D)

- This component involves an ec2 instance in same AWS account as EKS Cluster but resides in a differen VPC
