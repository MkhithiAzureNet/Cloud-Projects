param sqlServerName string
param sqlDbName string = 'demo-db'
param location string = resourceGroup().location
param skuName string = 'Basic'

resource sqlDb 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  name: '${sqlServerName}/${sqlDbName}'
  location: location
  sku: {
    name: skuName
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 2147483648
  }
}