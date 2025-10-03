param sqlServerName string = 'demo-sql-server'
param adminUsername string
@secure()
param adminPassword string
param location string = resourceGroup().location

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: adminUsername
    administratorLoginPassword: adminPassword
    version: '12.0'
  }
}
