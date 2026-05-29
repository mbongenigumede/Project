Mbongeni Gumede
# Terraform AWS VPC + EC2 Hello World Application

## Overview

This project provisions AWS infrastructure using Terraform and deploys a simple Python-based Hello World web application running on an EC2 instance on port `8808`.

---

## Features

- Custom VPC (right-sized to `/24`)
- Public Subnet (right-sized to `/28`)
- Internet Gateway
- Route Table & Route Association
- Security Group with least-privilege rules
- EC2 Instance (`t3.micro`, free-tier eligible)
- Centralised tagging via a `locals` tag map
- Automated Python web server deployment
- Public application access on port `8808`

---

## Technologies Used

| Technology | Purpose |
|---|---|
| Terraform | Infrastructure as Code |
| AWS | Cloud Provider |
| EC2 | Virtual Server |
| VPC | Network Isolation |
| Python 3 | Hello World Web Server |
| Amazon Linux 2023 | Operating System |

---

## Infrastructure Architecture

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
Public Subnet (10.0.0.0/28)
inside VPC   (10.0.0.0/24)
     |
     v
EC2 Instance (t3.micro)
     |
     v
Python Hello World App
Port 8808
```

---

## VPC Sizing

The network has been right-sized for a single-server project.

| Resource | CIDR | Addresses | Rationale |
|---|---|---|---|
| VPC | `10.0.0.0/24` | 256 | Small enough to avoid wasting RFC-1918 space; large enough to add more subnets later if needed |
| Public Subnet | `10.0.0.0/28` | 16 (11 usable) | A `/28` is the minimum practical subnet size in AWS. 11 usable addresses is more than sufficient for 1 instance |


**Scaling guidance:** If this project grows to multiple tiers (e.g. a private subnet for a database), carve additional `/28` or `/27` subnets from the remaining `/24` space without needing to rebuild the VPC.

---

## Tagging Strategy

All resources share a centralised tag map defined in `locals` inside `main.tf`. This ensures consistency and makes it easy to update tags in one place.

```hcl
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    CostCentre  = var.cost_centre
    ManagedBy   = "Terraform"
  }
}
```

Each resource merges the common tags with a resource-specific `Name` tag:

```hcl
tags = merge(local.common_tags, {
  Name = "${var.project_name}-vpc"
})
```

### Tag Reference

| Tag | Example Value | Purpose |
|---|---|---|
| `Project` | `hello-world` | Groups all resources belonging to this project |
| `Environment` | `dev` | Separates environments in billing reports |
| `Owner` | `mbongeni-gumede` | Identifies who is accountable for the resource |
| `CostCentre` | `personal` | Maps costs to a team or billing code in AWS Cost Explorer |
| `ManagedBy` | `Terraform` | Signals that manual edits will be overwritten by IaC |
| `StopOnWeekend` | `true` | This is an Optional hook for cost-saving automation (see Cost section) |


---

## Cost Optimisation

In this section I will describe how to keep this environment as cost effective as possible.

### 1. Right-size the Instance

`t3.micro` is the correct choice for a Hello World Python server:

- It is **free-tier eligible** (750 hours/month for the first 12 months).
- Its burstable CPU model means you only pay for CPU credits when the instance is actually busy.

### 2. Stop the Instance When Not in Use

The biggest cost lever for a dev environment is simply **not running it when you don't need it**.

**Manual stop/start via AWS CLI:**
```bash
# To Stop 
aws ec2 stop-instances --instance-ids $(terraform output -raw instance_id)

# To Start again
aws ec2 start-instances --instance-ids $(terraform output -raw instance_id)
```

**Automated scheduling with AWS Instance Scheduler:**
The EC2 instance has a `StopOnWeekend = "true"` tag pre-applied. AWS Instance Scheduler (a free AWS solution) can read this tag and automatically stop the instance on evenings and weekends, cutting runtime by up to 65% compared to running 24/7.


### 3. Destroy the Environment When Done

If you are not actively using this infrastructure, destroy it completely.

```bash
terraform destroy
```

### 4. Use AWS Cost Explorer and Budgets

Set a monthly budget alert so you are never surprised:

### 5. Avoid NAT Gateways

This project correctly uses a **Public Subnet with an Internet Gateway** rather than a NAT Gateway. NAT Gateways cost ~$32/month plus data transfer fees. They are only needed for private subnets.

---

## Project Structure

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

## Prerequisites

Before deploying, ensure the following tools are installed:

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5.0
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- An AWS Account

---

## AWS Configuration

Configure AWS credentials locally:

```bash
aws configure
```

Provide:

- AWS Access Key ID
- AWS Secret Access Key
- Default Region (`us-east-1`)
- Output Format (`json`)

---

## Deployment Lifecycle

### 1. Find your public IP (for SSH access)

```bash
curl -s https://checkip.amazonaws.com
```

Update `allowed_ssh_ip` in `terraform.tfvars` with your IP in CIDR notation (e.g. `41.122.9.19/32`).

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Validate Configuration

```bash
terraform validate
```

### 4. Preview Infrastructure Changes

```bash
terraform plan
```

### 5. Deploy Infrastructure

```bash
terraform apply
```

---

## Accessing the Application

```bash
terraform output application_url
```

Example output:

```text
http://54.221.10.20:8808
```

Open the URL in your browser. Expected response:

```text
Hello World from Terraform EC2!
```

---

## SSH Access

```bash
$(terraform output -raw ssh_command)
```

---

## Destroy Infrastructure

```bash
terraform destroy
```

---

## Security Group Rules

| Port | Protocol | Source | Purpose |
|---|---|---|---|
| 22 | TCP | Your IP only (`/32`) | SSH Access |
| 8808 | TCP | `0.0.0.0/0` | Hello World Application |
| All | All | `0.0.0.0/0` (outbound) | Egress for package installs |

---

## Application Workflow

1. User opens browser and navigates to the application URL
2. Request passes through the Internet Gateway to the public subnet
3. Security Group allows traffic on port `8808`
4. Python HTTP server receives the request
5. Application returns:

```text
Hello World from Terraform EC2!
```
