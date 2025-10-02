param webAppName string = 'demo-webapp'
param hostingPlanName string = 'demo-plan'
param sqlServerName string = 'demo-sql-server'
param sqlDbName string = 'demo-db'
param adminUsername string
@secure()
param adminPassword string
param location string = resourceGroup().location

// App Service Plan
resource plan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: hostingPlanName
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    capacity: 1
  }
  properties: {
    reserved: false
  }
}

// Web App
resource webApp 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: plan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|6.0'
    }
  }
}

// SQL Server
resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: adminUsername
    administratorLoginPassword: adminPassword
    version: '12.0'
  }
}

// SQL Database
resource sqlDb 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  name: '${sqlServerName}/${sqlDbName}'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 2147483648
  }
}

// Connection String (App Service -> SQL)
resource connString 'Microsoft.Web/sites/config@2022-09-01' = {
  name: '${webApp.name}/connectionstrings'
  properties: {
    DefaultConnection: {
      value: 'Server=tcp:${sqlServerName}.database.windows.net,1433;Initial Catalog=${sqlDbName};User ID=${adminUsername};Password=${adminPassword};'
      type: 'SQLAzure'
    }
  }
}