param location string = resourceGroup().location
param appServiceBeName string
param appServiceFeName string
param appServicePlanName string
@allowed([
  'nonprod'
  'prod'
])
param environmentType string
param dbhost string
param dbuser string
param dbpass string
param dbname string

var appServicePlanSkuName = (environmentType == 'prod') ? 'P2V3' : 'B1'

resource appServicePlan 'Microsoft.Web/serverFarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  kind: 'linux'
  properties: {
    reserved: true
  }
  sku: {
    name: appServicePlanSkuName
  }
}

resource appServiceBe 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceBeName
  location: location
  kind: 'functionapp,linux'
  properties: {
    reserved: true
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'python|3.10'
      appSettings: [
        {
          name: 'DBUSER'
          value: dbuser
        }
        {
          name: 'DBPASS'
          value: dbpass
        }
        {
          name: 'DBNAME'
          value: dbname
        }
        {
          name: 'DBHOST'
          value: dbhost
        }
      ]
    }
  }
}

  resource appServiceFe 'Microsoft.Web/sites@2022-03-01' = {
    name: appServiceFeName
    location: location
    kind: 'functionapp,linux'
    properties: {
      reserved: true
      serverFarmId: appServicePlan.id
      httpsOnly: true
      siteConfig: {
        linuxFxVersion: 'python|3.10'
        appSettings: [
          {
            name: 'DBUSER'
            value: dbuser
          }
          {
            name: 'DBPASS'
            value: dbpass
          }
          {
            name: 'DBNAME'
            value: dbname
          }
          {
            name: 'DBHOST'
            value: dbhost
          }
        ]
      }
    }
  }

output appServiceBeHostName string = appServiceBe.properties.defaultHostName
output appServiceFeHostName string = appServiceFe.properties.defaultHostName

