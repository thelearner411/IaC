
param location string = resourceGroup().location
param appServiceBeName string
param appServiceFeName string
param appServicePlanName string
@allowed([
  'nonprod'
  'prod'
])
param environmentType string

var appServicePlanSkuName = (environmentType == 'prod') ? 'P2V3' : 'B1'

resource appServicePlan 'Microsoft.Web/serverFarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

resource appServiceBe 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceBeName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    }
  }

  resource appServiceFe 'Microsoft.Web/sites@2022-03-01' = {
    name: appServiceFeName
    location: location
    properties: {
      serverFarmId: appServicePlan.id
      httpsOnly: true
      }
    }

output appServiceBeHostName string = appServiceBe.properties.defaultHostName
output appServiceFeHostName string = appServiceFe.properties.defaultHostName


