# 📂 Infrastructure as Code Templates

This folder contains reusable **Bicep/ARM templates** for common Azure resources.  
They are designed to be modular, parameterized, and ready for rapid deployment in client or interview scenarios.

---

## 🚀 VM Templates (`/vm`)
- **single-vm.bicep**  
  Deploys a single Windows VM with NIC and NSG.  
  *Use case:* Quick demo or test workload.

- **multi-vm.bicep**  
  Deploys multiple VMs (default: 10) using a loop.  
  *Use case:* Scale-out scenarios, flight tests requiring bulk VM creation.

- **vmss.bicep**  
  Deploys a Virtual Machine Scale Set with autoscaling.  
  *Use case:* Production-ready compute with load balancing.

---

## 🌐 Network Templates (`/network`)
- **vnet.bicep**  
  Creates a simple VNet with a default subnet.  
  *Use case:* Foundation for most deployments.

- **hub-spoke.bicep**  
  Deploys a hub-spoke network topology.  
  *Use case:* Enterprise networking and governance demos.

- **nsg.bicep**  
  Creates a Network Security Group with inbound rules (RDP, HTTP, SSH).  
  *Use case:* Secure VM access.

---

## 🗄️ SQL Templates (`/sql`)
- **sqlserver.bicep**  
  Deploys an Azure SQL Server with admin login.  
  *Use case:* Database server foundation.

- **sqldb.bicep**  
  Creates a SQL Database inside an existing SQL Server.  
  *Use case:* Application data layer.

---

## 📦 Storage Templates (`/storage`)
- **storageaccount.bicep**  
  Deploys a general-purpose Storage Account (RA-GRS replication).  
  *Use case:* Backups, blobs, DR scenarios.

---

## 📊 Monitoring Templates (`/monitoring`)
- **loganalytics.bicep**  
  Creates a Log Analytics workspace.  
  *Use case:* Centralized monitoring and diagnostics.

- **diagnostics.bicep**  
  Configures diagnostic settings to send logs/metrics to Log Analytics.  
  *Use case:* Observability and compliance.

---

## 🔧 Deployment Command 
Run any template with:
```bash
az deployment group create \
  --resource-group <rg-name> \
  --template-file ./templates/<path-to-template>.bicep \
  --parameters <param1>=<value1> <param2>=<value2>

  az deployment group create \
  --resource-group rg-my-avatar-spoke \
  --template-file ./templates/vm/linux-vm.bicep \
  --parameters vmName=avatarlinux adminUsername=azureuser sshPublicKey="$(cat ~/.ssh/id_rsa.pub)"

  az deployment group create \
  --resource-group rg-my-avatar-spoke \
  --template-file ./templates/vm/linux-vmss.bicep \
  --parameters vmssName=avatarlinuxss adminUsername=azureuser sshPublicKey="$(cat ~/.ssh/id_rsa.pub)" instanceCount=3

  az deployment group create \
  --resource-group rg-my-avatar-spoke \
  --template-file ./templates/vm/linux-vmss-lb.bicep \
  --parameters vmssName=avatarlinuxss adminUsername=azureuser sshPublicKey="$(cat ~/.ssh/id_rsa.pub)" instanceCount=3

  az deployment group create \
  --resource-group rg-my-avatar-spoke \
  --template-file ./templates/app/webapp-sql.bicep \
  --parameters webAppName=avatarweb hostingPlanName=avatarplan sqlServerName=avatarsql sqlDbName=appdb adminUsername=sqladmin adminPassword=YourP@ssword123