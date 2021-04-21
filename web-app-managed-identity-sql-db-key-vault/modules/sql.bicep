param location string = resourceGroup().location
param appName string
param environment string
param sqlAdminLogin string
param sqlAdminPassword string
param keyVaultId string

var sqlServerName = 'sql-${appName}-${environment}'
var databaseName = 'sqldb-${appName}-${environment}'

resource sqlServer 'Microsoft.Sql/servers@2019-06-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlAdminLogin
    administratorLoginPassword: sqlAdminPassword
    version: '12.0'
  }
}

resource sqlDb 'Microsoft.Sql/servers/databases@2020-08-01-preview' = {
  name: '${sqlServer.name}/${databaseName}'
  location: location
  sku: {
    name: 'S0'
    tier: 'Standard'
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
  }
}

resource sqlServerName_AllowAllWindowsAzureIps 'Microsoft.Sql/servers/firewallRules@2015-05-01-preview' = {
  name: '${sqlServer.name}/AllowAllWindowsAzureIps'
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: last(split(keyVaultId, '/'))
  resource sqlConnectionStringSecret 'secrets' = {
    name: '${sqlServerName}-ConnectionString'
    properties: {
    value: 'Data Source=tcp:${sqlServer.properties.fullyQualifiedDomainName},1433;Initial Catalog=${databaseName};User Id=${sqlServer.properties.administratorLogin}@${sqlServer.properties.fullyQualifiedDomainName};Password=${sqlAdminPassword};'
   }
  }
}

output sqlServerName string = sqlServer.name
output databaseName string = databaseName
output sqlConnectionStringSecretUri string = keyVault::sqlConnectionStringSecret.properties.secretUriWithVersion
