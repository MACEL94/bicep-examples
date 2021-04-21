param location string = resourceGroup().location
param appName string
param environment string
@allowed([
  'nonprod'
  'prod'
])
param environmentType string
param emailActionGroupId string
param keyVaultName string
param appInsightsSecretUri string
param sqlConnectionStringSecretUri string
param storageSecretUri string

var appServicePlanName = 'plan-${appName}-${environment}'
var appServicePlanSkuName = (environmentType == 'prod') ? 'S1' : 'B1'
var appServicePlanTierName = (environmentType == 'prod') ? 'Standard' : 'Basic'
var appServiceAppName = 'app-${appName}-${environment}'

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
    tier: appServicePlanTierName
  }
}

resource appServicePlan_autoScale 'Microsoft.Insights/autoscalesettings@2015-04-01' = {
  name: 'DefaultAutoscaleProfile'
  location: location
  tags: {
    'hidden-related:${appServicePlan.id}': 'Resource'
    displayName: 'Hosting Plan Auto Scale Settings'
  }
  properties: {
    profiles: [
      {
        name: 'Default'
        capacity: {
          minimum: '1'
          maximum: '3'
          default: '1'
        }
        rules: [
          {
            metricTrigger: {
              metricName: 'CpuPercentage'
              metricResourceUri: appServicePlan.id
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT10M'
              timeAggregation: 'Average'
              operator: 'GreaterThan'
              threshold: 80
            }
            scaleAction: {
              direction: 'Increase'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT10M'
            }
          }
          {
            metricTrigger: {
              metricName: 'CpuPercentage'
              metricResourceUri: appServicePlan.id
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT1H'
              timeAggregation: 'Average'
              operator: 'LessThan'
              threshold: 60
            }
            scaleAction: {
              direction: 'Decrease'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT1H'
            }
          }
        ]
      }
    ]
    enabled: true
    targetResourceUri: appServicePlan.id
  }
}

resource CPUHigh_appServicePlan 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'CPU High - ${appServicePlanName}'
  location: 'global'
  tags: {
    'hidden-related:${appServicePlan.id}': 'Resource'
    displayName: 'Hosting Plan CPU High Alert Rule'
  }
  properties: {
    description: 'The average CPU is high across all the instances of ${appServicePlanName}'
    severity: 3
    enabled: true
    scopes: [
      appServicePlan.id
    ]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT15M'
    criteria: {
      allOf: [
        {
          criterionType: 'StaticThresholdCriterion'
          metricName: 'CpuPercentage'
          metricNamespace: 'Microsoft.Web/serverFarms'
          monitorTemplateType: 8
          name: 'Metric1'
          operator: 'GreaterThan'
          threshold: 80
          timeAggregation: 'Average'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    actions: [
      {
        actionGroupId: emailActionGroupId
      }
    ]
  }
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: appServiceAppName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      netFrameworkVersion: 'v5.0'
      use32BitWorkerProcess: false
      alwaysOn: true
      ftpsState: 'Disabled'
    }
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyVaultName
}

resource appServiceKeyVaultAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid('Key Vault Secret User', appServiceAppName, subscription().subscriptionId)
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')
    principalId: appService.identity.principalId
    principalType: 'ServicePrincipal'
  }
  dependsOn: [
    keyVault
  ]
}

resource appServiceAppSettings 'Microsoft.Web/sites/config@2020-06-01' = {
  name: '${appService.name}/appsettings'
  properties: {
    APPLICATIONINSIGHTS_CONNECTION_STRING: '@Microsoft.KeyVault(SecretUri=${appInsightsSecretUri})'
    APPINSIGHTS_PROFILERFEATURE_VERSION: '1.0.0'
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION: '1.0.0'
    ApplicationInsightsAgent_EXTENSION_VERSION: '~2'
    DiagnosticServices_EXTENSION_VERSION: '~3'
    InstrumentationEngine_EXTENSION_VERSION: '~1'
    SnapshotDebugger_EXTENSION_VERSION: '~1'
    XDT_MicrosoftApplicationInsights_BaseExtensions: '~1'
    XDT_MicrosoftApplicationInsights_Mode: 'recommended'
    XDT_MicrosoftApplicationInsights_PreemptSdk: '1'
    IdentityServer__Key__Type: 'Development'
  }
}

resource appServiceAppConnectionStrings 'Microsoft.Web/sites/config@2020-06-01' = {
  name: '${appService.name}/connectionstrings'
  properties: {
    DefaultConnection: {
      value: '@Microsoft.KeyVault(SecretUri=${sqlConnectionStringSecretUri})'
      type: 'SQLAzure'
    }
    StorageConnectionString: {
      value: '@Microsoft.KeyVault(SecretUri=${storageSecretUri})'
      type: 'Custom'
    }
  }
}

resource serverErrors_appService 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'Server Errors - ${appServiceAppName}'
  location: 'global'
  tags: {
    'hidden-link:${appService.id}': 'Resource'
    displayName: 'Web Service Server Errors Alert Rule'
  }
  properties: {
    description: '${appServiceAppName} has some server errors, status code 5xx.'
    severity: 3
    enabled: true
    scopes: [
      appService.id
    ]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          criterionType: 'StaticThresholdCriterion'
          metricName: 'Http5xx'
          metricNamespace: 'Microsoft.Web/sites'
          monitorTemplateType: 8
          name: 'Metric1'
          operator: 'GreaterThan'
          threshold: 10
          timeAggregation: 'Total'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    actions: [
      {
        actionGroupId: emailActionGroupId
      }
    ]
  }
}

resource forbiddenRequests_appService 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'Forbidden Requests - ${appServiceAppName}'
  location: 'global'
  tags: {
    'hidden-link:${appService.id}': 'Resource'
    displayName: 'Web Service Forbidden Requests Alert Rule'
  }
  properties: {
    description: '${appServiceAppName} has some requests that are forbidden, status code 403.'
    severity: 3
    enabled: true
    scopes: [
      appService.id
    ]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          criterionType: 'StaticThresholdCriterion'
          metricName: 'Http403'
          metricNamespace: 'Microsoft.Web/sites'
          monitorTemplateType: 8
          name: 'Metric1'
          operator: 'GreaterThan'
          threshold: 0
          timeAggregation: 'Total'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    actions: [
      {
        actionGroupId: emailActionGroupId
      }
    ]
  }
}

output appServiceAppName string = appService.name
output appServicePrincipalId string = appService.identity.principalId
