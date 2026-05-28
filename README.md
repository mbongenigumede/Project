Mbongeni Gumede
# Terraform AWS VPC + EC2 Hello World Application

## Overview

This project provisions AWS infrastructure using Terraform and deploys a simple Python-based Hello World web application running on an EC2 instance on port `8808`.


---

# Features

- Custom VPC
- Public Subnet
- Internet Gateway
- Route Table & Route Association
- Security Group
- EC2 Instance
- Automated Python web server deployment
- Public application access on port `8808`

---

# Technologies Used

| Technology | Purpose |
|---|---|
| Terraform | Infrastructure as Code |
| AWS | Cloud Provider |
| EC2 | Virtual Server |
| VPC | Network Isolation |
| Python 3 | Hello World Web Server |
| Linux | Operating System |

---

# Infrastructure Architecture

```text
User Browser
     |
     v
Internet
     |
     v
Internet Gateway
     |
     v
Public Subnet
     |
     v
EC2 Instance
     |
     v
Python Hello World App
Port 8808
```

---

# Application Workflow

Once deployment completes:

1. User opens browser
2. Browser sends request to EC2 public IP
3. Security Group allows traffic on port `8808`
4. Python HTTP server receives request
5. Application returns:

```text
Hello World from Terraform EC2!
```

---

# Project Structure

```text
terraform-project/
├── providers.tf
├── variables.tf
├── main.tf
├── userdata.sh
├── outputs.tf
├── terraform.tfvars
└── README.md
```

---

# File Descriptions

## providers.tf

Defines:

- Terraform version
- AWS provider
- AWS region configuration

---

## variables.tf

Contains reusable variables for:

- AWS region
- CIDR blocks
- AMI IDs
- Instance types
- Availability zones

---

## main.tf

Contains the core infrastructure resources:

- VPC
- Public Subnet
- Internet Gateway
- Route Table
- Security Group
- EC2 Instance - I used t3.micro since it's available for free tier

This is the main deployment logic for the project as per request.

---

## userdata.sh

Automates EC2 server configuration during startup.

Responsible for:

- Updating packages
- Installing Python
- Creating the Hello World application
- Starting the web server
---

## outputs.tf

Displays deployment outputs such as:

- EC2 Public IP
- Application URL

---

## terraform.tfvars

Stores customizable variable values.
such as:

```hcl
aws_region    = "us-east-1"
instance_type = "t2.micro"
```

---

# Prerequisites

Before deploying the infrastructure, ensure the following tools are installed:

- Terraform
- AWS CLI
- AWS Account

---

# AWS Configuration

Configure AWS credentials locally:

```bash
aws configure
```

Provide:

- AWS Access Key
- AWS Secret Key
- Default Region
- Output Format

---

# Deployment Lifecycle

## 1. Initialize Terraform

```bash
terraform init
```

This downloads:

- AWS provider plugins
- Terraform dependencies

---

## 2. Validate Configuration

```bash
terraform validate
```

Checks Terraform syntax and configuration correctness.

---

## 3. Preview Infrastructure Changes

```bash
terraform plan
```

Displays:

- Resources to be created
- Infrastructure changes
- Dependency graph

---

## 4. Deploy Infrastructure

```bash
terraform apply
```

Terraform automatically:

- Creates networking resources
- Configures routing
- Creates firewall rules
- Launches EC2 instance
- Executes startup automation
- Deploys the Python application

---

# Accessing the Application

Retrieve the application URL:

```bash
terraform output application_url
```

Example:

```text
http://54.221.10.20:8808
```

Open the URL in your browser.

Expected response:

```text
Hello World from Terraform EC2!
```

---

# Destroy Infrastructure

To remove all created AWS resources:

```bash
terraform destroy
```

---

# Security Group Rules

| Port | Protocol | Purpose |
|---|---|---|
| 22 | TCP | SSH Access |
| 8808 | TCP | Hello World Application |

---