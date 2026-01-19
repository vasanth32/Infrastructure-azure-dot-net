# Terraform Execution Flow - What Happens When You Run `terraform apply`

## 🎯 Current State Summary

**What You Have:**
- ✅ Terraform configuration files
- ✅ 4 modules defined (AKS, Databases, Monitoring, Service Bus)
- ✅ Variables and outputs configured
- ✅ Resource group definition

**What Will Be Created:**
- ✅ **Resource Group:** `rg-dev-microservices-poc` in `eastus`
- ❌ **Nothing Else Yet** (modules are not called in main.tf)

---

## 📋 Execution Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    terraform apply                          │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Step 1: Authentication                                      │
│  - Uses Azure CLI credentials (az login)                    │
│  - Or service principal (if configured)                     │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Step 2: Read Configuration                                  │
│  - Reads main.tf, variables.tf, outputs.tf                  │
│  - Loads values from terraform.tfvars                       │
│  - Validates syntax and references                          │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Step 3: Load State                                          │
│  - Reads terraform.tfstate (if exists)                      │
│  - Compares desired state vs current state                  │
│  - Determines what needs to be created/modified/destroyed   │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Step 4: Create Execution Plan                              │
│  - Calculates dependencies                                   │
│  - Determines resource creation order                       │
│  - Shows plan: "Plan: 1 to add, 0 to change, 0 to destroy" │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Step 5: Prompt for Confirmation                             │
│  - Shows execution plan                                      │
│  - Asks: "Do you want to perform these actions?"            │
│  - Type: yes (or use -auto-approve flag)                     │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Step 6: Create Resources                                    │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ azurerm_resource_group.microservices                 │   │
│  │   ├─ Name: rg-dev-microservices-poc                 │   │
│  │   ├─ Location: eastus                                │   │
│  │   ├─ Tags:                                           │   │
│  │   │   ├─ Environment: dev                            │   │
│  │   │   ├─ Project: Microservices-POC                  │   │
│  │   │   └─ ManagedBy: Terraform                        │   │
│  │   └─ Status: ✅ Created                              │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Step 7: Save State                                          │
│  - Writes terraform.tfstate                                 │
│  - Creates terraform.tfstate.backup                         │
│  - Stores resource IDs and metadata                         │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Step 8: Display Outputs                                    │
│  - resource_group_name = "rg-dev-microservices-poc"        │
│  - resource_group_location = "eastus"                       │
│  - resource_group_id = "/subscriptions/.../..."             │
│  - aks_cluster_name = "aks-microservices-poc"              │
│  - acr_name = "vasanthpocacr"                              │
│  - acr_login_server = "vasanthpocacr.azurecr.io"           │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  ✅ Apply Complete!                                          │
│  - Resource group created in Azure                          │
│  - State saved locally                                       │
│  - Ready for next steps                                      │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔍 Detailed Step-by-Step Breakdown

### Step 1: Authentication

**What Happens:**
```bash
# Terraform checks for authentication in this order:
1. Azure CLI credentials (az login) ← Default
2. Service principal (if configured in provider block)
3. Managed Identity (if running in Azure)
4. Environment variables (ARM_*)
```

**Your Current Setup:**
- ✅ Uses Azure CLI (`az login`)
- Provider block doesn't specify credentials, so it uses default Azure CLI

**Check Your Auth:**
```bash
az account show
# Should show your subscription
```

---

### Step 2: Read Configuration

**Files Read:**
1. `main.tf` - Resource definitions
2. `variables.tf` - Variable declarations
3. `terraform.tfvars` - Variable values
4. `outputs.tf` - Output definitions

**What Terraform Does:**
- Parses HCL (HashiCorp Configuration Language)
- Validates syntax
- Resolves variable references
- Builds dependency graph

**Variable Resolution:**
```hcl
# variables.tf
variable "location" {
  default = "eastus"
}

# terraform.tfvars
location = "eastus"  ← This overrides default

# main.tf
location = var.location  ← Uses "eastus"
```

---

### Step 3: Load State

**State File:** `terraform.tfstate`

**First Run (No State File):**
- No existing state
- All resources are "new"
- Everything will be created

**Subsequent Runs:**
- Reads existing state
- Compares with desired state
- Determines changes needed

**State Comparison:**
```
Desired State (from .tf files):
  - Resource Group: rg-dev-microservices-poc

Current State (from terraform.tfstate):
  - (empty on first run)

Result:
  - Action: CREATE
  - Resource: azurerm_resource_group.microservices
```

---

### Step 4: Create Execution Plan

**Plan Output Example:**
```
Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

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

**What This Means:**
- `+` = Create new resource
- `~` = Modify existing resource
- `-` = Destroy resource
- `-/+` = Destroy and recreate

---

### Step 5: Prompt for Confirmation

**Prompt:**
```
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: 
```

**Options:**
- Type `yes` to proceed
- Type `no` to cancel
- Use `terraform apply -auto-approve` to skip prompt

---

### Step 6: Create Resources

**Actual Azure API Calls:**
```
1. POST /subscriptions/{sub}/resourceGroups
   Body: {
     "location": "eastus",
     "tags": {
       "Environment": "dev",
       "Project": "Microservices-POC",
       "ManagedBy": "Terraform"
     }
   }

2. Wait for resource group creation
   Status: Creating → Succeeded

3. GET /subscriptions/{sub}/resourceGroups/rg-dev-microservices-poc
   Response: Resource group details with ID
```

**Timeline:**
- Resource Group: ~5-10 seconds

**What You'll See:**
```
azurerm_resource_group.microservices: Creating...
azurerm_resource_group.microservices: Creation complete after 3s [id=/subscriptions/.../resourceGroups/rg-dev-microservices-poc]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

---

### Step 7: Save State

**State File Created:** `terraform.tfstate`

**Contents:**
```json
{
  "version": 4,
  "terraform_version": "1.6.0",
  "resources": [
    {
      "mode": "managed",
      "type": "azurerm_resource_group",
      "name": "microservices",
      "provider": "provider[\"registry.terraform.io/hashicorp/azurerm\"]",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "id": "/subscriptions/xxx/resourceGroups/rg-dev-microservices-poc",
            "location": "eastus",
            "name": "rg-dev-microservices-poc",
            "tags": {
              "Environment": "dev",
              "ManagedBy": "Terraform",
              "Project": "Microservices-POC"
            }
          }
        }
      ]
    }
  ]
}
```

**Backup Created:** `terraform.tfstate.backup`
- Automatic backup before each write
- Safety net in case of corruption

---

### Step 8: Display Outputs

**Output Display:**
```
Outputs:

resource_group_name = "rg-dev-microservices-poc"
resource_group_location = "eastus"
resource_group_id = "/subscriptions/xxx/resourceGroups/rg-dev-microservices-poc"
aks_cluster_name = "aks-microservices-poc"
acr_name = "vasanthpocacr"
acr_login_server = "vasanthpocacr.azurecr.io"
```

**Using Outputs:**
```bash
# View all outputs
terraform output

# View specific output
terraform output resource_group_name

# Get as JSON
terraform output -json

# Use in scripts
RESOURCE_GROUP=$(terraform output -raw resource_group_name)
```

---

## 🎬 Complete Example Run

### Command Sequence:
```bash
# 1. Navigate to terraform directory
cd infra/terraform

# 2. Initialize (if not done)
terraform init

# 3. Validate
terraform validate

# 4. Plan (optional, but recommended)
terraform plan

# 5. Apply
terraform apply
```

### Expected Output:
```
Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/azurerm versions matching "~> 3.0"...
- Installing hashicorp/azurerm v3.117.1...
- Installed hashicorp/azurerm v3.117.1

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget,
other commands will detect it and remind you to do so if necessary.
```

```
Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

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

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
```

```
azurerm_resource_group.microservices: Creating...
azurerm_resource_group.microservices: Creation complete after 3s [id=/subscriptions/xxx/resourceGroups/rg-dev-microservices-poc]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

resource_group_name = "rg-dev-microservices-poc"
resource_group_location = "eastus"
resource_group_id = "/subscriptions/xxx/resourceGroups/rg-dev-microservices-poc"
aks_cluster_name = "aks-microservices-poc"
acr_name = "vasanthpocacr"
acr_login_server = "vasanthpocacr.azurecr.io"
```

---

## ✅ Verification

### Check in Azure Portal:
1. Go to https://portal.azure.com
2. Navigate to "Resource groups"
3. Look for: `rg-dev-microservices-poc`
4. Verify location: `eastus`
5. Check tags: Environment=dev, Project=Microservices-POC, ManagedBy=Terraform

### Check via Azure CLI:
```bash
az group show --name rg-dev-microservices-poc
```

### Check Terraform State:
```bash
terraform state list
# Should show: azurerm_resource_group.microservices

terraform show
# Should show resource details
```

---

## 🚨 Common Issues & Solutions

### Issue 1: Authentication Error
```
Error: Error building AzureRM Client: Authenticating using the Azure CLI is only supported as a User (not a Service Principal / Managed Identity)
```

**Solution:**
```bash
az login
az account set --subscription "your-subscription-id"
```

### Issue 2: Resource Already Exists
```
Error: A resource with the ID "/subscriptions/.../resourceGroups/rg-dev-microservices-poc" already exists.
```

**Solution:**
```bash
# Import existing resource
terraform import azurerm_resource_group.microservices /subscriptions/.../resourceGroups/rg-dev-microservices-poc

# Or delete existing resource group
az group delete --name rg-dev-microservices-poc
```

### Issue 3: Invalid Location
```
Error: Location must be a valid Azure region.
```

**Solution:**
- Check `terraform.tfvars` - ensure location is valid
- See `variables.tf` for allowed locations

---

## 📊 What's Next?

After successfully creating the resource group, you can:

1. **Integrate Modules:**
   - Add module calls to `main.tf`
   - Run `terraform init` (to download modules)
   - Run `terraform apply` (to create resources)

2. **Create AKS Cluster:**
   ```hcl
   module "aks" {
     source = "./modules/aks"
     # ... configuration
   }
   ```

3. **Create Databases:**
   ```hcl
   module "databases" {
     source = "./modules/databases"
     # ... configuration
   }
   ```

4. **Set Up Monitoring:**
   ```hcl
   module "monitoring" {
     source = "./modules/monitoring"
     # ... configuration
   }
   ```

---

**Last Updated:** 2026-01-18
