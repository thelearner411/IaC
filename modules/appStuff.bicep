
param location string = resourceGroup().location
param appServiceAppBeName string
param appServiceAppFeName string
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

resource appServiceAppBe 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceAppBeName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    }
  }

  resource appServiceAppFe 'Microsoft.Web/sites@2022-03-01' = {
    name: appServiceAppFeName
    location: location
    properties: {
      serverFarmId: appServicePlan.id
      httpsOnly: true
      }
    }

output appServiceAppBeHostName string = appServiceAppBe.properties.defaultHostName
output appServiceAppFeHostName string = appServiceAppFe.properties.defaultHostName

