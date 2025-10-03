@description('Name of the Linux VM')
param vmName string = 'demo-linux-vm'

@description('Admin username for the VM')
param adminUsername string = 'Nhlanhla'

@secure()
@description('SSH public key for authentication')
param sshPublicKey string

@description('Deployment location')
param location string = 'southafricanorth'

@description('Existing VNet name')
param vnetName string = 'spinning-spoke-net-vnet-01'

@description('Subnet name for the VM NIC')
param subnetName string = 'app-subnet'

resource nic 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: '${vmName}-nic'
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
    owner: 'Nhlanhla'
    role: 'app'
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    osProfile: {
      computerName: vmName
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
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
  tags: {
    env: 'demo'
    owner: 'Nhlanhla'
    role: 'app'
  }
}
