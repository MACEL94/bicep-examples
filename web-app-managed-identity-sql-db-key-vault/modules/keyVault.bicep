param location string = resourceGroup().location
param appName string
param environment string

var keyVaultName = 'kv-${appName}-${environment}'

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForTemplateDeployment: true
    enableRbacAuthorization: true
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }  
  }
}

output keyVaultName string = keyVault.name
output keyVaultId string = keyVault.id
