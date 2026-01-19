# Terraform Infrastructure as Code

This directory contains Terraform configurations for deploying the microservices infrastructure to Azure.

## Prerequisites

1. **Azure CLI** installed and configured
   ```bash
   az login
   az account set --subscription "your-subscription-id"
   ```

2. **Terraform** installed (>= 1.0)
   ```bash
   terraform version
   ```

3. **Azure Subscription** with appropriate permissions

## File Structure

```
infra/terraform/
├── main.tf              # Main configuration (provider, resource group)
├── variables.tf          # Variable definitions
├── outputs.tf           # Output values
├── terraform.tfvars.example  # Example variables file
└── README.md            # This file
```

## Quick Start

1. **Copy example variables file:**
   ```bash
   cd infra/terraform
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **Edit terraform.tfvars:**
   ```hcl
   location         = "eastus"
   environment      = "dev"
   acr_name         = "acrmicroservicespoc"  # Must be globally unique
   aks_cluster_name = "aks-microservices-poc"
   ```

3. **Initialize Terraform:**
   ```bash
   terraform init
   ```

4. **Plan the deployment:**
   ```bash
   terraform plan
   ```

5. **Apply the configuration:**
   ```bash
   terraform apply
   ```

6. **View outputs:**
   ```bash
   terraform output
   ```

## Variables

### Required Variables

- `location` - Azure region (default: "eastus")
- `environment` - Environment name: dev, staging, or prod (default: "dev")
- `acr_name` - Azure Container Registry name (default: "acrmicroservicespoc")
- `aks_cluster_name` - AKS cluster name (default: "aks-microservices-poc")

### Variable Validation

- `location`: Must be a valid Azure region
- `environment`: Must be one of: dev, staging, prod
- `acr_name`: 5-50 alphanumeric characters, lowercase
- `aks_cluster_name`: 1-63 alphanumeric characters or hyphens, lowercase

## Outputs

After applying, Terraform will output:
- `resource_group_name` - Name of the created resource group
- `resource_group_location` - Location of the resource group
- `resource_group_id` - ID of the resource group
- `aks_cluster_name` - Name of the AKS cluster
- `acr_name` - Name of the ACR
- `acr_login_server` - ACR login server URL

## Authentication

### Option 1: Azure CLI (Recommended for local development)
```bash
az login
az account set --subscription "your-subscription-id"
```

### Option 2: Service Principal
Uncomment and configure service principal variables in `variables.tf` and `terraform.tfvars`.

## State Management

### Local State (Default)
State is stored locally in `terraform.tfstate`.

### Remote State (Recommended for teams)
Uncomment and configure the backend in `main.tf`:
```hcl
backend "azurerm" {
  resource_group_name  = "rg-terraform-state"
  storage_account_name = "tfstate"
  container_name       = "tfstate"
  key                  = "microservices.terraform.tfstate"
}
```

## Common Commands

```bash
# Initialize
terraform init

# Validate configuration
terraform validate

# Format files
terraform fmt

# Plan changes
terraform plan

# Apply changes
terraform apply

# Apply with auto-approve
terraform apply -auto-approve

# Destroy resources
terraform destroy

# Show current state
terraform show

# List resources
terraform state list

# View outputs
terraform output

# Refresh state
terraform refresh
```

## Resource Naming Convention

Resources follow this naming pattern:
- Resource Group: `rg-{environment}-microservices-poc`
- Example: `rg-dev-microservices-poc`

## Tags

All resources are tagged with:
- `Environment`: dev/staging/prod
- `Project`: Microservices-POC
- `ManagedBy`: Terraform

## Next Steps

After creating the resource group, you can add:
- Azure Container Registry (ACR)
- Azure Kubernetes Service (AKS)
- Azure Application Insights
- Azure Key Vault
- Azure Service Bus
- And more...

## Security Best Practices

1. **Never commit terraform.tfvars** - Contains sensitive values
2. **Use remote state** - Store state in Azure Storage with encryption
3. **Use service principals** - For CI/CD pipelines
4. **Enable state locking** - Prevent concurrent modifications
5. **Review plan output** - Always review before applying

## Troubleshooting

### Authentication Errors
```bash
# Re-authenticate with Azure CLI
az login
az account show
```

### State Lock Issues
```bash
# If state is locked, check for running terraform processes
# Or manually unlock (use with caution)
terraform force-unlock <LOCK_ID>
```

### Provider Version Issues
```bash
# Update provider versions
terraform init -upgrade
```
