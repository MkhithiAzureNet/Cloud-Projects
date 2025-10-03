@description('Windows VM name')
param winVmName string = 'app-win-01'

@description('Admin username for the Windows VM')
param adminUsername string = 'nhlanhla'

@secure()
@description('Admin password for the Windows VM')
param adminPassword string

@description('Deployment location')
param location string = 'southafricanorth'

@description('Existing VNet name')
param vnetName string = 'spinning-spoke-net-vnet-01'

@description('Subnet name for the VM NIC')
param subnetName string = 'app-subnet'

/* ---------------- NIC ---------------- */
resource winNic 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: '${winVmName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
          }
        }
      }
    ]
  }
  tags: {
    env: 'demo'
    owner: 'nhlanhla'
    role: 'app-win'
  }
}

/* ---------------- Windows VM ---------------- */
resource winVm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: winVmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    osProfile: {
      computerName: winVmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: winNic.id
        }
      ]
    }
  }
  tags: {
    env: 'demo'
    owner: 'nhlanhla'
    role: 'app-win'
  }
}

/* ---------------- IIS Install Extension ---------------- */
resource iisExtension 'Microsoft.Compute/virtualMachines/extensions@2022-11-01' = {
  parent: winVm
  name: 'IISInstall'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      commandToExecute: 'powershell Add-WindowsFeature Web-Server; echo "IIS Demo Healthy" > C:\\inetpub\\wwwroot\\index.html'
    }
  }
}
