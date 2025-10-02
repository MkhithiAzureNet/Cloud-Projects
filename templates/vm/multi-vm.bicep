param vmBaseName string = 'demo-vm'
param adminUsername string
@secure()
param adminPassword string
param instanceCount int = 10
param location string = resourceGroup().location

resource nic 'Microsoft.Network/networkInterfaces@2023-05-01' = [for i in range(0, instanceCount): {
  name: '${vmBaseName}${i}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'demo-vnet', 'default')
          }
        }
      }
    ]
  }
}]

resource vm 'Microsoft.Compute/virtualMachines@2023-09-01' = [for i in range(0, instanceCount): {
  name: '${vmBaseName}${i}'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    osProfile: {
      computerName: '${vmBaseName}${i}'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic[i].id
        }
      ]
    }
  }
}]