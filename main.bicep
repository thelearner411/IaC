@sys.description('The web app name for the backend.')
@minLength(3)
@maxLength(30)
param appServiceBeName string = 'mcollins-assignment-be'

@sys.description('The web app name for the frontend.')
@minLength(3)
@maxLength(30)
param appServiceFeName string = 'mcollins-assignment-fe'

@sys.description('The App Service Plan name.')
@minLength(3)
@maxLength(30)
param appServicePlanName string = 'mcollins-assignment-asp'

@sys.description('The storage account name.')
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

  @secure()
  param dbhost string
  @secure()
  param dbuser string
  @secure()
  param dbpass string
  @secure()
  param dbname string

module appService 'modules/appStuff.bicep' = {
  name: 'appService'
  params: { 
    location: location
    appServiceBeName: appServiceBeName
    appServiceFeName: appServiceFeName
    appServicePlanName: appServicePlanName
    environmentType: environmentType
    dbhost: dbhost
    dbuser: dbuser
    dbpass: dbpass
    dbname: dbname
  }
}

  output appServiceBeHostName string = appService.outputs.appServiceBeHostName
  output appServiceFeHostName string = appService.outputs.appServiceFeHostName



    