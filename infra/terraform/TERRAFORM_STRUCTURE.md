# Terraform Structure & Execution Guide

## 📁 Complete Terraform Directory Structure

```
infra/terraform/
├── main.tf                          # Main configuration file
├── variables.tf                      # Variable definitions
├── outputs.tf                        # Output values
├── terraform.tfvars                  # Variable values (actual values, gitignored)
├── terraform.tfvars.example          # Example variable values (template)
├── README.md                         # Documentation
├── TERRAFORM_STRUCTURE.md            # This file
│
├── .terraform/                       # Terraform working directory (gitignored)
│   ├── providers/                    # Downloaded providers
│   └── modules/                      # Downloaded modules
│
├── terraform.tfstate                 # State file (gitignored)
├── terraform.tfstate.backup          # State backup (gitignored)
│
└── modules/                          # Reusable Terraform modules
    ├── aks/                          # Azure Kubernetes Service module
    │   ├── main.tf                   # AKS cluster resources
    │   ├── variables.tf              # AKS module variables
    │   ├── outputs.tf                # AKS module outputs
    │   └── README.md                 # AKS module documentation
    │
    ├── databases/                    # Azure Databases module
    │   ├── main.tf                   # SQL/PostgreSQL resources
    │   ├── variables.tf              # Database module variables
    │   ├── outputs.tf                # Database module outputs
    │   └── README.md                 # Database module documentation
    │
    ├── monitoring/                   # Monitoring module
    │   ├── main.tf                   # Log Analytics & App Insights
    │   ├── variables.tf              # Monitoring module variables
    │   ├── outputs.tf                # Monitoring module outputs
    │   └── README.md                 # Monitoring module documentation
    │
    └── servicebus/                   # Service Bus module
        ├── main.tf                   # Service Bus resources
        ├── variables.tf              # Service Bus module variables
        ├── outputs.tf                # Service Bus module outputs
        └── README.md                 # Service Bus module documentation
```

---

## 📄 File-by-File Explanation

### 1. `main.tf` - Main Configuration File

**Purpose:** The entry point of your Terraform configuration. Defines providers, backend, and core resources.

**Current Contents:**
```hcl
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  # Remote state backend (commented out)
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Resource Group
resource "azurerm_resource_group" "microservices" {
  name     = "rg-${var.environment}-microservices-poc"
  location = var.location
  tags = {
    Environment = var.environment
    Project     = "Microservices-POC"
    ManagedBy   = "Terraform"
  }
}
```

**What it does:**
- **Terraform Block:** Sets minimum Terraform version and required providers
- **Provider Block:** Configures Azure provider with features
- **Resource Group:** Creates the main resource group for all resources

**Key Sections:**
- `terraform {}` - Terraform configuration (version, providers, backend)
- `provider "azurerm" {}` - Azure provider configuration
- `resource "azurerm_resource_group"` - Creates the resource group

**Note:** Currently, this file only creates a resource group. Modules are defined but not yet called here.

---

### 2. `variables.tf` - Variable Definitions

**Purpose:** Declares all input variables with types, descriptions, defaults, and validation rules.

**Current Variables:**
- `location` - Azure region (default: "eastus")
- `environment` - Environment name (dev/staging/prod, default: "dev")
- `acr_name` - Azure Container Registry name (default: "acrmicroservicespoc")
- `aks_cluster_name` - AKS cluster name (default: "aks-microservices-poc")

**Key Features:**
- **Type Safety:** Each variable has a type (string, number, bool, etc.)
- **Validation:** Rules ensure values meet requirements
- **Defaults:** Provides default values if not specified
- **Descriptions:** Documents what each variable does

**Example:**
```hcl
variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
  validation {
    condition = contains([
      "eastus", "eastus2", "westus", ...
    ], var.location)
    error_message = "Location must be a valid Azure region."
  }
}
```

---

### 3. `outputs.tf` - Output Values

**Purpose:** Defines values that Terraform will output after applying, useful for other configurations or scripts.

**Current Outputs:**
- `resource_group_name` - Name of created resource group
- `resource_group_location` - Location of resource group
- `resource_group_id` - ID of resource group
- `aks_cluster_name` - AKS cluster name (from variable)
- `acr_name` - ACR name (from variable)
- `acr_login_server` - ACR login server URL

**Usage:**
```bash
# View all outputs
terraform output

# View specific output
terraform output resource_group_name

# Get output as JSON
terraform output -json
```

---

### 4. `terraform.tfvars` - Variable Values (Actual)

**Purpose:** Contains the actual values for variables. This file is gitignored and should never be committed.

**Current Values:**
```hcl
location         = "eastus"
environment      = "dev"
acr_name         = "vasanthpocacr"
aks_cluster_name = "aks-microservices-poc"
```

**Important:**
- ✅ **Gitignored** - Contains actual values, not committed to Git
- ✅ **Local Only** - Each developer/environment has their own
- ✅ **Override Variables** - Overrides defaults in `variables.tf`

**Security:**
- Never commit this file
- Contains environment-specific values
- May contain sensitive data (when service principal is used)

---

### 5. `terraform.tfvars.example` - Variable Template

**Purpose:** Template file showing what variables should be set. Safe to commit to Git.

**Usage:**
```bash
# Copy example to create your own tfvars
cp terraform.tfvars.example terraform.tfvars
# Then edit terraform.tfvars with your values
```

---

### 6. `README.md` - Documentation

**Purpose:** Provides instructions, prerequisites, and usage examples for the Terraform configuration.

**Contains:**
- Prerequisites
- Quick start guide
- Variable descriptions
- Common commands
- Troubleshooting tips

---

## 🧩 Modules Directory

### Module Structure

Each module follows the same structure:
- `main.tf` - Resource definitions
- `variables.tf` - Module input variables
- `outputs.tf` - Module outputs
- `README.md` - Module documentation

### Available Modules

#### 1. `modules/aks/` - Azure Kubernetes Service
- Creates AKS cluster
- Configures node pools (system and user)
- Sets up networking, RBAC, monitoring
- **Status:** ✅ Created, not yet integrated

#### 2. `modules/databases/` - Azure Databases
- Creates Azure SQL Server or PostgreSQL
- Creates databases for ProductService and OrderService
- Configures firewall rules
- **Status:** ✅ Created, not yet integrated

#### 3. `modules/monitoring/` - Monitoring
- Creates Log Analytics Workspace
- Creates Application Insights (shared or per-service)
- Configures retention and quotas
- **Status:** ✅ Created, not yet integrated

#### 4. `modules/servicebus/` - Service Bus
- Creates Service Bus namespace
- Creates notification queue
- Configures authorization rules
- **Status:** ✅ Created, not yet integrated

---

## 🔄 What Happens When You Run `terraform apply`

### Current State (Before Integration)

**What will be created:**
1. ✅ **Resource Group:** `rg-dev-microservices-poc` in `eastus`

**What will NOT be created (yet):**
- ❌ AKS Cluster (module not called)
- ❌ Databases (module not called)
- ❌ Monitoring (module not called)
- ❌ Service Bus (module not called)

### Step-by-Step Execution Flow

#### 1. **Terraform Init** (`terraform init`)
```
✅ Downloads Azure provider (~3.117.1)
✅ Initializes backend (local state by default)
✅ Sets up .terraform/ directory
✅ Prepares working directory
```

#### 2. **Terraform Plan** (`terraform plan`)
```
✅ Reads all .tf files
✅ Validates syntax
✅ Loads variables from terraform.tfvars
✅ Creates execution plan
✅ Shows what will be created/modified/destroyed
```

**Example Output:**
```
Terraform will perform the following actions:

  # azurerm_resource_group.microservices will be created
  + resource "azurerm_resource_group" "microservices" {
      + id       = (known after apply)
      + location = "eastus"
      + name     = "rg-dev-microservices-poc"
      + tags     = {
          + "Environment" = "dev"
          + "ManagedBy"    = "Terraform"
          + "Project"      = "Microservices-POC"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

#### 3. **Terraform Apply** (`terraform apply`)
```
✅ Prompts for confirmation (unless -auto-approve)
✅ Authenticates with Azure (via Azure CLI or service principal)
✅ Creates resources in order:
   1. Resource Group
✅ Saves state to terraform.tfstate
✅ Displays outputs
```

**What Actually Happens:**
1. **Authentication:**
   - Uses Azure CLI credentials (`az login`)
   - Or service principal (if configured)

2. **Resource Creation:**
   - Creates resource group: `rg-dev-microservices-poc`
   - Location: `eastus`
   - Tags: Environment=dev, Project=Microservices-POC, ManagedBy=Terraform

3. **State Management:**
   - Saves state to `terraform.tfstate` (local file)
   - Tracks created resources
   - Stores resource IDs and metadata

4. **Outputs:**
   ```
   resource_group_name = "rg-dev-microservices-poc"
   resource_group_location = "eastus"
   resource_group_id = "/subscriptions/.../resourceGroups/rg-dev-microservices-poc"
   aks_cluster_name = "aks-microservices-poc"
   acr_name = "vasanthpocacr"
   acr_login_server = "vasanthpocacr.azurecr.io"
   ```

### After Apply

**Created Resources:**
- ✅ Resource Group in Azure Portal
- ✅ State file (`terraform.tfstate`) locally

**You Can:**
- View resource in Azure Portal
- Use outputs in other scripts
- Reference resource group in future Terraform runs

---

## 🚀 Next Steps: Integrating Modules

To actually create AKS, databases, monitoring, etc., you need to **call the modules** in `main.tf`:

### Example: Adding Monitoring Module

```hcl
# In main.tf, after resource group
module "monitoring" {
  source = "./modules/monitoring"

  location            = var.location
  resource_group_name = azurerm_resource_group.microservices.name

  log_analytics_workspace_name = "law-microservices-poc"
  log_analytics_retention_days = 30

  application_insights_mode = "shared"
  shared_application_insights_name = "appi-microservices-poc"
  application_insights_retention_days = 90

  tags = {
    Environment = var.environment
    Project     = "Microservices-POC"
    ManagedBy   = "Terraform"
  }
}
```

### Example: Adding AKS Module

```hcl
module "aks" {
  source = "./modules/aks"

  cluster_name        = var.aks_cluster_name
  location            = var.location
  resource_group_name = azurerm_resource_group.microservices.name

  # Node pool configuration
  system_node_pool_vm_size = "Standard_B2s"
  system_node_pool_node_count = 1
  
  user_node_pool_vm_size = "Standard_B2s"
  user_node_pool_min_count = 2
  user_node_pool_max_count = 3

  # Networking
  vnet_subnet_id = azurerm_subnet.aks.id  # Requires VNet first

  tags = {
    Environment = var.environment
    Project     = "Microservices-POC"
    ManagedBy   = "Terraform"
  }
}
```

---

## 📊 Terraform State File

### `terraform.tfstate` (Local State)

**Purpose:** Tracks all resources created by Terraform.

**Contains:**
- Resource IDs
- Resource attributes
- Dependencies
- Outputs

**Important:**
- ⚠️ **Gitignored** - Never commit state files
- ⚠️ **Sensitive** - May contain secrets
- ✅ **Backup** - Automatically backed up to `.backup` file

**Example State Structure:**
```json
{
  "version": 4,
  "terraform_version": "1.6.0",
  "resources": [
    {
      "type": "azurerm_resource_group",
      "name": "microservices",
      "instances": [
        {
          "attributes": {
            "id": "/subscriptions/.../resourceGroups/rg-dev-microservices-poc",
            "location": "eastus",
            "name": "rg-dev-microservices-poc"
          }
        }
      ]
    }
  ]
}
```

---

## 🔐 Security & Best Practices

### 1. **Never Commit:**
- ❌ `terraform.tfvars` (contains actual values)
- ❌ `terraform.tfstate` (contains sensitive data)
- ❌ `terraform.tfstate.backup`
- ❌ `.terraform/` directory

### 2. **Use Remote State (Recommended):**
```hcl
# In main.tf
backend "azurerm" {
  resource_group_name  = "rg-terraform-state"
  storage_account_name = "tfstate"
  container_name       = "tfstate"
  key                  = "microservices.terraform.tfstate"
}
```

**Benefits:**
- ✅ Shared state for teams
- ✅ State locking (prevents concurrent modifications)
- ✅ Encryption at rest
- ✅ Versioning

### 3. **Use Service Principal for CI/CD:**
```hcl
# In provider block
provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}
```

---

## 🛠️ Common Commands

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Format code
terraform fmt

# Plan changes
terraform plan

# Apply changes
terraform apply

# Apply without prompt
terraform apply -auto-approve

# View outputs
terraform output

# Show current state
terraform show

# List resources
terraform state list

# Destroy all resources
terraform destroy

# Refresh state (sync with Azure)
terraform refresh
```

---

## 🎯 Summary

### Current Configuration:
- ✅ **Creates:** Resource Group only
- ✅ **Modules:** Defined but not integrated
- ✅ **State:** Local state file
- ✅ **Authentication:** Azure CLI (default)

### When You Run `terraform apply`:
1. Creates resource group: `rg-dev-microservices-poc`
2. Saves state to `terraform.tfstate`
3. Outputs resource group information

### To Create Full Infrastructure:
1. Integrate modules in `main.tf`
2. Run `terraform init` (to download modules)
3. Run `terraform plan` (to review changes)
4. Run `terraform apply` (to create resources)

---

**Last Updated:** 2026-01-18
