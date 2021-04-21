param appName string = 'tpm-bicep'
param environment string
param environmentType string
param sqlAdminLogin string
@secure()
param sqlAdminPassword string

module keyVaultModule 'modules/keyVault.bicep' = {
  name: 'keyVaultDeploy'
  params:{
    appName: appName
    environment: environment
  }
}

module storageModule 'modules/storage.bicep' = {
  name: 'storageDeploy'
  params:{
    appName: appName
    environment: environment
    environmentType: environmentType
    keyVaultId: keyVaultModule.outputs.keyVaultId
  }
}

module sqlModule 'modules/sql.bicep' = {
  name: 'sqlDeploy'
  params:{
    appName: appName
    environment: environment
    sqlAdminLogin: sqlAdminLogin
    sqlAdminPassword: sqlAdminPassword
    keyVaultId: keyVaultModule.outputs.keyVaultId
  }
}

module appInsightsModule 'modules/appInsights.bicep' = {
  name: 'appInsightsDeploy'
  params: {
    appName: appName
    environment: environment
    environmentType: environmentType
    emailActionGroupId: actionGroupModule.outputs.actionGroupId
    keyVaultId: keyVaultModule.outputs.keyVaultId
  }
}

module appServiceModule 'modules/appService.bicep' = {
  name: 'appServiceDeploy'
  params: {
    appName: appName
    environment: environment
    environmentType: environmentType
    emailActionGroupId: actionGroupModule.outputs.actionGroupId
    keyVaultName: keyVaultModule.outputs.keyVaultName
    appInsightsSecretUri: appInsightsModule.outputs.appInsightsSecretUri
    sqlConnectionStringSecretUri: sqlModule.outputs.sqlConnectionStringSecretUri
    storageSecretUri: storageModule.outputs.storageSecretUri
  }
}

module actionGroupModule 'modules/actionGroup.bicep' = {
  name: 'actionGroupDeploy'
  params:{
    appName: appName
  }
}

output appServiceAppName string = appServiceModule.outputs.appServiceAppName
output sqlServerName string = sqlModule.outputs.sqlServerName
output databaseName string = sqlModule.outputs.databaseName


