@sys.description('The web app name for the backend.')
@minLength(3)
@maxLength(30)
param appServiceAppBeName string = 'mcollins-assignment-be'

@sys.description('The web app name for the frontend.')
@minLength(3)
@maxLength(30)
param appServiceAppFeName string = 'mcollins-assignment-fe'

@sys.description('The App Service Plan name.')
@minLength(3)
@maxLength(30)
param appServicePlanName string = 'mcollins-assignment-asp'

@sys.description('The atorage account name.')
@minLength(3)
@maxLength(30)
param storageAccountName string = 'mcollinsstorage'

@allowed([
  'nonprod'
  'prod'
  ])
param environmentType string = 'nonprod'
param location string = resourceGroup().location

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'  

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
    name: storageAccountName
    location: location
    sku: {
      name: storageAccountSkuName
    }
    kind: 'StorageV2'
    properties: {
      accessTier: 'Hot'
    }
  }


module appService 'modules/appStuff.bicep' = {
  name: 'appService'
  params: { 
    location: location
    appServiceAppBeName: appServiceAppBeName
    appServiceAppFeName: appServiceAppFeName
    appServicePlanName: appServicePlanName
    environmentType: environmentType
  }
}

  output appServiceAppBeHostName string = appService.outputs.appServiceAppBeHostName
  output appServiceAppFeHostName string = appService.outputs.appServiceAppFeHostName



    