param vmBaseName string = 'demo-linux-vm'
param adminUsername string = 'azureuser'
@secure()
param sshPublicKey string
param instanceCount int = 10
param location string = resourceGroup().location

// Create NICs for each VM
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

// Create multiple Linux VMs
resource vm 'Microsoft.Compute/virtualMachines@2023-09-01' = [for i in range(0, instanceCount): {
  name: '${vmBaseName}${i}'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    osProfile: {
      computerName: '${vmBaseName}${i}'
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: sshPublicKey
            }
          ]
        }
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts'
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
