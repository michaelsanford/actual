# Actual Budget Terraform Infrastructure

This Terraform configuration deploys the complete AWS infrastructure for Actual Budget application on ECS Fargate.

## Architecture

- **VPC**: Multi-AZ setup with public and private subnets
- **ECS Fargate**: Containerized application deployment
- **Application Load Balancer**: HTTPS termination with SSL certificate
- **EFS**: Encrypted file system for persistent storage
- **Secrets Manager**: Secure configuration management
- **Route53**: DNS management
- **CloudWatch**: Logging and monitoring

## Prerequisites

1. AWS CLI configured with appropriate permissions
2. Terraform >= 1.0 installed
3. Route53 hosted zone for your domain

## Deployment

1. **Initialize Terraform:**
   ```bash
   cd tf/
   terraform init
   ```

2. **Review and customize variables:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

3. **Plan deployment:**
   ```bash
   terraform plan
   ```

4. **Deploy infrastructure:**
   ```bash
   terraform apply
   ```

## Configuration

Key variables in `terraform.tfvars`:

- `project_name`: Project identifier
- `domain_name`: Your application domain
- `hosted_zone_name`: Your Route53 hosted zone
- `app_config`: Application environment variables

## Outputs

After deployment, Terraform outputs:
- Application URL
- EFS file system details
- Load balancer information
- ECS cluster details

## Security Features

- ✅ Encrypted EFS file system
- ✅ HTTPS with TLS 1.3 and FIPS compliance
- ✅ Secrets Manager for sensitive configuration
- ✅ Private subnets for application containers
- ✅ Security groups with least privilege access
- ✅ VPC with proper network isolation

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

## Customization

The infrastructure is highly configurable through variables. Common customizations:

- **Scaling**: Modify `cpu`, `memory`, and desired count
- **Networking**: Adjust CIDR blocks and availability zones
- **Storage**: Configure EFS throughput and backup policies
- **Security**: Customize security group rules and SSL policies
