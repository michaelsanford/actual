# Terraform Deployment for Actual Sync Server

This Terraform configuration provisions resources to run the `sync-server` application
on AWS using Fargate and an Aurora Serverless v2 database.

```
.
├── main.tf             # Root module calling submodules
├── variables.tf        # Input variables
├── outputs.tf          # Outputs from the stack
└── modules             # Reusable submodules
```

Each module is namespaced using the `namespace` variable so multiple
stacks can coexist within the same AWS account.

Run `terraform init` and `terraform apply` inside this directory to deploy.

Key variables:

- `region` - AWS region (defaults to `ca-central-1`)
- `namespace` - prefix for all resource names
- `zone_id` and `domain_name` - Route53 hosted zone and record to attach to the load balancer

Database credentials stored in Secrets Manager rotate automatically every 7 days.
