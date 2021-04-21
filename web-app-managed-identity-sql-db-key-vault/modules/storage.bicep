param location string = resourceGroup().location
param appName string
param environment string
@allowed([
  'nonprod'
  'prod'
])
param environmentType string
param keyVaultId string

var storageAccountName = 'st${appName}${environment}'
var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: last(split(keyVaultId, '/'))
  resource storageSecret 'secrets' = {
    name: '${storageAccountName}-ConnectionString'
    properties: {
    value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[1].value}'
   }
  }
}

output storageSecretUri string = keyVault::storageSecret.properties.secretUriWithVersion
