# Service-to-Service Communication with Amazon VPC Lattice

This repository provides example code for deploying service-to-service communication using Amazon VPC Lattice. The architecture includes several applications hosted in Amazon EKS, Amazon ECS, and EC2 instances. The components are interconnected using VPC Lattice according to the following setup.

![Diag](https://github.com/mdnfr0211/aws-vpc-lattice/assets/55761300/3b1bb33a-74a4-4336-b90c-f65231ac6f47)
![Diag](https://github.com/mdnfr0211/aws-vpc-lattice/assets/55761300/3b1bb33a-74a4-4336-b90c-f65231ac6f47)


## Prerequisites
## Prerequisites

- Terraform: The infrastructure is managed using Terraform. Ensure it is installed on your local machine
- AWS CLI: Make sure you have the AWS Command Line Interface installed to interact with your AWS resources.
- kubectl: Kubernetes command-line tool, kubectl, is required for interacting with EKS clusters.
- AWS Accounts: You need AWS account(s) with IAM user(s) possessing the necessary permissions. The deployment instructions are flexible and support both single and multiple AWS accounts. Choose the pattern that aligns with your testing preferences


## Architecture Overview

The design consists of four AWS accounts, each with a private VPC within the overlapping CIDR range of 10.0.0.0/16.

- An EC2 instance in Account A acts as the central communication point, utilizing VPC Lattice to reach private services like ECS, EKS, and EC2 instances in other accounts.
- Account C hosts an ECS service behind an internal application load balancer, accessible via VPC Lattice.
- Account D includes two VPCs: one with EKS and an Application Gateway Controller managing VPC Lattice, and another with an EC2 instance, both interacting with Account A through VPC Lattice.
## Architecture Overview

The design consists of four AWS accounts, each with a private VPC within the overlapping CIDR range of 10.0.0.0/16.

- An EC2 instance in Account A acts as the central communication point, utilizing VPC Lattice to reach private services like ECS, EKS, and EC2 instances in other accounts.
- Account C hosts an ECS service behind an internal application load balancer, accessible via VPC Lattice.
- Account D includes two VPCs: one with EKS and an Application Gateway Controller managing VPC Lattice, and another with an EC2 instance, both interacting with Account A through VPC Lattice.

## Technology Stack

- Amazon Web Services
  - Amazon Virtual Private Cloud (VPC)
  - Amazon Elastic Compute Cloud (EC2)
  - Amazon Elastic Container Service (ECS)
  - Amazon Kubernetes Service (EKS)
  - Amazon VPC Lattice
- Infrastructure as Code (IaC)
  - Terraform


## Code Structure
```
.
├── complete
│   ├── app1
│   ├── app2
│   ├── app3
│   ├── consumer
│   └── vpc-lattice
└── modules
    ├── app
    │   ├── alb
    │   ├── ec2
    │   ├── ecs
    │   │   └── container_definition
    │   ├── eks
    │   └── lambda
    └── base
        ├── iam
        │   ├── eks-sa
        │   └── iam-assumable
        ├── s3
        └── vpc
```

## Instruction

Do terraform init, plan and apply on the respective order

- VPC Lattice
- Consumer
- App1
- App2
- App3

Deploy VPC Lattice and RAM (Account B)
- Navigate to vpc-lattice directory.
- Update variables.tf with account-specific details and desired configuration.
- Run terraform init, terraform plan, and terraform apply.

Follow the Same approach for other directories

## Output

### VPC Lattice

<img width="800" alt="image" src="https://github.com/mdnfr0211/aws-vpc-lattice/assets/55761300/756ce6a7-fb6d-498f-b2d0-1a29284050be">
<img width="800" alt="image" src="https://github.com/mdnfr0211/aws-vpc-lattice/assets/55761300/7fbb8458-d77a-4c46-b202-a9bfcef48a3d">

### Communication from Consumer to App1
<img width="800" alt="image" src="https://github.com/mdnfr0211/aws-vpc-lattice/assets/55761300/a0c6c3cd-5ea2-47c6-bfcb-c7398ce5279d">

### Communication from Consumer to App2
<img width="800" alt="image" src="https://github.com/mdnfr0211/aws-vpc-lattice/assets/55761300/ec3d8e5c-df16-4002-bdd1-48dd34b1300c">

### Communication from Consumer to App3
<img width="800" alt="image" src="https://github.com/mdnfr0211/aws-vpc-lattice/assets/55761300/6f703fbe-1f57-4ffd-96b8-7df5fb47f89b">
## Technology Stack

- Amazon Web Services
  - Amazon Virtual Private Cloud (VPC)
  - Amazon Elastic Compute Cloud (EC2)
  - Amazon Elastic Container Service (ECS)
  - Amazon Kubernetes Service (EKS)
  - Amazon VPC Lattice
- Infrastructure as Code (IaC)
  - Terraform


## Code Structure
```
.
├── complete
│   ├── app1
│   ├── app2
│   ├── app3
│   ├── consumer
│   └── vpc-lattice
└── modules
    ├── app
    │   ├── alb
    │   ├── ec2
    │   ├── ecs
    │   │   └── container_definition
    │   ├── eks
    │   └── lambda
    └── base
        ├── iam
        │   ├── eks-sa
        │   └── iam-assumable
        ├── s3
        └── vpc
```

## Instruction

Do terraform init, plan and apply on the respective order

- VPC Lattice
- Consumer
- App1
- App2
- App3

Deploy VPC Lattice and RAM (Account B)
- Navigate to vpc-lattice directory.
- Update variables.tf with account-specific details and desired configuration.
- Run terraform init, terraform plan, and terraform apply.

Follow the Same approach for other directories

## Output

### VPC Lattice

<img width="800" alt="image" src="https://github.com/mdnfr0211/aws-vpc-lattice/assets/55761300/756ce6a7-fb6d-498f-b2d0-1a29284050be">
<img width="800" alt="image" src="https://github.com/mdnfr0211/aws-vpc-lattice/assets/55761300/7fbb8458-d77a-4c46-b202-a9bfcef48a3d">

### Communication from Consumer to App1
<img width="800" alt="image" src="https://github.com/mdnfr0211/aws-vpc-lattice/assets/55761300/a0c6c3cd-5ea2-47c6-bfcb-c7398ce5279d">

### Communication from Consumer to App2
<img width="800" alt="image" src="https://github.com/mdnfr0211/aws-vpc-lattice/assets/55761300/ec3d8e5c-df16-4002-bdd1-48dd34b1300c">

### Communication from Consumer to App3
<img width="800" alt="image" src="https://github.com/mdnfr0211/aws-vpc-lattice/assets/55761300/6f703fbe-1f57-4ffd-96b8-7df5fb47f89b">
